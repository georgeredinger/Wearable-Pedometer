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
//  WFSensorCommonViewController.m
//  FisicaDemo
//
//  Created by Michael Moore on 2/23/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "WFSensorCommonViewController.h"
#import "WahooDemoAppDelegate.h"
#import "SensorManagerViewController.h"
#import "BTDeviceInfoVC.h"
#import "ANTDeviceInfoVC.h"
#import "DeviceDiscoveryVC.h"


@interface WFSensorCommonViewController (_PRIVATE_)

- (void)checkState;
- (void)checkProximity;
- (NSString*)deviceIdString;
- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (NSString*)signalString;
- (void)updateDeviceInfo;

@end

@implementation WFSensorCommonViewController

@synthesize sensorConnection;
@synthesize deviceIdLabel;
@synthesize signalEfficiencyLabel;
@synthesize connectButton;
@synthesize wildcardSwitch;
@synthesize proximitySwitch;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[sensorConnection release];
	[deviceIdLabel release];
	[signalEfficiencyLabel release];
	[connectButton release];
	[wildcardSwitch release];
    [proximitySwitch release];
    
    [antDeviceInfo release];
    [btDeviceInfo release];
	
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
        hardwareConnector = [WFHardwareConnector sharedConnector];
        sensorType = WF_SENSORTYPE_NONE;
        sensorConnection = nil;
        
        // default applicable networks to ANT+.
        applicableNetworks = WF_NETWORKTYPE_ANTPLUS;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    // initialize the display based on HW connector and sensor state.
    if ( hardwareConnector.isCommunicationHWReady )
    {
        // check for an existing connection to this sensor type.
        NSArray* connections = [hardwareConnector getSensorConnections:sensorType];
        WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
        
        // if a connection exists, cache it and set the delegate to this
        // instance (this will allow receiving connection state changes).
        self.sensorConnection = sensor;
        if ( sensor )
        {
            self.sensorConnection.delegate = self;
        }
        
        // update the display.
        [self checkState];
        [self updateData];
    }
    else
    {
        [self resetDisplay];
    }
    
    // register for HW connector notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fisicaConnected) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fisicaDisconnected) name:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:WF_NOTIFICATION_SENSOR_HAS_DATA object:nil];
    
    // create view controllers for device info.
    btDeviceInfo = [[BTDeviceInfoVC alloc] initWithNibName:@"BTDeviceInfoVC" bundle:nil];
    antDeviceInfo = [[ANTDeviceInfoVC alloc] initWithNibName:@"ANTDeviceInfoVC" bundle:nil];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"viewDidUnload");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark WFSensorConnectionDelegate Implementation

//--------------------------------------------------------------------------------
- (void)connectionDidTimeout:(WFSensorConnection*)connectionInfo
{
    // update the button state.
    [self checkState];
    
    // alert the user that the search timed out.
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Search Timeout"
                                                    message:@"A connection was not established before the maximum search time expired."
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
}

//--------------------------------------------------------------------------------
- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState
{
    NSLog(@"SENSOR CONNECTION STATE CHANGED:  connState = %d (IDLE=%d)",connState,WF_SENSOR_CONNECTION_STATUS_IDLE);
    
    // check for a valid connection.
    if ( connectionInfo.isValid && connectionInfo.isConnected )
    {
        // process post-connection setup.
        [self onSensorConnected:connectionInfo];
        
        // update the display.
        [self updateData];
    }
    
    // check for disconnected sensor.
    else if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // reset the display.
        [self resetDisplay];
        
        // check for a connection error.
        if ( connectionInfo.hasError )
        {
            NSString* msg = nil;
            switch ( connectionInfo.error )
            {
                case WF_SENSOR_CONN_ERROR_PAIRED_DEVICE_NOT_AVAILABLE:
                    msg = @"Paired device error.\n\nA device specified in the connection parameters was not found in the Bluetooth Cache.  Please use the paring manager to remove the device, and then re-pair.";
                    break;
                    
                case WF_SENSOR_CONN_ERROR_PROXIMITY_SEARCH_WHILE_CONNECTED:
                    msg = @"Proximity search is not allowed while a device of the specified type is connected to the iPhone.";
                    break;
            }
            
            if ( msg )
            {
                // display the error message.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                alert = nil;
            }
        }
    }
	
	[self checkState];
}


