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
//  BTGlucoseVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/22/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "BTGlucoseVC.h"
#import "BTOverviewVC.h"
#import "BTGlucoseDetailVC.h"


@implementation BTGlucoseVC

@synthesize recordTable;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[records release];
    [recordTable release];
    
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
    {
        sensorType = WF_SENSORTYPE_BTLE_GLUCOSE;
        applicableNetworks = WF_NETWORKTYPE_BTLE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"BT Glucose";
    records = [[NSMutableArray arrayWithCapacity:10] retain];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFBTLEGlucoseDelegate Implementation

//--------------------------------------------------------------------------------
- (void)glucoseConnection:(WFBTLEGlucoseConnection*)glucoseConn didReceiveRecord:(WFBTLEGlucoseData*)record
{
    /*
     USHORT usSequence;
     NSTimeInterval baseTime;
     SSHORT ssTimeOffset;
     float concentration;
     WFBTLEGlucoseSampleType_t sampleType;
     WFBTLEGlucoseSampleLocation_t sampleLocation;
     [ 03 00 00 12 00 05 06 07 08 00 00 00 00 00 05 78 00 ]
     12 00 05 06 07 08 00

     */
    NSDate* baseTime = [NSDate dateWithTimeIntervalSinceReferenceDate:record.pstGlucoseMeasurement->baseTime];
    NSLog(@"RECEIVED RECORD:  sequence: %u", record.pstGlucoseMeasurement->usSequence);
    NSLog(@"---------------   baseTime: %@", baseTime);
    NSLog(@"---------------   ssTimeOfset: %u", record.pstGlucoseMeasurement->ssTimeOffset);
    NSLog(@"---------------   concentration: %1.2f", record.pstGlucoseMeasurement->concentration);
    NSLog(@"---------------   sampleType: %u", record.pstGlucoseMeasurement->sampleType);
    NSLog(@"---------------   sampleLocation: %u", record.pstGlucoseMeasurement->sampleLocation);
    
    // add the record to the collection.
    [records addObject:record];
    
    // reload the record table.
    [recordTable reloadData];
}

//--------------------------------------------------------------------------------
- (void)glucoseConnection:(WFBTLEGlucoseConnection*)glucoseConn didReceiveCommandResponse:(WFBTLERecordOpCode_t)opCode responseData:(NSData*)responseData
{
    NSLog(@"RECEIVED COMMAND RESPONSE:  opCode: %u", opCode);
}


#pragma mark -
#pragma mark UITableViewDelegate Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    WFBTLEGlucoseData* rec = (WFBTLEGlucoseData*)[records objectAtIndex:indexPath.row];
    WFBTLEGlucoseMeasurementData_t* pData = rec.pstGlucoseMeasurement;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    NSTimeInterval timeOffset = pData->baseTime + pData->ssTimeOffset;
    NSDate* timestamp = [NSDate dateWithTimeIntervalSinceReferenceDate:timeOffset];
    cell.textLabel.text = [NSString stringWithFormat:@"SEQ: %u TIME: %@", pData->usSequence, [df stringFromDate:timestamp]];
    [df release];
    df = nil;
    
    return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTGlucoseDetailVC* vc = [[BTGlucoseDetailVC alloc] initWithNibName:@"BTGlucoseDetailVC" bundle:nil];
    vc.glucoseRecord = (WFBTLEGlucoseData*)[records objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [records count];
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    
    // set the glucose delegate parameters.
    WFBTLEGlucoseConnection* glucoseConn = self.glucoseConnection;
    if ( glucoseConn )
    {
        glucoseConn.glucoseDelegate = self;
    }
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFBTLEGlucoseData* glucData = [self.glucoseConnection getGlucoseData];
	if ( glucData != nil )
	{
        // data updated in glucoseConnection:didReceiveRecord: method.
	}
	else 
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark ProximityViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBTLEGlucoseConnection*)glucoseConnection
{
	WFBTLEGlucoseConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFBTLEGlucoseConnection class]] )
	{
		retVal = (WFBTLEGlucoseConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)retrieveFirstClicked:(id)sender
{
    // clear the current data.
    [records removeAllObjects];
    [recordTable reloadData];
    
    // get the first record.
    [self.glucoseConnection sendRecordCommand:WF_BTLE_RECORD_OP_CODE_REPORT_STORED_RECORDS withOperator:WF_BTLE_RECORD_OPERATOR_FIRST_RECORD operands:nil];
}

//--------------------------------------------------------------------------------
- (IBAction)retrieveLastClicked:(id)sender
{
    // clear the current data.
    [records removeAllObjects];
    [recordTable reloadData];
    
    // get the last record.
    [self.glucoseConnection sendRecordCommand:WF_BTLE_RECORD_OP_CODE_REPORT_STORED_RECORDS withOperator:WF_BTLE_RECORD_OPERATOR_LAST_RECORD operands:nil];
}

//--------------------------------------------------------------------------------
- (IBAction)retrieveAllClicked:(id)sender
{
    // clear the current data.
    [records removeAllObjects];
    [recordTable reloadData];
    
    // get all records.
    [self.glucoseConnection sendRecordCommand:WF_BTLE_RECORD_OP_CODE_REPORT_STORED_RECORDS withOperator:WF_BTLE_RECORD_OPERATOR_ALL_RECORDS operands:nil];
}

@end
