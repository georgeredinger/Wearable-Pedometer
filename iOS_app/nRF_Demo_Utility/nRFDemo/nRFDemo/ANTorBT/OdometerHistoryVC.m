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
//  OdometerHistory.m
//  WahooDemo
//
//  Created by Michael Moore on 3/29/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "OdometerHistoryVC.h"


@interface OdometerHistoryVC ()

@end


@implementation OdometerHistoryVC

@synthesize bscConnection;
@synthesize odometerHistory;
@synthesize odometerTable;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [bscConnection release];
    bscConnection = nil;
    
	[odometerHistory release];
    [odometerTable release];
    
    [odometerReadings release];
    odometerReadings = nil;
    
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
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Odometer History";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.bscConnection = nil;
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register as the delegate for the CSC connection.
    bscConnection.cscDelegate = self;
    
    // format the units string.
    NSString* units = [WFHardwareConnector sharedConnector].settings.useMetricUnits ? @"km" : @"mi";
    
    // configure the dates (determine the start of week).
    const float secondsPerDay  = 86400.0;
    const float secondsPerWeek = 604800.0;
    NSInteger dayOfWeek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    NSLog(@"%f", -secondsPerDay*(dayOfWeek-1));
    NSDate* startOfWeek = [NSDate dateWithTimeIntervalSinceNow:-secondsPerDay*(dayOfWeek-1)];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    // configure the odometer history array.
    [odometerReadings release];
    odometerReadings = [[NSMutableArray arrayWithCapacity:WF_ODOMETER_HISTORY_MAX_SIZE+1] retain];
    //
    for ( int i=0; i<=WF_ODOMETER_HISTORY_MAX_SIZE; i++ )
    {
        // get the history for the current week.
        float odo = [odometerHistory getOdometerForWeek:i];
        float distance = [odometerHistory getDistanceForWeek:i];
        
        // if history is not available for this week, exit the loop.
        if ( odo == WF_ODOMETER_HISTORY_INVALID )
        {
            break;
        }
        else
        {
            // format the start date for the week.
            NSDate* startDate = [NSDate dateWithTimeInterval:(-secondsPerWeek*i) sinceDate:startOfWeek];
            NSString* timestamp = [df stringFromDate:startDate];

            // format the odometer and distance values.
            NSString* odString = [NSString stringWithFormat:@"%1.2f %@", odo, units];
            NSString* distString  = (distance==WF_ODOMETER_HISTORY_INVALID) ? @"n/a" : [NSString stringWithFormat:@"%1.2f %@", distance, units];
            
            // create the array entry.
            NSDictionary* entry = [NSDictionary dictionaryWithObjectsAndKeys:timestamp, @"timestamp", odString, @"odometer", distString, @"distance", nil];
            [odometerReadings addObject:entry];
        }
    }
    
    [df release];
    df = nil;
}


#pragma mark -
#pragma mark WFBikeSpeedCadenceDelegate Implementation

//--------------------------------------------------------------------------------
- (void)cscConnection:(WFBikeSpeedCadenceConnection*)cscConn didReceiveOdometerHistory:(WFOdometerHistory*)history
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"BlueSC" message:@"Received Odometer History" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
}

//--------------------------------------------------------------------------------
- (void)cscConnection:(WFBikeSpeedCadenceConnection*)cscConn didResetOdometer:(BOOL)bSuccess
{
    NSString* msg = [NSString stringWithFormat:@"Received Odometer Reset response.\n\nStatus: %@", bSuccess?@"SUCCESS":@"FAILED"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"BTLE CSC" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    // Configure the cell.
    NSDictionary* rec = (NSDictionary*)[odometerReadings objectAtIndex:indexPath.row];
    NSString* timestamp = [rec objectForKey:@"timestamp"];
    NSString* odo = [rec objectForKey:@"odometer"];
    NSString* dist = [rec objectForKey:@"distance"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@  odo: %@ dist: %@", timestamp, odo, dist];
    
    return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [odometerReadings count];
}


#pragma mark -
#pragma mark OdometerHistoryVC Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)resetOdometerClicked:(id)sender
{
    [bscConnection requestOdometerReset:2000];
}

//--------------------------------------------------------------------------------
- (IBAction)requestHistoryClicked:(id)sender
{
    [bscConnection requestOdometerHistoryFrom:0 to:WF_ODOMETER_HISTORY_MAX_SIZE];
}

@end
