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
//  BTOverviewVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/14/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "BTOverviewVC.h"
#import <WFConnector/WFConnector.h>
#import "ProximityViewController.h"
#import "TemperatureViewController.h"
#import "BTBloodPressureVC.h"
#import "BTGlucoseVC.h"
#import "WFSensorCommonViewController.h"


@interface BTOverviewVC (_PRIVATE_)

- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (void)updateData;
- (void)updateSensorStatus;

@end


@implementation BTOverviewVC

@synthesize btConnectedLabel;

@synthesize proxConnectedLabel;
@synthesize proxDeviceIdLabel;
@synthesize proxSignalLabel;

@synthesize tempConnectedLabel;
@synthesize tempDeviceIdLabel;
@synthesize tempSignalLabel;

@synthesize bpConnectedLabel;
@synthesize bpDeviceIdLabel;
@synthesize bpSignalLabel;

@synthesize glucConnectedLabel;
@synthesize glucDeviceIdLabel;
@synthesize glucSignalLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [btConnectedLabel release];
	
	[proxConnectedLabel release];
	[proxDeviceIdLabel release];
	[proxSignalLabel release];
	
	[tempConnectedLabel release];
	[tempDeviceIdLabel release];
	[tempSignalLabel release];
	
	[bpConnectedLabel release];
	[bpDeviceIdLabel release];
	[bpSignalLabel release];
	
	[glucConnectedLabel release];
	[glucDeviceIdLabel release];
	[glucSignalLabel release];

	[super dealloc];
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"BT Smart Overview";
    
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
    [self setBpConnectedLabel:nil];
    [self setBpDeviceIdLabel:nil];
    [self setBpSignalLabel:nil];
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
#pragma mark BTOverviewVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)fisicaConnected
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
    btConnectedLabel.text = (hwState & WF_HWCONN_STATE_BT40_ENABLED) ? @"Yes" : @"No";
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
    btConnectedLabel.text = (hwState & WF_HWCONN_STATE_BT40_ENABLED) ? @"Yes" : @"No";
	
	// reset the data fields.
	proxConnectedLabel.text = @"No";
	proxDeviceIdLabel.text = @"n/a";
	proxSignalLabel.text = @"n/a";
    
	tempConnectedLabel.text = @"No";
	tempDeviceIdLabel.text = @"n/a";
	tempSignalLabel.text = @"n/a";
    
	bpConnectedLabel.text = @"No";
	bpDeviceIdLabel.text = @"n/a";
	bpSignalLabel.text = @"n/a";
    
	glucConnectedLabel.text = @"No";
	glucDeviceIdLabel.text = @"n/a";
	glucSignalLabel.text = @"n/a";
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
    btConnectedLabel.text = (hwState & WF_HWCONN_STATE_BT40_ENABLED) ? @"Yes" : @"No";
	
    [self updateSensorStatus];
}

//--------------------------------------------------------------------------------
- (void)updateSensorStatus
{
	// configure the status fields for the proximity sensor.
	NSArray* connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_PROXIMITY];
	WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        proxConnectedLabel.text = conn ? @"Yes" : @"No";
        proxDeviceIdLabel.text = [WFSensorCommonViewController formatUUIDString:sensor.deviceUUIDString];
        
        // update the signal efficiency.
		float signal = [sensor signalEfficiency];
		if (sensor.isANTConnection && signal == -1) proxSignalLabel.text = @"n/a";
		else proxSignalLabel.text = [NSString stringWithFormat:@"%0.0f dBm", signal];
    }
    else
    {
        proxConnectedLabel.text = @"No";
        proxDeviceIdLabel.text = @"n/a";
        proxSignalLabel.text = @"n/a";
    }
	
	// configure the status fields for the temperature sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_HEALTH_THERMOMETER];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        tempConnectedLabel.text = conn ? @"Yes" : @"No";
        tempDeviceIdLabel.text = [WFSensorCommonViewController formatUUIDString:sensor.deviceUUIDString];
        
        // update the signal efficiency.
		float signal = [sensor signalEfficiency];
		if (sensor.isANTConnection && signal == -1) tempSignalLabel.text = @"n/a";
		else tempSignalLabel.text = [NSString stringWithFormat:@"%0.0f dBm", signal];
    }
    else
    {
        tempConnectedLabel.text = @"No";
        tempDeviceIdLabel.text = @"n/a";
        tempSignalLabel.text = @"n/a";
    }
	
	// configure the status fields for the blood pressure sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_BLOOD_PRESSURE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        bpConnectedLabel.text = conn ? @"Yes" : @"No";
        bpDeviceIdLabel.text = [WFSensorCommonViewController formatUUIDString:sensor.deviceUUIDString];
        
        // update the signal efficiency.
		float signal = [sensor signalEfficiency];
		if (sensor.isANTConnection && signal == -1) bpSignalLabel.text = @"n/a";
		else bpSignalLabel.text = [NSString stringWithFormat:@"%0.0f dBm", signal];
    }
    else
    {
        bpConnectedLabel.text = @"No";
        bpDeviceIdLabel.text = @"n/a";
        bpSignalLabel.text = @"n/a";
    }
	
	// configure the status fields for the glucose sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_GLUCOSE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        glucConnectedLabel.text = conn ? @"Yes" : @"No";
        glucDeviceIdLabel.text = [WFSensorCommonViewController formatUUIDString:sensor.deviceUUIDString];
        
        // update the signal efficiency.
		float signal = [sensor signalEfficiency];
		if (sensor.isANTConnection && signal == -1) glucSignalLabel.text = @"n/a";
		else glucSignalLabel.text = [NSString stringWithFormat:@"%0.0f dBm", signal];
    }
    else
    {
        glucConnectedLabel.text = @"No";
        glucDeviceIdLabel.text = @"n/a";
        glucSignalLabel.text = @"n/a";
    }
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)bpClicked:(id)sender
{
    BTBloodPressureVC* vc = [[BTBloodPressureVC alloc] initWithNibName:@"BTBloodPressureVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)glucClicked:(id)sender
{
    BTGlucoseVC* vc = [[BTGlucoseVC alloc] initWithNibName:@"BTGlucoseVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)proximityClicked:(id)sender
{
    ProximityViewController* vc = [[ProximityViewController alloc] initWithNibName:@"ProximityViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)temperatureClicked:(id)sender
{
    TemperatureViewController* vc = [[TemperatureViewController alloc] initWithNibName:@"TemperatureViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}


#pragma mark -
#pragma mark BTOverviewVC Class Method Implementation

//--------------------------------------------------------------------------------

@end
