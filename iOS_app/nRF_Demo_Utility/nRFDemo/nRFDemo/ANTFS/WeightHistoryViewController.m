///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012 Nordic Semiconductor. All Rights Reserved.
// Copyright (c) 2012 Wahoo Fitness. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA and Wahoo Fitness LLC.
// Terms and conditions of usage are described in detail in
// NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
///////////////////////////////////////////////////////////////////////////////
//
//  WeightHistoryViewController.m
//  WeightScale
//
//  Created by Michael Moore on 6/4/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "WeightHistoryViewController.h"
#import "HistoryManager.h"


@implementation WeightHistoryViewController

@synthesize hardwareConnector;
@synthesize fitRecords;
@synthesize conversionFactor;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[hardwareConnector release];
	[fitRecords release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// connect the device.
	if ( hardwareConnector.isFisicaConnected )
	{
		[self connectToDevice];
	}
	else
	{
		wsFileManager = nil;
		[activityIndicator stopAnimating];
	}
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // cache the hardware connector.
    hardwareConnector = [WFHardwareConnector sharedConnector];
    
    // set the conversion factor.
    if ( hardwareConnector.settings.useMetricUnits )
    {
        conversionFactor = 1.0;
    }
    else
    {
        conversionFactor = 2.20462262;
    }
    
	// load the passkey.
	[self loadPasskey];
	
	// load the history records.
	deviceType = WF_ANTFS_DEVTYPE_WEIGHT_SCALE;
	HistoryManager* history = [[HistoryManager alloc] init];
	self.fitRecords = [history loadHistory:deviceType];
	[history release];
	
	// create the activity indicator.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem* activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
    [activityItem release];
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[activityIndicator release];
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
	[self disconnectDevice];
	
	[super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark UITableViewController Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [fitRecords count];
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UILabel *dateLabel, *weightLabel;
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = (UIColor*)[UIColor blackColor];
		
		dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 160.0, 45.0)] autorelease];
		dateLabel.tag = 1;
		dateLabel.font = [UIFont systemFontOfSize:20.0];
		dateLabel.textAlignment = UITextAlignmentLeft;
		dateLabel.textColor = (UIColor *)[UIColor whiteColor];
		dateLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:dateLabel];
		
		weightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(175.0, 0.0, 145.0, 45.0)] autorelease];
		weightLabel.tag = 2;
		weightLabel.font = [UIFont boldSystemFontOfSize:28.0];
		weightLabel.textColor = (UIColor *)[UIColor whiteColor];
		weightLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		weightLabel.textAlignment = UITextAlignmentCenter;
		weightLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:weightLabel];
		
		//use below sample code to make text bold!
		//cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
    } else
	{
		dateLabel = (UILabel *)[cell.contentView viewWithTag:1];
		weightLabel = (UILabel *)[cell.contentView viewWithTag:2];
	}
	
	WFFitMessageWeightScale* wfRec = (WFFitMessageWeightScale*)[fitRecords objectAtIndex:indexPath.row];
	dateLabel.text = [NSString stringWithFormat:@"%@",[wfRec stringFromTimestamp]];
	NSString* units = (conversionFactor == 1.0) ? @"kg" : @"lbs";
	weightLabel.text = [NSString stringWithFormat:@"%1.1f %@", (wfRec.weight*conversionFactor), units];
	NSLog(@"WEIGHT VAL FOR CELL: %1.2f, convFactor: %f", wfRec.weight, conversionFactor);
	return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark -
#pragma mark WFAntFileManagerDelegate Implementation

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager downloadFinished:(BOOL)bSuccess filePath:(NSString*)filePath
{
	if (bSuccess)
	{
        // this could be implemented as an instance member
        // and tied to a cancel button to implement cancel.
        static BOOL bCancel = FALSE;
        
		// save to the history file.
		NSArray* records = [[wsFileManager getFitRecordsFromFile:filePath cancelPointer:&bCancel] retain];
		HistoryManager* history = [[HistoryManager alloc] init];
		[history saveHistory:deviceType fitRecords:records];
		
		// attempt to set the time on the device.  if
		// this fails, go ahead and delete the ANT manager.
		if ( ![wsFileManager setDeviceTime] )
		{
			// reload the data displayed.
			[self updateDisplay];
		}
		
		[history release];
		[records release];
	}
}

