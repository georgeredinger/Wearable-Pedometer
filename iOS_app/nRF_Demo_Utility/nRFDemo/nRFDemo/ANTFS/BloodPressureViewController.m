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
//  BloodPressureViewController.m
//  FisicaUtility
//
//  Created by chip on 6/8/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "BloodPressureViewController.h"
#import "BPHistoryViewController.h"
#import "HistoryManager.h"


@implementation BloodPressureViewController

@synthesize systolicLabel;
@synthesize diastolicLabel;
@synthesize pulserateLabel;
@synthesize sampledateLabel;
@synthesize sampletimeLabel;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[self disconnectDevice];
	
	[systolicLabel release];
	[diastolicLabel release];
	[pulserateLabel release];
	[sampledateLabel release];
	[sampletimeLabel release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{	
	sensorType = WF_SENSORTYPE_ANT_FS;
	deviceType = WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF;
    self.navigationItem.title = @"BP";
	
	[super viewDidLoad];
}


#pragma mark -
#pragma mark WFFSSensorVCBase Implementation

//--------------------------------------------------------------------------------
- (void)displayLastRecord
{
	HistoryManager* hist = [[HistoryManager alloc] init];
	NSArray* fitRecords = [hist loadHistory:deviceType];

	if ( [fitRecords count] > 0 )
	{
		// display the latest blood pressure data.
		WFFitMessageBloodPressure* bpRec = (WFFitMessageBloodPressure*)[fitRecords objectAtIndex:0];
		systolicLabel.text = [NSString stringWithFormat:@"%d", bpRec.systolicPressure];
		diastolicLabel.text = [NSString stringWithFormat:@"%d", bpRec.diastolicPressure];
		pulserateLabel.text = [NSString stringWithFormat:@"%d", bpRec.heartRate];
		
		NSDateFormatter* df = [[NSDateFormatter alloc] init];
		[df setDateStyle:NSDateFormatterShortStyle];
		[df setTimeStyle:NSDateFormatterNoStyle];	
		sampledateLabel.text = [df stringFromDate:bpRec.timestamp];
		
		[df setDateStyle:NSDateFormatterNoStyle];
		[df setTimeStyle:NSDateFormatterShortStyle];
		sampletimeLabel.text = [df stringFromDate:bpRec.timestamp];
	}
	[hist release];
}

//--------------------------------------------------------------------------------
- (NSArray*)getFitRecords:(NSString*)filePath
{
    // this could be implemented as an instance member
    // and tied to a cancel button to implement cancel.
    static BOOL bCancel = FALSE;
    
	return [(WFBloodPressureManager*)afsFileManager getFitRecordsFromFile:filePath cancelPointer:&bCancel];
}

//--------------------------------------------------------------------------------
- (void)updateDisplay:(NSArray*)fitRecords
{
	// display the latest blood pressure data.
	WFFitMessageBloodPressure* bpRec = (WFFitMessageBloodPressure*)[fitRecords objectAtIndex:[fitRecords count]-1];
	systolicLabel.text = [NSString stringWithFormat:@"%d", bpRec.systolicPressure];
	diastolicLabel.text = [NSString stringWithFormat:@"%d", bpRec.diastolicPressure];
	pulserateLabel.text = [NSString stringWithFormat:@"%d", bpRec.heartRate];
	
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterNoStyle];	
	sampledateLabel.text = [df stringFromDate:bpRec.timestamp];
	refreshdateLabel.text = [df	stringFromDate:bpRec.timestamp];
	
	[df setDateStyle:NSDateFormatterNoStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];
	sampletimeLabel.text = [df stringFromDate:bpRec.timestamp];
	refreshtimeLabel.text = [df stringFromDate:bpRec.timestamp];
}


#pragma mark -
#pragma mark BloodPressureViewController Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)historyClicked:(id)sender
{
	bHistoryLoaded = TRUE;
	HistoryManager* history = [[HistoryManager alloc] init];
	NSArray* records = [history loadHistory:deviceType];
	
	BPHistoryViewController *historyView = [[BPHistoryViewController alloc] initWithNibName:@"BPHistoryViewController" bundle:nil];
	historyView.fitRecords = records;
	[self.navigationController pushViewController:historyView animated:TRUE];
	
	[history release];
	[historyView release];
}

@end
