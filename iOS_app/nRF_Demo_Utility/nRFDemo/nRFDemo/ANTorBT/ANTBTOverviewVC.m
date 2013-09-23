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
//  ANTBTOverviewVC.h
//  WahooDemo
//
//  Created by Michael Moore on 2/14/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "ANTBTOverviewVC.h"
#import <WFConnector/WFConnector.h>
#import "HeartrateViewController.h"
#import "BikeSpeedCadenceViewController.h"
#import "BikePowerViewController.h"
#import "DeviceDiscoveryVC.h"
#import "WFSensorCommonViewController.h"


@interface ANTBTOverviewVC (_PRIVATE_)

- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (void)updateData;
- (void)updateSensorStatus;

@end


@implementation ANTBTOverviewVC

@synthesize fisicaConnectedLabel;
@synthesize btConnectedLabel;

@synthesize hrConnectedLabel;
@synthesize hrDeviceIdLabel;
@synthesize hrSignalLabel;

@synthesize bscConnectedLabel;
@synthesize bscDeviceIdLabel;
@synthesize bscSignalLabel;

@synthesize bpConnectedLabel;
@synthesize bpDeviceIdLabel;
@synthesize bpSignalLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[fisicaConnectedLabel release];
    [btConnectedLabel release];
	
	[hrConnectedLabel release];
	[hrDeviceIdLabel release];
	[hrSignalLabel release];
	
	[bscConnectedLabel release];
	[bscDeviceIdLabel release];
	[bscSignalLabel release];
	
	[bpConnectedLabel release];
	[bpDeviceIdLabel release];
	[bpSignalLabel release];
	
	[super dealloc];
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"ANT+ or BT Smart";
    
    // initialize the HW Connector status.
    hardwareConnector = [WFHardwareConnector sharedConnector];
    if ( hardwareConnector.isCommunicationHWReady )
    {
        [self fisicaConnected];
        [self updateSensorStatus];
    }
    else
    {
        [self fisicaDisconnected];
    }
    
    // subscribe for the HW Connector notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fisicaConnected) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fisicaDisconnected) name:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSensorStatus) name:WF_NOTIFICATION_SENSOR_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSensorStatus) name:WF_NOTIFICATION_SENSOR_DISCONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:WF_NOTIFICATION_SENSOR_HAS_DATA object:nil];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark ANTBTOverviewVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)fisicaConnected
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
	fisicaConnectedLabel.text = (hwState & WF_HWCONN_STATE_ACTIVE) ? @"Yes" : @"No";
    btConnectedLabel.text = (hwState & WF_HWCONN_STATE_BT40_ENABLED) ? @"Yes" : @"No";
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
	fisicaConnectedLabel.text = (hwState & WF_HWCONN_STATE_ACTIVE) ? @"Yes" : @"No";
    btConnectedLabel.text = (hwState & WF_HWCONN_STATE_BT40_ENABLED) ? @"Yes" : @"No";
	
	// reset the data fields.
	hrConnectedLabel.text = @"No";
	hrDeviceIdLabel.text = @"n/a";
	hrSignalLabel.text = @"n/a";
	
	bscConnectedLabel.text = @"No";
	bscDeviceIdLabel.text = @"n/a";
	bscSignalLabel.text = @"n/a";

	bpConnectedLabel.text = @"No";
	bpDeviceIdLabel.text = @"n/a";
	bpSignalLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
-(void) viewDidAppear:(BOOL)animated
{
    //Refresh the display
    
    if ( hardwareConnector.isCommunicationHWReady )
    {
        [self fisicaConnected];
        [self updateSensorStatus];
    }
    else
    {
        [self fisicaDisconnected];
    }
}


//--------------------------------------------------------------------------------
- (void)updateData
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
	fisicaConnectedLabel.text = (hwState & WF_HWCONN_STATE_ACTIVE) ? @"Yes" : @"No";
    btConnectedLabel.text = (hwState & WF_HWCONN_STATE_BT40_ENABLED) ? @"Yes" : @"No";
	
    [self updateSensorStatus];
}

//--------------------------------------------------------------------------------
- (void)updateSensorStatus
{
	// configure the status fields for the heartrate sensor.
	NSArray* connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_HEARTRATE];
	WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        hrConnectedLabel.text = conn ? @"Yes" : @"No";
        hrDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
		hrSignalLabel.text = [WFSensorCommonViewController signalStrengthFromConnection:sensor];
    }
    else
    {
        hrConnectedLabel.text = @"No";
        hrDeviceIdLabel.text = @"n/a";
        hrSignalLabel.text = @"n/a";
    }
	
	// configure the status fields for the Bike Speed and Cadence sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_BIKE_SPEED_CADENCE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        bscConnectedLabel.text = conn ? @"Yes" : @"No";
        bscDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
		bscSignalLabel.text = [WFSensorCommonViewController signalStrengthFromConnection:sensor];
	}
    else
    {
        bscConnectedLabel.text = @"No";
        bscDeviceIdLabel.text = @"n/a";
        bscSignalLabel.text = @"n/a";
    }

	// configure the status fields for the Bike Power sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_BIKE_POWER];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        bpConnectedLabel.text = conn ? @"Yes" : @"No";
        bpDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
        
        float signal = [sensor signalEfficiency];
        if (signal == -1) bpSignalLabel.text = @"n/a";
        else bpSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
    }
    else
    {
        bpConnectedLabel.text = @"No";
        bpDeviceIdLabel.text = @"n/a";
        bpSignalLabel.text = @"n/a";
    }
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)heartrateClicked:(id)sender
{
    HeartrateViewController* vc = [[HeartrateViewController alloc] initWithNibName:@"HeartrateViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)bikeSpeedCadenceClicked:(id)sender
{
    BikeSpeedCadenceViewController* vc = [[BikeSpeedCadenceViewController alloc] initWithNibName:@"BikeSpeedCadenceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)bikePowerClicked:(id)sender
{
    BikePowerViewController* vc = [[BikePowerViewController alloc] initWithNibName:@"BikePowerViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)discoverDevices:(id)sender
{
    // configure and display the discovery view.
	DeviceDiscoveryVC* vc = [[DeviceDiscoveryVC alloc] initWithNibName:@"DeviceDiscoveryVC" bundle:nil];
	vc.sensorType = WF_SENSORTYPE_NONE;
	[self.navigationController pushViewController:vc animated:TRUE];
	
	[vc release];
}

@end
