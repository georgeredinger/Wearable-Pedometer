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
//  ANTOverviewVC.m
//  FisicaDemo
//
//  Created by Michael Moore on 3/25/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "ANTOverviewVC.h"
#import <WFConnector/WFConnector.h>
#import "BikeSpeedViewController.h"
#import "BikeCadenceViewController.h"
#import "FootpodViewController.h"
#import "WeightScaleViewController.h"
#import "GlucoseVC.h"


@interface ANTOverviewVC (_PRIVATE_)

- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (void)updateData;
- (void)updateSensorStatus;

@end


@implementation ANTOverviewVC

@synthesize fisicaConnectedLabel;

@synthesize bsConnectedLabel;
@synthesize bsDeviceIdLabel;
@synthesize bsSignalLabel;

@synthesize bcConnectedLabel;
@synthesize bcDeviceIdLabel;
@synthesize bcSignalLabel;

@synthesize fpConnectedLabel;
@synthesize fpDeviceIdLabel;
@synthesize fpSignalLabel;

@synthesize wsConnectedLabel;
@synthesize wsDeviceIdLabel;
@synthesize wsSignalLabel;

@synthesize cgmConnectedLabel;
@synthesize cgmDeviceIdLabel;
@synthesize cgmSignalLabel;

#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[fisicaConnectedLabel release];
	
	[bsConnectedLabel release];
	[bsDeviceIdLabel release];
	[bsSignalLabel release];
	
	[bcConnectedLabel release];
	[bcDeviceIdLabel release];
	[bcSignalLabel release];
	
	[fpConnectedLabel release];
	[fpDeviceIdLabel release];
	[fpSignalLabel release];
	
	[wsConnectedLabel release];
	[wsDeviceIdLabel release];
	[wsSignalLabel release];
	
	[cgmConnectedLabel release];
	[cgmDeviceIdLabel release];
	[cgmSignalLabel release];
	
	[super dealloc];
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"ANT+ Overview";
    
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
#pragma mark ANTOverviewVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)fisicaConnected
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
	fisicaConnectedLabel.text = (hwState & WF_HWCONN_STATE_ACTIVE) ? @"Yes" : @"No";
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
    WFHardwareConnectorState_t hwState = hardwareConnector.currentState;
	fisicaConnectedLabel.text = (hwState & WF_HWCONN_STATE_ACTIVE) ? @"Yes" : @"No";
	
	// reset the data fields.
	bsConnectedLabel.text = @"No";
	bsDeviceIdLabel.text = @"n/a";
	bsSignalLabel.text = @"n/a";
	
	bcConnectedLabel.text = @"No";
	bcDeviceIdLabel.text = @"n/a";
	bcSignalLabel.text = @"n/a";
	
	fpConnectedLabel.text = @"No";
	fpDeviceIdLabel.text = @"n/a";
	fpSignalLabel.text = @"n/a";
	
	wsConnectedLabel.text = @"No";
	wsDeviceIdLabel.text = @"n/a";
	wsSignalLabel.text = @"n/a";
	
	cgmConnectedLabel.text = @"No";
	cgmDeviceIdLabel.text = @"n/a";
	cgmSignalLabel.text = @"n/a";
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
	
    [self updateSensorStatus];
}

//--------------------------------------------------------------------------------
- (void)updateSensorStatus
{
	// configure the status fields for the FootPod sensor.
	NSArray* connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_FOOTPOD];
	WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        fpConnectedLabel.text = conn ? @"Yes" : @"No";
        fpDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];

        float signal = [sensor signalEfficiency];
        if (signal == -1) fpSignalLabel.text = @"n/a";
        else fpSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
    }
    else
    {
        fpConnectedLabel.text = @"No";
        fpDeviceIdLabel.text = @"n/a";
        fpSignalLabel.text = @"n/a";
    }
	
	// configure the status fields for the Bike Speed sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_BIKE_SPEED];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        bsConnectedLabel.text = conn ? @"Yes" : @"No";
        bsDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
        
        float signal = [sensor signalEfficiency];
        if (signal == -1) bsSignalLabel.text = @"n/a";
        else bsSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
	}
    else
    {
        bsConnectedLabel.text = @"No";
        bsDeviceIdLabel.text = @"n/a";
        bsSignalLabel.text = @"n/a";
    }
    
	// configure the status fields for the Bike Cadence sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_BIKE_CADENCE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        bcConnectedLabel.text = conn ? @"Yes" : @"No";
        bcDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
        
        float signal = [sensor signalEfficiency];
        if (signal == -1) bcSignalLabel.text = @"n/a";
        else bcSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
	}
    else
    {
        bcConnectedLabel.text = @"No";
        bcDeviceIdLabel.text = @"n/a";
        bcSignalLabel.text = @"n/a";
    }
    
	// configure the status fields for the Weight Scale sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_WEIGHT_SCALE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        wsConnectedLabel.text = conn ? @"Yes" : @"No";
        wsDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
        
        float signal = [sensor signalEfficiency];
        if (signal == -1) wsSignalLabel.text = @"n/a";
        else wsSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
    }
    else
    {
        wsConnectedLabel.text = @"No";
        wsDeviceIdLabel.text = @"n/a";
        wsSignalLabel.text = @"n/a";
    }
    
	// configure the status fields for the Weight Scale sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_GLUCOSE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        cgmConnectedLabel.text = conn ? @"Yes" : @"No";
        cgmDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
        
        float signal = [sensor signalEfficiency];
        if (signal == -1) cgmSignalLabel.text = @"n/a";
        else cgmSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
    }
    else
    {
        cgmConnectedLabel.text = @"No";
        cgmDeviceIdLabel.text = @"n/a";
        cgmSignalLabel.text = @"n/a";
    }
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)bikeSpeedClicked:(id)sender
{
    BikeSpeedViewController* vc = [[BikeSpeedViewController alloc] initWithNibName:@"BikeSpeedViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)bikeCadenceClicked:(id)sender
{
    BikeCadenceViewController* vc = [[BikeCadenceViewController alloc] initWithNibName:@"BikeCadenceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)strideSensorClicked:(id)sender
{
    FootpodViewController* vc = [[FootpodViewController alloc] initWithNibName:@"FootpodViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];    
}

//--------------------------------------------------------------------------------
- (IBAction)weightSensorClicked:(id)sender
{
    WeightScaleViewController* vc = [[WeightScaleViewController alloc] initWithNibName:@"WeightScaleViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];    
}

//--------------------------------------------------------------------------------
- (IBAction)glucoseSensorClicked:(id)sender
{
    GlucoseVC* vc = [[GlucoseVC alloc] initWithNibName:@"GlucoseVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];    
}

@end