#pragma mark -
#pragma mark DeviceDiscoveryDelegate Implementation

//--------------------------------------------------------------------------------
- (void)requestConnectionToDevice:(WFDeviceParams*)devParams
{
    // configure the connection params.
    WFConnectionParams* params = [[[WFConnectionParams alloc] init] autorelease];
    params.sensorType = sensorType;
    params.device1 = devParams;
    
    // request the sensor connection.
    self.sensorConnection = [hardwareConnector requestSensorConnection:params];

    // set delegate to receive connection status changes.
    self.sensorConnection.delegate = self;
    
    // update the button state.
    [self checkState];
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

#pragma mark Private Methdods

//--------------------------------------------------------------------------------
- (void)checkProximity
{
    // proximity is allowed only on wildcard search.
    if ( !wildcardSwitch.on )
    {
        proximitySwitch.on = FALSE;
    }
}

//--------------------------------------------------------------------------------
- (void)checkState
{
	// get the current connection status.
	WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
	if ( sensorConnection != nil )
	{
		connState = sensorConnection.connectionStatus;
	}
	
	// set the button state based on the connection state.
	switch (connState)
	{
		case WF_SENSOR_CONNECTION_STATUS_IDLE:
			[connectButton setTitle:@"Connect" forState:UIControlStateNormal];
			break;
		case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
			[connectButton setTitle:@"Cancel" forState:UIControlStateNormal];
			break;
		case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
			[connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
			break;
		case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
			[connectButton setTitle:@"Disconnecting..." forState:UIControlStateNormal];
			break;
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
            break;
	}
}

//--------------------------------------------------------------------------------
- (NSString*)deviceIdString
{
    NSString* retVal = @"n/a";
    
    if ( sensorConnection )
    {
        // format BTLE UUID string.
        if ( sensorConnection.isBTLEConnection )
        {
            retVal = [WFSensorCommonViewController formatUUIDString:sensorConnection.deviceUUIDString];
        }
        // format ANT+ device ID string.
        else if ( sensorConnection.isANTConnection )
        {
            retVal = [NSString stringWithFormat:@"%u", sensorConnection.deviceNumber];
        }
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (void)fisicaConnected
{
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
	[self resetDisplay];
}

//--------------------------------------------------------------------------------
- (NSString*)signalString
{
    return [WFSensorCommonViewController signalStrengthFromConnection:self.sensorConnection];
}

//--------------------------------------------------------------------------------
- (void)updateDeviceInfo
{
    WFSensorData* data = [sensorConnection getData];
    if ( data )
    {
        // check the radio type of the sensor connection.
        if ( sensorConnection.isBTLEConnection )
        {
            // check that the BTLE common data is present.
            if ( ![data respondsToSelector:@selector(btleCommonData)] )
            {
                // check for BTLE common data in raw data instance.
                data = [sensorConnection getRawData];
            }
            
            // check that the BTLE common data is present.
            if ( [data respondsToSelector:@selector(btleCommonData)] )
            {
                // get the BTLE common data and display the detail view.
                btDeviceInfo.commonData = (WFBTLECommonData*)[data performSelector:@selector(btleCommonData)];
                [btDeviceInfo updateDisplay];
            }
        }
        
        else if ( sensorConnection.isANTConnection )
        {
            // check that the ANT+ common data is present.
            if ( ![data respondsToSelector:@selector(commonData)] )
            {
                // check for ANT+ common data in raw data instance.
                data = [sensorConnection getRawData];
            }
            
            // check that the ANT+ common data is present.
            if ( [data respondsToSelector:@selector(commonData)] )
            {
                // get the ANT+ common data and display the detail view.
                antDeviceInfo.commonData = (WFCommonData*)[data performSelector:@selector(commonData)];
                [antDeviceInfo updateDisplay];
            }
        }
    }
}


#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    // update the stored connection settings.
    [hardwareConnector.settings saveConnectionInfo:connectionInfo];
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    deviceIdLabel.text = @"n/a";
    signalEfficiencyLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    // update the device status labels.
    deviceIdLabel.text = [self deviceIdString];
    signalEfficiencyLabel.text = [self signalString];
    
    // update the device info.
    [self updateDeviceInfo];
}


#pragma mark Properties

//--------------------------------------------------------------------------------
- (void)setSensorConnection:(WFSensorConnection *)conn
{
    sensorConnection.delegate = nil;
    [sensorConnection release];
    
    sensorConnection = [conn retain];
    sensorConnection.delegate = self;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)connectSensorClicked:(id)sender
{
	// get the current connection status.
	WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
	if ( sensorConnection != nil )
	{
		connState = sensorConnection.connectionStatus;
	}
	
	// set the button state based on the connection state.
	switch (connState)
	{
		case WF_SENSOR_CONNECTION_STATUS_IDLE:
		{
			// create the connection params.
			WFConnectionParams* params = nil;
			//
			// if wildcard search is specified, create empty connection params.
			if ( wildcardSwitch.on )
			{
				params = [[[WFConnectionParams alloc] init] autorelease];
				params.sensorType = sensorType;
			}
			//
			// otherwise, get the params from the stored settings.
			else
			{
				params = [hardwareConnector.settings connectionParamsForSensorType:sensorType];
			}
			
			if ( params != nil)
			{
                // set the search timeout.
                params.searchTimeout = hardwareConnector.settings.searchTimeout;
                
                // if the connection request is a wildcard, use proximity search.
                if ( params.isWildcard )
                {
                    // proximity pairing is available only in the AP2 version of
                    // the Wahoo fisica hardware.  the proximity search facilitates
                    // pairing an unknown device when more than one of the device
                    // type are present.  the range WF_PROXIMITY_RANGE_1 is the
                    // closest - meaning the device must be very close to the
                    // fisica key in order to connect.  ranges are relative 1-10.
                    //
                    // NOTE:  if the fisica hardware is the AP1 version, the API
                    // will issue a standard connection request.  this case is the
                    // same as invoking requestSensorConnection:.
                    //
                    // use proximity search.
                    if ( proximitySwitch.on )
                    {
                        self.sensorConnection = [hardwareConnector requestSensorConnection:params withProximity:WF_PROXIMITY_RANGE_2];
                    }
                    //
                    // use normal search.
                    else
                    {
                        self.sensorConnection = [hardwareConnector requestSensorConnection:params];
                    }
                }
                // otherwise, use normal connection request.
                else
                {
                    self.sensorConnection = [hardwareConnector requestSensorConnection:params];
                }
                
                // set delegate to receive connection status changes.
                self.sensorConnection.delegate = self;
			}
			break;
		}
			
		case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
		case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
			// disconnect the sensor.
			[self.sensorConnection disconnect];
			break;
			
		case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
			// do nothing.
			break;
	}
	
	[self checkState];
}

//--------------------------------------------------------------------------------
- (IBAction)deviceInfoClicked:(id)sender
{
    if ( sensorConnection )
    {
        // check the radio type of the sensor connection.
        if ( sensorConnection.isBTLEConnection )
        {
            // update device info and display VC.
            [self updateDeviceInfo];
            btDeviceInfo.sensorConnection = sensorConnection;
            [self.navigationController pushViewController:btDeviceInfo animated:TRUE];
        }
        
        else if ( sensorConnection.isANTConnection )
        {
            // update device info and display VC.
            [self updateDeviceInfo];
            [self.navigationController pushViewController:antDeviceInfo animated:TRUE];
        }
    }
}

//--------------------------------------------------------------------------------
- (IBAction)manageClicked:(id)sender
{
    // configure and display the sensor manager view.
	SensorManagerViewController* vc = [[SensorManagerViewController alloc] initWithNibName:@"SensorManagerViewController" bundle:nil];
	[vc configForSensorType:sensorType onNetworks:applicableNetworks];
    vc.delegate = self;
	[self.navigationController pushViewController:vc animated:TRUE];
	
	[vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)proximityToggled:(id)sender
{
    [self checkProximity];
}

//--------------------------------------------------------------------------------
- (IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

//--------------------------------------------------------------------------------
- (IBAction)wildcardToggled:(id)sender
{
    [self checkProximity];
}


#pragma mark -
#pragma mark WFSensorCommonViewController Class Method Implementation

//--------------------------------------------------------------------------------
+ (NSString*)formatUUIDString:(NSString*)uuid
{
    // strip the leading zeros from the UUID.
    NSString* retVal = [uuid stringByReplacingOccurrencesOfString:@"0000000000000000" withString:@""];
    retVal = [retVal stringByReplacingOccurrencesOfString:@"00000000-0000-0000-" withString:@""];
    
    return retVal;
}

//--------------------------------------------------------------------------------
+ (NSString*)signalStrengthFromConnection:(WFSensorConnection*)conn
{
    NSString* retVal = @"n/a";
    
    if ( conn )
    {
        // format the signal efficiency value.
		float signal = [conn signalEfficiency];
        //
        // signal efficency is % for ANT connections, dBm for BTLE.
        if ( conn.isANTConnection && signal != -1 )
        {
            retVal = [NSString stringWithFormat:@"%1.0f%%", (signal*100)];
        }
        else if ( conn.isBTLEConnection )
        {
            retVal = [NSString stringWithFormat:@"%1.0f dBm", signal];
        }
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
+ (NSString*)stringFromSensorType:(WFSensorType_t)sensorType
{
    NSString* retVal;
    
	switch (sensorType)
	{
		case WF_SENSORTYPE_HEARTRATE:
            retVal = @"Heart Rate Monitor";
            break;
		case WF_SENSORTYPE_FOOTPOD:
            retVal = @"Footpod";
            break;
		case WF_SENSORTYPE_BIKE_SPEED:
            retVal = @"Bike Speed";
            break;
		case WF_SENSORTYPE_BIKE_CADENCE:
            retVal = @"Bike Cadence";
            break;
		case WF_SENSORTYPE_BIKE_SPEED_CADENCE:
            retVal = @"Bike Speed & Cadence";
            break;
		case WF_SENSORTYPE_BIKE_POWER:
            retVal = @"Bike Power";
            break;
		case WF_SENSORTYPE_WEIGHT_SCALE:
            retVal = @"Weight Scale";
            break;
        case WF_SENSORTYPE_ANT_FS:
            retVal = @"ANT FS";
            break;
		case WF_SENSORTYPE_CALORIMETER:
            retVal = @"Calorimeter";
            break;
		case WF_SENSORTYPE_GEO_CACHE:
            retVal = @"GeoCache";
            break;
		case WF_SENSORTYPE_FITNESS_EQUIPMENT:
            retVal = @"Fitness Equipment";
            break;
		case WF_SENSORTYPE_MULTISPORT_SPEED_DISTANCE:
            retVal = @"Multisport Speed & Distance";
            break;
		case WF_SENSORTYPE_PROXIMITY:
            retVal = @"Proximity";
            break;
		case WF_SENSORTYPE_HEALTH_THERMOMETER:
            retVal = @"Thermometer";
            break;
		case WF_SENSORTYPE_BLOOD_PRESSURE:
            retVal = @"Blood Pressure";
            break;
		case WF_SENSORTYPE_BTLE_GLUCOSE:
            retVal = @"Glucose (BTLE)";
            break;
		case WF_SENSORTYPE_GLUCOSE:
            retVal = @"Glucose (ANT+)";
            break;
            
		default:
			retVal = @"None";
            break;
	}
    
    return retVal;
}

@end
