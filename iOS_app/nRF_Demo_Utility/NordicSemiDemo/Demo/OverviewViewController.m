//
//  OverviewViewController.m
//  nRF Demo
//
//  Created by Michael Moore on 3/25/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "OverviewViewController.h"
#import <WFConnector/WFConnector.h>
#import "SettingsViewController.h"
#import "HeartrateViewController.h"
#import "BikeSpeedCadenceViewController.h"
#import "BikeSpeedViewController.h"
#import "BikeCadenceViewController.h"
#import "BikePowerViewController.h"
#import "FootpodViewController.h"
#import "WeightScaleViewController.h"


@interface OverviewViewController (_PRIVATE_)

- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (void)updateData;
- (void)updateSensorStatus;

@end


@implementation OverviewViewController

@synthesize hardwareConnectedLabel;

@synthesize hrConnectedLabel;
@synthesize hrDeviceIdLabel;
@synthesize hrSignalLabel;

@synthesize bscConnectedLabel;
@synthesize bscDeviceIdLabel;
@synthesize bscSignalLabel;

@synthesize bsConnectedLabel;
@synthesize bsDeviceIdLabel;
@synthesize bsSignalLabel;

@synthesize bcConnectedLabel;
@synthesize bcDeviceIdLabel;
@synthesize bcSignalLabel;

@synthesize bpConnectedLabel;
@synthesize bpDeviceIdLabel;
@synthesize bpSignalLabel;

@synthesize fpConnectedLabel;
@synthesize fpDeviceIdLabel;
@synthesize fpSignalLabel;

@synthesize wsConnectedLabel;
@synthesize wsDeviceIdLabel;
@synthesize wsSignalLabel;

#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[hardwareConnectedLabel release];
	
	[hrConnectedLabel release];
	[hrDeviceIdLabel release];
	[hrSignalLabel release];
	
	[bscConnectedLabel release];
	[bscDeviceIdLabel release];
	[bscSignalLabel release];
	
	[bsConnectedLabel release];
	[bsDeviceIdLabel release];
	[bsSignalLabel release];
	
	[bcConnectedLabel release];
	[bcDeviceIdLabel release];
	[bcSignalLabel release];
	
	[bpConnectedLabel release];
	[bpDeviceIdLabel release];
	[bpSignalLabel release];
	
	[fpConnectedLabel release];
	[fpDeviceIdLabel release];
	[fpSignalLabel release];
	
	[wsConnectedLabel release];
	[wsDeviceIdLabel release];
	[wsSignalLabel release];
	
	[super dealloc];
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Sensors";
    
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
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark OverviewViewController Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)fisicaConnected
{
	hardwareConnectedLabel.text = @"Yes";
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
	hardwareConnectedLabel.text = @"No";
	
	// reset the data fields.
	hrConnectedLabel.text = @"No";
	hrDeviceIdLabel.text = @"n/a";
	hrSignalLabel.text = @"n/a";
	
	bscConnectedLabel.text = @"No";
	bscDeviceIdLabel.text = @"n/a";
	bscSignalLabel.text = @"n/a";
	
	bsConnectedLabel.text = @"No";
	bsDeviceIdLabel.text = @"n/a";
	bsSignalLabel.text = @"n/a";
	
	bcConnectedLabel.text = @"No";
	bcDeviceIdLabel.text = @"n/a";
	bcSignalLabel.text = @"n/a";
	
	bpConnectedLabel.text = @"No";
	bpDeviceIdLabel.text = @"n/a";
	bpSignalLabel.text = @"n/a";
	
	fpConnectedLabel.text = @"No";
	fpDeviceIdLabel.text = @"n/a";
	fpSignalLabel.text = @"n/a";
}

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
	BOOL conn = [hardwareConnector isCommunicationHWReady];
	hardwareConnectedLabel.text = conn ? @"Yes" : @"No";
	
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
        
        // update the signal efficiency.
		float signal = [sensor signalEfficiency];
        //
        // signal efficency is % for ANT connections, dBm for BTLE.
        NSString* units;
        if (sensor.isANTConnection )
        {
            signal *= 100;
            units = @"%";
        }
        else
        {
            units = @" dBm";
        }
		if (sensor.isANTConnection && signal == -1) hrSignalLabel.text = @"n/a";
		else hrSignalLabel.text = [NSString stringWithFormat:@"%0.0f%@", signal, units];
    }
    else
    {
        hrConnectedLabel.text = @"No";
        hrDeviceIdLabel.text = @"n/a";
        hrSignalLabel.text = @"n/a";
    }
	
	// configure the status fields for the FootPod sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_FOOTPOD];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
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
	
	// configure the status fields for the Bike Speed and Cadence sensor.
	connections = [hardwareConnector getSensorConnections:WF_SENSORTYPE_BIKE_SPEED_CADENCE];
	sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
    if ( sensor )
    {
        BOOL conn = (sensor != nil && sensor.isConnected) ? TRUE : FALSE;
        USHORT devId = sensor.deviceNumber;
        bscConnectedLabel.text = conn ? @"Yes" : @"No";
        bscDeviceIdLabel.text = [NSString stringWithFormat:@"%d", devId];
        
        float signal = [sensor signalEfficiency];
        if (signal == -1) bscSignalLabel.text = @"n/a";
        else bscSignalLabel.text = [NSString stringWithFormat:@"%0.1f%%", (signal*100)];
	}
    else
    {
        bscConnectedLabel.text = @"No";
        bscDeviceIdLabel.text = @"n/a";
        bscSignalLabel.text = @"n/a";
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
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)settingsClicked:(id)sender
{
    SettingsViewController* vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

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
- (IBAction)bikePowerClicked:(id)sender
{
    BikePowerViewController* vc = [[BikePowerViewController alloc] initWithNibName:@"BikePowerViewController" bundle:nil];
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

@end
