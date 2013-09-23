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
//  BGMViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import "BGMViewController.h"
#import "BTGlucoseVC.h"
#import "BTGlucoseDetailVC.h"
#import "HelpViewController.h"

@implementation BGMViewController

@synthesize battLevel;
@synthesize recordTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_BTLE_GLUCOSE], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
        desiredNetwork = WF_NETWORKTYPE_BTLE;
    }
    return self;
}

-(void) dealloc 
{
	[records release];
    [recordTable release];
    [glucoseVC release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    records = [[NSMutableArray arrayWithCapacity:10] retain];
    
    glucoseVC = [[BTGlucoseVC alloc] initWithNibName:@"BTGlucoseVC" bundle:nil forSensor:WF_SENSORTYPE_BTLE_GLUCOSE];
    glucoseVC.applicableNetworks = WF_NETWORKTYPE_BTLE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark NSSensorSimpleBase Implementation

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
    battLevel.text = @"n/a";
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}


//--------------------------------------------------------------------------------
- (void)updateData
{
	WFBTLEGlucoseData* gData = [self.glucoseConnection getGlucoseData];
	if ( gData != nil )
	{
        
		float signal = [self.glucoseConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        
       battLevel.text = (gData.btleCommonData.batteryLevel==WF_BTLE_BATT_LEVEL_INVALID) ? @"n/a" : [NSString stringWithFormat:@"%u %%", gData.btleCommonData.batteryLevel];
	}
	else 
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark WFGlucoseDelegate Implementation

//--------------------------------------------------------------------------------
- (void)glucoseConnection:(WFBTLEGlucoseConnection*)glucoseConn didReceiveRecord:(WFBTLEGlucoseData*)record
{
    /*
     USHORT usSequence;
     NSTimeInterval baseTime;
     SSHORT ssTimeOffset;
     float concentration;
     WFGlucoseSampleType_t sampleType;
     WFGlucoseSampleLocation_t sampleLocation;
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
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
#pragma mark BGMViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBTLEGlucoseConnection*)glucoseConnection
{
	return (WFBTLEGlucoseConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_BTLE_GLUCOSE]];
}


- (void)doConfig:(id)sender
{
    [self.navigationController pushViewController:glucoseVC animated:TRUE];
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"btlesensorhelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
    [vc release];
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
