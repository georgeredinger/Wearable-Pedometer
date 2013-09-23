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
//  WFFitDirectoryEntry.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 4/18/11.
//

#import "WFFitDirectoryEntry.h"


@implementation WFFitDirectoryEntry

@synthesize fileInfo;
@synthesize isSelected;
@synthesize hasBeenImported;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [fileInfo release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark WFFitDirectoryEntry Implementation

//--------------------------------------------------------------------------------
- (NSComparisonResult)compareTimestamp:(WFFitDirectoryEntry*)anEntry
{
    // calling compare: on the timeestamp of the other file
    // should result in descending (latest first) order.
    NSComparisonResult retVal = [anEntry.fileInfo.timestamp compare:self.fileInfo.timestamp];
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)filePath
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateFormat = @"yyyy-MM-dd-HHmmss";
    NSString* retVal = [df stringFromDate:fileInfo.timestamp];
    [df release];
    df = nil;
    
    retVal = [retVal stringByAppendingString:@".fit"];
    retVal = [NSTemporaryDirectory() stringByAppendingPathComponent:retVal];
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (id)initWithFileInfo:(WFFitFileInfo*)info
{
    if ( (self = [super init]) )
    {
        fileInfo = [info retain];
        isSelected = FALSE;
        hasBeenImported = FALSE;
    }
    
    return self;
}


#pragma mark -
#pragma mark WFFitDirectoryEntry Class Method Implementation

//--------------------------------------------------------------------------------
+ (NSArray*)directoryEntriesFromFileArray:(NSArray*)fileArray includeImported:(BOOL)bImported
{
    NSMutableArray* entries = [NSMutableArray arrayWithCapacity:[fileArray count]];
    for ( WFFitFileInfo* fileInfo in fileArray )
    {
        // create a directory entry instance.
        WFFitDirectoryEntry* de = [[WFFitDirectoryEntry alloc] initWithFileInfo:fileInfo];
    /*    
        // check whether the workout has already been imported.
        FisicaAppDelegate* app = (FisicaAppDelegate*)[UIApplication sharedApplication].delegate;
        NSError *error = nil;
        NSNumber* fitTimestamp = [NSNumber numberWithDouble:[fileInfo.timestamp timeIntervalSinceReferenceDate]];
        NSDictionary* varDict = [NSDictionary dictionaryWithObjectsAndKeys:fitTimestamp, @"FIT_TIME", nil];
        NSFetchRequest* fetchRequest = [app.managedObjectModel fetchRequestFromTemplateWithName:@"getWorkoutFromFitTimestamp" substitutionVariables:varDict];
        NSArray *results = [app.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ( results && [results count] )
        {
            de.hasBeenImported = TRUE;
        }
        */
        // add to the temp array.
        if ( bImported || !de.hasBeenImported )
        {
            [entries addObject:de];
        }
        [de release];
        de = nil;
    }
    
    // sort the array descending (newest first).
	NSArray* retVal = [entries sortedArrayUsingSelector:@selector(compareTimestamp:)];
    
    // select the latest entry.
    if ( [retVal count] > 0 )
    {
        // look for the latest file which has not been downloaded.
        BOOL bFoundFile = FALSE;
        for ( int i=0; i<[retVal count]; i++ )
        {
            WFFitDirectoryEntry* de = (WFFitDirectoryEntry*)[retVal objectAtIndex:i];
            if ( !(de.fileInfo.ucGeneralFlags & FIT_PERMISSIONS_ARCHIVE) )
            {
                // the ARCHIVE flag is not set (file not yet downloaded).
                bFoundFile = TRUE;
                de.isSelected = TRUE;
                break;
            }
        }
        //
        // if no non-downloaded files were found, select the first file.
        if ( !bFoundFile )
        {
            ((WFFitDirectoryEntry*)[retVal objectAtIndex:0]).isSelected = TRUE;
        }
    }
    
    return retVal;
}

@end
