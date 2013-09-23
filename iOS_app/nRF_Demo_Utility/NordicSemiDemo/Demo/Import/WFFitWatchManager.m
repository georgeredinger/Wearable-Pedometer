// Copyright (c) 2011 Nordic Semiconductor. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA.
// Terms and conditions of usage are described in detail in // NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
//
//
//  WFFitWatchManager.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 4/15/11.
//

#import "WFFitWatchManager.h"
#import "WFFitDirectoryEntry.h"
#import <MessageUI/MessageUI.h>

#import "NordicSemiAppDelegate.h"
#import "FitDeviceViewController.h"


#if DBG_FLAG_FIT_WATCH
//
#define DBG_FLAG_FIT_STATUS     TRUE
#define DBG_FLAG_HW_STATE       TRUE
#define DBG_FLAG_PUBLIC         TRUE
#define DBG_FLAG_PRIVATE        TRUE
//
#else
//
#define DBG_FLAG_FIT_STATUS     FALSE
#define DBG_FLAG_HW_STATE       FALSE
#define DBG_FLAG_PUBLIC         FALSE
#define DBG_FLAG_PRIVATE        FALSE
//
#endif

#define PROGRESS_TIMER_INTERVAL 0.1


@interface WFFitWatchManager (_PRIVATE_)

- (void)connectToDevice;
- (void)disconnectDevice;
- (void)doneProcessingFIT:(WFFitDirectoryEntry*)dirEntry;
- (BOOL)downloadNext;
- (NSTimeInterval)getEstimatedTime:(BOOL)isDownloading;
//- (WFSession*)importFIT:(WFFitDirectoryEntry*)dirEntry toContext:(NSManagedObjectContext*)managedObjectContext;
- (void)onProgressTimerTick;
//- (void)processFIT_TM:(WFFitDirectoryEntry*)dirEntry;
- (BOOL)restartDownload;
//- (WFSettingsManager*)settings;
- (void)startProgressTimer;
- (void)stopProgressTimer;

@end


@implementation WFFitWatchManager