//--------------------------------------------------------------------------------
- (void)antFSDevice:(WFAntFSDevice*)fsDevice instanceCreated:(BOOL)bSuccess
{
	wsFileManager = (WFWeightScaleManager*)fsDevice;
	wsFileManager.delegate = self;
	
	[wsFileManager connectToDevice:aucDevicePassword passkeyLength:ucDevicePasswordLength];
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager receivedResponse:(ANTFS_RESPONSE)responseCode
{
	switch (responseCode)
	{
		case ANTFS_RESPONSE_SERIAL_FAIL:
			[self disconnectDevice];
			break;
			
		case ANTFS_RESPONSE_DISCONNECT_PASS:
		case ANTFS_RESPONSE_CONNECTION_LOST:
			[self disconnectDevice];
			break;
			
		case ANTFS_RESPONSE_AUTHENTICATE_REJECT:
		case ANTFS_RESPONSE_AUTHENTICATE_FAIL:
		{
			NSString* msg = @"Authentication failed.  Please place device in pairing mode, and press the \"Refresh\" button.  For information on pairing mode, please see manufacturer's instructions.";
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Authentication Failed"
																message:msg
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
			[alertView autorelease];
			break;
		}
			
		case ANTFS_RESPONSE_DOWNLOAD_REJECT:
		case ANTFS_RESPONSE_DOWNLOAD_FAIL:
			[self disconnectDevice];
			break;
			
		case ANTFS_RESPONSE_UPLOAD_PASS:
		case ANTFS_RESPONSE_UPLOAD_REJECT:
		case ANTFS_RESPONSE_UPLOAD_FAIL:
			[self updateDisplay];
			break;
			
		case ANTFS_RESPONSE_DOWNLOAD_INVALID_INDEX:
		case ANTFS_RESPONSE_DOWNLOAD_FILE_NOT_READABLE:
		case ANTFS_RESPONSE_DOWNLOAD_NOT_READY:
			[self disconnectDevice];
			break;
			
		default:
			break;
	}
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager updatePasskey:(UCHAR*)pucPasskey length:(UCHAR)ucLength
{
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
	HistoryManager* history = [[HistoryManager alloc] init];
	[history savePasskey:deviceType passkey:passkey];
	[history release];
}


#pragma mark -
#pragma mark WeightHistoryViewController Implementation

//--------------------------------------------------------------------------------
- (void)connectToDevice
{
	if (wsFileManager) [hardwareConnector releaseAntFSDevice:wsFileManager];
	wsFileManager = nil;
	
	if ( [hardwareConnector requestAntFSDevice:deviceType toDelegate:self] )
	{
		[activityIndicator startAnimating];
	}
}

//--------------------------------------------------------------------------------
- (void)disconnectDevice
{
	if (wsFileManager) [hardwareConnector releaseAntFSDevice:wsFileManager];
	wsFileManager = nil;
	[activityIndicator stopAnimating];
}

//--------------------------------------------------------------------------------
- (void)loadPasskey
{
	// load the passkey string.
	HistoryManager* history = [[HistoryManager alloc] init];
	NSString* passkey = [history getPasskey:deviceType];
	
	// separate into bytes.
	NSArray* bytes = [passkey componentsSeparatedByString:@","];
	
	// parse bytes.
	memset(aucDevicePassword, 0, WF_ANTFS_PASSWORD_MAX_LENGTH);
	ucDevicePasswordLength = [bytes count];
	for (int i=0; i<ucDevicePasswordLength; i++)
	{
		uint scanInt;
		[[NSScanner scannerWithString:(NSString*)[bytes objectAtIndex:i]] scanHexInt:&scanInt];
		aucDevicePassword[i] = (UCHAR)scanInt;
	}
	
	// release resources.
	[history release];
}

//--------------------------------------------------------------------------------
- (void)updateDisplay
{
	[self disconnectDevice];
	HistoryManager* history = [[HistoryManager alloc] init];
	self.fitRecords = [history loadHistory:deviceType];
	[history release];

	[(UITableView*)self.view reloadData];
}

@end