@synthesize delegate;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (id)init
{
    if ( (self = [super init]) )
    {
        // set up the hardware connector.
        hardwareConnector = [WFHardwareConnector sharedConnector];
        bShouldBeConnected = FALSE;
        
        connectedDeviceType = WF_ANTFS_DEVTYPE_FE_WATCH;
        importingFromDeviceType = WF_ANTFS_DEVTYPE_FE_WATCH;
        
        directoryEntries = nil;
        filesToImport = nil;
        importIndex = -1;
		
		importedSessions = [[NSMutableArray arrayWithCapacity:5] retain];
        
        progressTimer = nil;
        bDebugging = FALSE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)dealloc
{
	NSLog(@"dealloc WatchManager");
    [self stopProgressTimer];
    
    // disconnect the FIT device.
    [self disconnectDevice];
    
    // release resources.
    [delegate release];
    [directoryEntries release];
    [filesToImport release];
	[importedSessions release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark WFHardwareConnectorDelegate Implementation

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector stateChanged:(WFHardwareConnectorState_t)currentState
{
    NSLog(@"hardwareConnectorStateChanged currentState=0x%02X, hwConnState=0x%02X", currentState, [hwConnector currentState]);
    
    // check for ready state.
    if ( (currentState & WF_HWCONN_STATE_CONNECTED) && (currentState & WF_HWCONN_STATE_ACTIVE) )
    {
        NSLog(@"hardwareConnectorStateChanged HWCONN ACTIVE.");

        // if the FIT device should be connected, ensure that it is.
        if ( bShouldBeConnected && afsFileManager == nil )
        {
            NSLog(@"hardwareConnectorStateChanged CREATING AFS INSTANCE.");
            
            [self connectToDevice];
        }
    }
}


#pragma mark -
#pragma mark WFAntFileManagerDelegate Implementation

//--------------------------------------------------------------------------------
- (void)antFSDevice:(WFAntFSDevice *)fsDevice instanceCreated:(BOOL)bSuccess
{
    NSLog(@"afmInstanceCreated bSuccess=%d, RETAIN COUNT=%d", bSuccess, [fsDevice retainCount]);
    
	if (bSuccess && [fsDevice isKindOfClass:[WFFitDeviceManager class]] )
	{
		afsFileManager = (WFFitDeviceManager*)fsDevice;
		afsFileManager.delegate = self;
		
		[afsFileManager connectToDevice:aucDevicePassword passkeyLength:ucDevicePasswordLength];
	}
	else
	{
        [delegate fitWatch:self didFailToCreateInstance:TRUE];
	}
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager downloadFinished:(BOOL)bSuccess filePath:(NSString*)filePath
{
    NSLog(@"afmDownloadFinished bSuccess=%d", bSuccess);
    
    // if the download succeeded, import the FIT.
	if (bSuccess)
	{
        // copy the FIT file to local temp.
        //
        // the FIT processing is handled by a worker thread.  this
        // thread runs asynchronously with the download process (if
        // multiple files are specified).  the FIT needs to be copied
        // to a local cache so that the next download wil not overwrite.
        WFFitDirectoryEntry* dirEntry = (WFFitDirectoryEntry*)[filesToImport objectAtIndex:importIndex];
        NSString* fitPath = [dirEntry filePath];
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:fitPath error:nil];
        [fm copyItemAtPath:filePath toPath:fitPath error:nil];
        NSArray *pcoms = [fitPath pathComponents];
        NSString *filename = [pcoms objectAtIndex:[pcoms count]-1];
        // nRF demo: email the FIT file
        MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
        email.mailComposeDelegate = (FitDeviceViewController*)delegate;
        [email setSubject:@"Your FIT File"];
        NSData *fitFile = [NSData dataWithContentsOfFile:fitPath];
        [email addAttachmentData:fitFile mimeType:@"application/octet-stream" fileName:filename];
        [email setMessageBody:@"Attached is your FIT file from the NordicSemiconductor nRF demo app. " isHTML:NO];
        email.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [(FitDeviceViewController*)delegate presentModalViewController:email animated:YES];
        [email release];
        
        // import the FIT file into your app
        //
        // the FIT processing is done in a worker thread.  spawn
        // the thread passing the dirEntry of the FIT to process.
    //    [NSThread detachNewThreadSelector:@selector(processFIT_TM:) toTarget:self withObject:dirEntry];
        
        // download the next file
        [self downloadNext];
	}
    //
    // otherwise, re-start the download.
    else
    {
        // decrement the import index and retry download.
        importIndex--;
        [self downloadNext];
    }
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager downloadProgress:(ULONG)bytesReceived
{
    NSLog(@"DOWNLOAD PROGRESS received %lu of %lu bytes.", bytesReceived, ulFileSize);
    
    // update the status to the delegate.
    if ( [delegate respondsToSelector:@selector(fitWatch:didUpdateProgress:forState:)] )
    {
        // calculate the download percentage.
        float percent = (float)bytesReceived / (float)ulFileSize;
        
        // send update to the delegate.
        [delegate fitWatch:self didUpdateProgress:percent forState:WF_FIT_IMPORT_STATE_DOWNLOAD];
    }
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager parseFITProgress:(float)progress
{
    //DEBUGLOG(DBG_FLAG_FIT_STATUS, @"FIT PARSE PROGRESS %1.2f.", progress);
    
    // update the status to the delegate.
    if ( [delegate respondsToSelector:@selector(fitWatch:didUpdateProgress:forState:)] )
    {
        // send update to the delegate.
        [delegate fitWatch:self didUpdateProgress:progress forState:WF_FIT_IMPORT_STATE_PARSE];
    }
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager receivedDirectoryInfo:(WFAntFSDirectory*)directoryInfo
{
    NSLog(@"afmReceivedDirectoryInfo");
    
    // parse and cache the directory entries.
    [directoryEntries release];
    directoryEntries = [[directoryInfo getActivityEntries] retain];
    
    // check whether there is an import in progress.
    if ( ![self restartDownload] )
    {
        // no interrupted download, send the directory info to the delegate.
        [delegate fitWatch:self didReceiveDirectoryInfo:directoryEntries];
    }
 }

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager receivedResponse:(ANTFS_RESPONSE)responseCode
{
	switch (responseCode)
	{
            ////////////////////////////////////////////////////////////////////
            //
            // CONNECTION RESPONSES
                        
		case ANTFS_RESPONSE_OPEN_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_OPEN_PASS");
			break;
			
		case ANTFS_RESPONSE_SERIAL_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_SERIAL_FAIL");
            // reset the fisica.  when the HW state changes to READY,
            // the state change handler will re-initiate the connection.
            //
            // if the ANT manager is valid, releasing it will cause
            // a fisica reset, which includes an ANT chip reset.
            if ( afsFileManager )
            {
                [self disconnectDevice];
            }
            // otherwise, reset the fisica explicitly.
            else
            {
                [hardwareConnector resetConnections];
            }
			break;
			
		case ANTFS_RESPONSE_CONNECT_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_CONNECT_PASS clientSerial=0x%08X", (unsigned int)[afsFileManager clientSerialNumber]);
            
            // the device type is updated when the connection is made.
            connectedDeviceType = [antFileManager deviceType];
            
            // the delegate should load the passkey for the new device type.
            [delegate fitWatch:self deviceConnected:connectedDeviceType];
			break;
			
		case ANTFS_RESPONSE_DISCONNECT_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DISCONNECT_PASS");
            break;
		case ANTFS_RESPONSE_CONNECTION_LOST:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_CONNECTION_LOST");
			[self disconnectDevice];
			break;
			
            ////////////////////////////////////////////////////////////////////
            //
            // AUTHENTICATION RESPONSES
            
		case ANTFS_RESPONSE_AUTHENTICATE_NA:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_AUTHENTICATE_NA");
			break;
			
		case ANTFS_RESPONSE_AUTHENTICATE_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_AUTHENTICATE_PASS");
			//[connectButton setTitle:@"Reading..." forState:UIControlStateNormal];
			[afsFileManager requestDirectoryInfo];
			break;
			
		case ANTFS_RESPONSE_AUTHENTICATE_REJECT:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_AUTHENTICATE_REJECT");
            [self disconnectDevice];
            [delegate fitWatch:self didFailAuthentication:FALSE];
            break;
		case ANTFS_RESPONSE_AUTHENTICATE_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_AUTHENTICATE_FAIL");
            [self disconnectDevice];
            [delegate fitWatch:self didFailAuthentication:TRUE];
			break;
			
            
            ////////////////////////////////////////////////////////////////////
            //
            // DOWNLOAD RESPONSES
            
		case ANTFS_RESPONSE_DOWNLOAD_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DOWNLOAD_PASS");
			break;
			
		case ANTFS_RESPONSE_DOWNLOAD_INVALID_INDEX:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DOWNLOAD_INVALID_INDEX");
            
            // the download is invalid, move on to the next.
            [self downloadNext];
            break;
		case ANTFS_RESPONSE_DOWNLOAD_FILE_NOT_READABLE:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DOWNLOAD_FILE_NOT_READABLE");
            
            // the download is invalid, move on to the next.
            [self downloadNext];
            break;
		case ANTFS_RESPONSE_DOWNLOAD_REJECT:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DOWNLOAD_REJECT");
            
            // the download reject is likely due to the API requesting the next
            // chunk of a corrupted download.  disconnect and retry.
            [self disconnectDevice];
            break;
		case ANTFS_RESPONSE_DOWNLOAD_NOT_READY:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DOWNLOAD_NOT_READY");
		case ANTFS_RESPONSE_DOWNLOAD_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_DOWNLOAD_FAIL");
            
            // if the directory entry array is nil, this likely a
            // download failure for the directory in this case, the
            // directory download is retried.  otherwise, the
            // download is retried.  if either retry case fails,
            // the FIT device is disconnected and reset.
            if ( (directoryEntries == nil && ![afsFileManager requestDirectoryInfo]) || ![self restartDownload] )
            {
                // download retry failed, disconnect the device.
                // this will cause a fisica reset - when the
                // reset is complete, the state change handler
                // will re-connect.  once connected, the directory
                // will be downloaded, then another retry.
                [self disconnectDevice];
            }
			break;
			
            
            ////////////////////////////////////////////////////////////////////
            //
            // UNPROCESSED RESPONSES
            
		case ANTFS_RESPONSE_UPLOAD_INVALID_INDEX:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_UPLOAD_INVALID_INDEX");
			break;
		case ANTFS_RESPONSE_UPLOAD_FILE_NOT_WRITEABLE:;
            NSLog(@"receivedResponse  ANTFS_RESPONSE_UPLOAD_FILE_NOT_WRITEABLE");
			break;
		case ANTFS_RESPONSE_UPLOAD_INSUFFICIENT_SPACE:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_UPLOAD_INSUFFICIENT_SPACE");
			break;
		case ANTFS_RESPONSE_UPLOAD_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_UPLOAD_PASS");
            break;
		case ANTFS_RESPONSE_UPLOAD_REJECT:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_UPLOAD_REJECT");
            break;
		case ANTFS_RESPONSE_UPLOAD_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_UPLOAD_FAIL");
			break;
			
		case ANTFS_RESPONSE_ERASE_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_ERASE_PASS");
			break;
		case ANTFS_RESPONSE_ERASE_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_ERASE_FAIL");
			break;

		case ANTFS_RESPONSE_MANUAL_TRANSFER_PASS:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_MANUAL_TRANSFER_PASS");
			break;
		case ANTFS_RESPONSE_MANUAL_TRANSFER_TRANSMIT_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_MANUAL_TRANSFER_TRANSMIT_FAIL");
			break;
		case ANTFS_RESPONSE_MANUAL_TRANSFER_RESPONSE_FAIL:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_MANUAL_TRANSFER_RESPONSE_FAIL");
			break;
			
		case ANTFS_RESPONSE_CANCEL_DONE:
            NSLog(@"receivedResponse  ANTFS_RESPONSE_CANCEL_DONE");
			break;
			
		default:
            NSLog(@"receivedResponse  UNKNOWN 0x%02X", responseCode);
			break;
	}
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager updatePasskey:(UCHAR*)pucPasskey length:(UCHAR)ucLength
{
    NSLog(@"afmUpdatePasskey ucLength=%u", ucLength);
    
	// copy the updated passkey.
	memset(aucDevicePassword, 0, WF_ANTFS_PASSWORD_MAX_LENGTH);
	memcpy(aucDevicePassword, pucPasskey, ucLength);
	ucDevicePasswordLength = ucLength;
	
	// convert the passkey to a string.
	NSString* passkey = @"";
	for (int i=0; i<(ucLength-1); i++)
	{
		// append the current byte to the passkey string.
		passkey = [passkey stringByAppendingFormat:@"%02X,", aucDevicePassword[i]];
	}
	// append the last byte.
	passkey = [passkey stringByAppendingFormat:@"%02X", aucDevicePassword[ucLength-1]];
	
	// save the passkey to the settings.
    
    NordicSemiAppDelegate* app = ((NordicSemiAppDelegate *)[[UIApplication sharedApplication] delegate]);
    [app savePasskey:passkey forDeviceType:connectedDeviceType];
}


#pragma mark -
#pragma mark WFFitWatchManager Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)connectToDevice
{
    NSLog(@"connectToDevice");
    
    // check for an existing connection.
	if (afsFileManager)
    {
        // release the existing connection.  this will cause a hardware
        // connector reset.  when the reset is complete, the state change
        // handler will initiate the new connection.
        [hardwareConnector releaseAntFSDevice:afsFileManager];
        afsFileManager = nil;
        
        bShouldBeConnected = TRUE;
    }
	else
    {
        // if the connection was interrupted after the download was started,
        // the originally connected device type should be specified.
        WFAntFSDeviceType_t devType;
        if ( importingFromDeviceType != WF_ANTFS_DEVTYPE_FE_WATCH )
        {
            devType = importingFromDeviceType;
        }
        // otherwise, connect to any supported Garmin watch.
        else
        {
            devType = WF_ANTFS_DEVTYPE_GARMIN_WATCH;
        }
        //
        // TODO:  check return and create watchdog timer for instance creation.
        [hardwareConnector requestAntFSDevice:devType toDelegate:self];
    }
}

//--------------------------------------------------------------------------------
- (void)disconnectDevice
{
    NSLog(@"disconnectDevice");
    
	if (afsFileManager)
    {
        [afsFileManager disconnectDevice];
        [hardwareConnector releaseAntFSDevice:afsFileManager];
        afsFileManager = nil;
    }
}

//--------------------------------------------------------------------------------
- (void)doneProcessingFIT:(WFFitDirectoryEntry*)dirEntry
{
    // decrement the remainng file count.
    remainingFileCount--;
    
    // endConnection sets the remaining count to zero.  if
    // the thread completes after this, the count will go
    // negative.  ensure that the count remains zero.
    if ( remainingFileCount < 0 )
    {
        remainingFileCount = 0;
    }
    
    NSLog(@"doneProcessingFIT filesRemaining=%d", remainingFileCount);

    // if no more files to process, alert the delegate.
    if ( remainingFileCount == 0 )
    {
        // if not cancelled, the process has completed normally.
        if ( !bCancel )
        {
            NSLog(@"doneProcessingFIT IMPORT COMPLETE - COMMITTING DB");

            // all files have been downloaded and processed.
            // reease the import array.
            [filesToImport release];
            filesToImport = nil;
			[importedSessions removeAllObjects];
            
            // alert the delegate that the import is done.
            //
            // TODO:  error checking on import.
            [delegate fitWatch:self didFinishImport:TRUE];
        }
        
        // otherwise, the process was cancelled.
        else
        {
            NSLog(@"doneProcessingFIT IMPORT CANCELLED - ROLL BACK DB");
            
			[importedSessions removeAllObjects];
        }
    }
}

//--------------------------------------------------------------------------------
- (BOOL)downloadNext
{
    BOOL retVal = FALSE;
    
    // increment the import index.
    importIndex++;
    NSLog(@"downloadNext importIndex=%d", importIndex);
    
    // attempt to download the next file.
    if ( importIndex < [filesToImport count] )
    {
        // get the file info.
        WFFitDirectoryEntry* dirEntry = (WFFitDirectoryEntry*)[filesToImport objectAtIndex:importIndex];
        WFFitFileInfo* fileInfo = dirEntry.fileInfo;
        
        if ( fileInfo )
        {
            // send the download request.
            ulFileSize = fileInfo.ulFileSize;
            retVal = [afsFileManager requestFile:fileInfo.usFileIndex fileSize:fileInfo.ulFileSize];
            
            // update the status to the delegate.
            if ( [delegate respondsToSelector:@selector(fitWatch:didUpdateProgress:forState:)] )
            {
                // send update to the delegate.
                [delegate fitWatch:self didUpdateProgress:0 forState:WF_FIT_IMPORT_STATE_DOWNLOAD];
            }
        }
    }
    //
    // no more files to download.
    else
    {
        NSLog(@"downloadNext FINISHED DOWNLOADS fileCount=%d", [filesToImport count]);
        
        // disconnect the device - no need to keep the radio open
        // while the last FIT file is being processed.
     //   bShouldBeConnected = FALSE;
     //   [afsFileManager disconnectDevice];
        retVal = TRUE;
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (NSTimeInterval)getEstimatedTime:(BOOL)isDownloading
{
    const float bytesPerSecond = 3000.0 / 8.0;   // download estimate ~ 3 kbps.
    const float processingFactor = 0.2;          // estimate processing time at 20% of download time.
    
    float bytesRemaining = 0;
    float currentDownloadSize = 0;
    
    // calculate the remaining bytes.
    for ( int i=importIndex; i<[filesToImport count]; i++ )
    {
        WFFitFileInfo* fileInfo = ((WFFitDirectoryEntry*)[filesToImport objectAtIndex:i]).fileInfo;
        
        // process the current download.
        if ( i==importIndex )
        {
            currentDownloadSize = fileInfo.ulFileSize;
            
            if ( isDownloading )
            {
                bytesRemaining += fileInfo.ulFileSize;
            }
        }
        else
        {
            bytesRemaining += fileInfo.ulFileSize;
        }
    }
    
    // estimate the time remaining.
    // the average download time during tests is 3 kbps,
    // double the time for the average download rate.
    NSTimeInterval retVal = (bytesRemaining / bytesPerSecond) * 2;
    
    // add 20% for FIT import processing.
    retVal += (retVal * processingFactor);
    
    // if the current file is already downloaded, add
    // processing factor for the file.
    if ( !isDownloading )
    {
        retVal += ((currentDownloadSize/bytesPerSecond) * processingFactor);
    }
    
    return retVal;
}
/*
//--------------------------------------------------------------------------------
- (WFSession*)importFIT:(WFFitDirectoryEntry*)dirEntry toContext:(NSManagedObjectContext*)managedObjectContext
{
    WFSession* retVal = nil;
    
    // parse the FIT file.
    NSString* fitPath = [dirEntry filePath];
    NSLog(@"importFIT path=%@", fitPath);
	
	// the FIT parser in the API is not thread-safe.  allowing multiple
	// threads to run the parser would not improve performance anyhow.
	WFFitActivityFileData* fitData = nil;
	@synchronized(self)
	{
		fitData = [[afsFileManager getFitActivityFromFile:fitPath cancelPointer:&bCancel] retain];
    }
	
	// check whether the import was cancelled.
	if ( bCancel )
	{
		NSLog(@"importFIT IMPORT CANCELLED - BEFORE LOOP");
		
		// the import was cancelled, exit.
		[fitData release];
		return nil;
	}
	
    // ensure valid FIT file.
    if ( fitData )
    {
        NSLog(@"importFIT WFFitActivityFileData: serial_number=%lu, time_created=%lu, manufacturer=%u, product=%u, number=%u, type=%u\n"
                 "WFFitDeviceInfo:  timestamp=%lu, cum_operating_time=%lu\n WFFitMessageActivity localTimestamp=%@",
                 fitData.fileId.pstFileId->serial_number, fitData.fileId.pstFileId->time_created, fitData.fileId.pstFileId->manufacturer,
                 fitData.fileId.pstFileId->product, fitData.fileId.pstFileId->number, fitData.fileId.pstFileId->type,
                 fitData.deviceInfo.pstDeviceInfo->timestamp, fitData.deviceInfo.pstDeviceInfo->cum_operating_time,
                 [(WFFitMessageActivity*)[fitData.activityRecords objectAtIndex:0] stringFromLocalTimestamp]);
        
        NSLog(@"importFIT sessionRecords:%d lapRecords:%d\n"
                 "dataRecords:%d eventRecords:%d workoutRecords:%d activityRecords:%d",
                 [fitData.sessionRecords count], [fitData.lapRecords count], [fitData.dataRecords count],
                 [fitData.eventRecords count], [fitData.workoutRecords count], [fitData.activityRecords count]);
        
        // create a new WFSession container for the workout import.
        //
        // the session creation is synchronized (using mutex lock), so
        // that two thread will not create a session simultaneously.
        @synchronized(self)
        {
            // create the session.
            retVal = (WFSession *)[NSEntityDescription
                                   insertNewObjectForEntityForName:@"WFSession"
                                   inManagedObjectContext:managedObjectContext];
			
			// add the session instance to the cache.
			//
			// this ensures that the session instance remains
			// valid until it is processed and saved.
			[importedSessions addObject:retVal];
        }
        
        // start the progress timer.
        [self performSelectorOnMainThread:@selector(startProgressTimer) withObject:nil waitUntilDone:FALSE];
        
        // separate FIT data into sessions (WF workouts)
        processedRecordCount = 0;
        totalRecordCount = [fitData.dataRecords count];
        for ( WFFitMessageSession* woRec in fitData.sessionRecords )
        {
            // create and configure the workout instance.
            WFWorkout* workout = (WFWorkout*)[NSEntityDescription
                                              insertNewObjectForEntityForName:@"WFWorkout"
                                              inManagedObjectContext:managedObjectContext];
            [retVal addWorkoutsObject:workout];
            workout.session = retVal;
			
			// process the workout data.
            [workout importFromFIT:fitData usingWorkoutRecord:woRec cancelPointer:&bCancel progressPointer:&processedRecordCount];
			
			// check whether the import was cancelled.
			if ( bCancel )
			{
				NSLog(@"importFIT IMPORT CANCELLED - IN LOOP");
				
				// the import was cancelled, exit the loop.
				break;
			}
			
			// set the FIT timestamp for the imported workout.
			workout.fitTimestamp = [NSNumber numberWithDouble:[dirEntry.fileInfo.timestamp timeIntervalSinceReferenceDate]];
            
            // copy the FIT file to the history folder.
            //
            // MMOORE:  there may be cases (such as multi-sport workouts) where
            // a single FIT file contains more than one workout.  this may need
            // to be dealt with later.  for now, there will be multiple FIT files.
            NSString* histPath = [[WFUtility applicationDocumentsDirectory] stringByAppendingPathComponent:@"history"];
            [[NSFileManager defaultManager] createDirectoryAtPath:histPath withIntermediateDirectories:FALSE attributes:nil error:nil];
            histPath = [histPath stringByAppendingPathComponent:[workout fitFileNameFromTime]];
            [[NSFileManager defaultManager] copyItemAtPath:fitPath toPath:histPath error:nil];
        }
    }
    
    [fitData release];
    fitData = nil;
    
    return retVal;
}
*/

//--------------------------------------------------------------------------------
- (void)onProgressTimerTick
{
    // update the status to the delegate.
    if ( [delegate respondsToSelector:@selector(fitWatch:didUpdateProgress:forState:)] )
    {
        // calculate the download percentage.
        float percent = (float)processedRecordCount / (float)totalRecordCount;
        
        // send update to the delegate.
        [delegate fitWatch:self didUpdateProgress:percent forState:WF_FIT_IMPORT_STATE_PROCESS];
    }
}
/*
//--------------------------------------------------------------------------------
- (void)processFIT_TM:(WFFitDirectoryEntry*)dirEntry
{
    NSLog(@"processFIT_TM filesRemaining=%d", remainingFileCount);

	// an autorelease pool to prevent the build-up of temporary objects.
	NSAutoreleasePool *releasePool = [[NSAutoreleasePool alloc] init];
	
    // ensure the dirEntry remains valid for thread duration.
    [dirEntry retain];
	
	// create a managed object context for this import.
    FisicaAppDelegate* app = ((FisicaAppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSPersistentStoreCoordinator* psc = [app persistentStoreCoordinator];
	NSManagedObjectContext* managedObjectContext = nil;
    if ( psc != nil )
	{
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: psc];
        [managedObjectContext setUndoManager:nil];
    }
	
    // process the FIT file.
    WFSession* session = [self importFIT:dirEntry toContext:managedObjectContext];
    
    // stop the progress timer.
    [self performSelectorOnMainThread:@selector(stopProgressTimer) withObject:nil waitUntilDone:FALSE];
    
	// if the operation completed, save the context.
	if ( !bCancel )
	{
		[WFUtility saveContextData:managedObjectContext];
	}
	// otherwise, roll back the changes.
	else if ( session != nil ) 
	{
        // if the operation was cancelled, delete the partially imported session.
        [managedObjectContext deleteObject:session];
		[WFUtility saveContextData:managedObjectContext];
	}
	
    // if debugging, the WFAntFileManager was alloced directly.
    if ( bDebugging )
    {
        afsFileManager.delegate = nil;
        [afsFileManager release];
        afsFileManager = nil;
    }
    
    // invoke the FIT processing done method on the main thread.
    [self performSelectorOnMainThread:@selector(doneProcessingFIT:) withObject:dirEntry waitUntilDone:FALSE];
    
    // delete the working copy of the FIT file.
    [[NSFileManager defaultManager] removeItemAtPath:[dirEntry filePath] error:nil];
    
	// release resources and drain the auto-release pool.
	[managedObjectContext release];
    [dirEntry release];
	[releasePool drain];
}
*/

//--------------------------------------------------------------------------------
- (BOOL)restartDownload
{
    NSLog(@"restartDownload");
    BOOL retVal = FALSE;
    
    // check whether there is an import in progress.
    if ( importIndex >= 0 && importIndex <= [filesToImport count] )
    {
        
        // the last download did not complete.
        // decrement the import index and try again.
        importIndex--;
        retVal = [self downloadNext];
    }
    
    return retVal;
}

/*
//--------------------------------------------------------------------------------
- (WFSettingsManager*)settings
{
	return ((FisicaAppDelegate *)[[UIApplication sharedApplication] delegate]).settingsManager;
}
*/

//--------------------------------------------------------------------------------
- (void)startProgressTimer
{
	if ( [progressTimer isValid] ) [progressTimer invalidate];
	[progressTimer release];
	progressTimer = [[NSTimer timerWithTimeInterval:PROGRESS_TIMER_INTERVAL target:self selector:@selector(onProgressTimerTick) userInfo:nil repeats:YES] retain];
	[[NSRunLoop mainRunLoop] addTimer:progressTimer forMode:NSDefaultRunLoopMode];
}

//--------------------------------------------------------------------------------
- (void)stopProgressTimer
{
	if ( [progressTimer isValid] ) [progressTimer invalidate];
	[progressTimer release];
	progressTimer = nil;
}


#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (BOOL)beginConnection
{
    // reset internal state.
    bShouldBeConnected = TRUE;
    importIndex = -1;
	[importedSessions removeAllObjects];
    [directoryEntries release];
    directoryEntries = nil;
    [filesToImport release];
    filesToImport = nil;
    //
    connectedDeviceType = WF_ANTFS_DEVTYPE_FE_WATCH;
    importingFromDeviceType = WF_ANTFS_DEVTYPE_FE_WATCH;

    // configure the HW connector.
    hwConnDelegate = hardwareConnector.delegate; // cache the previous HW delegate.
    NSLog(@"beginConnection hwConnDelegate=[%@]", hwConnDelegate);
    hardwareConnector.delegate = self;

    // connect the device.
    [self connectToDevice];
    
    return TRUE;
}

//--------------------------------------------------------------------------------
- (BOOL)beginImport:(NSArray *)files
{
    // MMOORE:  2/26/2011 this class was originally designed to process more
    // than one file at a time.  however, due to user experience concerns
    // and other factors, there is now a limit of one file at a time.
    if ( [files count] != 1 )
    {
        return FALSE;
    }
    
    // set the device type for import.
    //
    // this is used in case the download is interrupted.  the connected
    // device type when import begins should be specified if the download
    // is interrupted and a re-connect is initiated.  this will prevent
    // another type being connected at re-connect.
    importingFromDeviceType = connectedDeviceType;
    
    // cache the file array.
    [filesToImport release];
    filesToImport = [files retain];
    
    // update the number of files to be processed.
    remainingFileCount = [filesToImport count];
    
    // attempt to download the first file.
    bCancel = FALSE;
    importIndex = -1;
    return [self downloadNext];
}

/*
//--------------------------------------------------------------------------------
- (void)debugImport:(NSString*)fitName
{
    // get the path to the FIT file (in history folder).
    NSString* fitPath = [[WFUtility applicationDocumentsDirectory] stringByAppendingPathComponent:@"history"];
    fitPath = [fitPath stringByAppendingPathComponent:[fitName stringByAppendingString:@".fit"]];
    NSLog(@"debugImport fitPath=%@", fitPath);
    
    // check whether the file exists.
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL bExists = [fm fileExistsAtPath:fitPath];
    
    // if the file does not exist, attempt to copy from the bundle.
    if ( !bExists )
    {
        NSString* histPath = [[WFUtility applicationDocumentsDirectory] stringByAppendingPathComponent:@"history"];
        [fm createDirectoryAtPath:histPath withIntermediateDirectories:FALSE attributes:nil error:nil];
        NSString* tempPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fitName] stringByAppendingString:@".fit"];
        BOOL bCopied = [fm copyItemAtPath:tempPath toPath:fitPath error:nil];
        NSLog(@"debugImport exists:%@ copied:%@\nfitPath=%@\ntempPath=%@", bExists?@"TRUE":@"FALSE", bCopied?@"TRUE":@"FALSE", fitPath, tempPath);
        #pragma unused(bCopied)
    }
    
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd-HHmmss"];
	NSDate* fitTimestamp = [df dateFromString:fitName];
	[df release];
	df = nil;
    
    WFFitFileInfo* fileInfo = [[WFFitFileInfo alloc] init];
    fileInfo.timestamp = fitTimestamp;
    WFFitDirectoryEntry* dirEntry = [[WFFitDirectoryEntry alloc] initWithFileInfo:fileInfo];
    [fileInfo release];
    fileInfo = nil;
    
    [[NSFileManager defaultManager] copyItemAtPath:fitPath toPath:[dirEntry filePath] error:nil];
    if ( afsFileManager == nil )
    {
        afsFileManager = [WFFitDeviceManager alloc];
        afsFileManager.delegate = self;
        bDebugging = TRUE;
    }
    
    [NSThread detachNewThreadSelector:@selector(processFIT_TM:) toTarget:self withObject:dirEntry];
    [dirEntry release];
    dirEntry = nil;
    return;
}
*/
 
//--------------------------------------------------------------------------------
- (BOOL)endConnection
{
    // restore the previous HW delegate.
    NSLog(@"endConnection hwConnDelegate=[%@]", hwConnDelegate);
    hardwareConnector.delegate = hwConnDelegate;
    
    // reset internal state.
    bShouldBeConnected = FALSE;
    bCancel = TRUE;
    importIndex = -1;
    remainingFileCount = 0;
    [directoryEntries release];
    directoryEntries = nil;
    [filesToImport release];
    filesToImport = nil;
    
    // disconnect the device.
    [self disconnectDevice];
    
    return TRUE;
}

//--------------------------------------------------------------------------------
- (BOOL)loadPasskey
{
    BOOL retVal = FALSE;
    
    // load the passkey string.
    NordicSemiAppDelegate* app = ((NordicSemiAppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSString* passkey = [app getPasskey:connectedDeviceType];
    memset(aucDevicePassword, 0, WF_ANTFS_PASSWORD_MAX_LENGTH);
    
    // ensure valid passkey.
    if ( passkey && [passkey length] )
    {
        retVal = TRUE;
        
        // separate into bytes.
        NSArray* bytes = [passkey componentsSeparatedByString:@","];
        
        // parse bytes.
        ucDevicePasswordLength = [bytes count];
        for (int i=0; i<ucDevicePasswordLength; i++)
        {
            uint scanInt;
            [[NSScanner scannerWithString:(NSString*)[bytes objectAtIndex:i]] scanHexInt:&scanInt];
            aucDevicePassword[i] = (UCHAR)scanInt;
        }
    }
    
    // if the passkey is loaded, update on the AFS manager.
    if ( retVal )
    {
		[afsFileManager setDevicePasskey:aucDevicePassword passkeyLength:ucDevicePasswordLength];
    }
    
    return retVal;
}

@end
