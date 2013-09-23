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
//  WFSensorCommonViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/23/10.
//

#import "WFSensorCommonViewController.h"
#import "NordicSemiAppDelegate.h"
#import "SensorManagerViewController.h"
#import "BTDeviceInfoVC.h"
#import "ANTDeviceInfoVC.h"
#import "NordicNavigationBar.h"
#import "ConfigAndHelpView.h"
#import "HelpViewController.h"


@interface WFSensorCommonViewController (_PRIVATE_)

- (void)checkState;
- (void)checkProximity;
- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (void)updateDeviceInfo;

@end

@implementation WFSensorCommonViewController

@synthesize sensorConnection;
@synthesize deviceIdLabel;
@synthesize signalEfficiencyLabel;
//@synthesize operatingTimeLabel;
@synthesize manufacturerIdLabel;
@synthesize serialNumberLabel;
@synthesize hardwareVersionLabel;
@synthesize softwareVersionLabel;
@synthesize modelNumberLabel;
@synthesize battStatusLabel;
@synthesize battVoltageLabel;
@synthesize connectButton;
@synthesize wildcardSwitch;
@synthesize proximitySwitch;
@synthesize connectingIndicator;
@synthesize parentNavController;
@synthesize applicableNetworks;

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
	[connectingIndicator release];
	[parentNavController release];
    [btDeviceInfo release];
    [antDeviceInfo release];
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forSensor:(WFSensorType_t)sensType
{
    if ( (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
    {
        NSLog(@"initWithNibName: %@", nibNameOrNil);
        hardwareConnector = [WFHardwareConnector sharedConnector];
        sensorConnection = nil;
        sensorType = sensType;
        
        // default applicable networks to ANT+.
        applicableNetworks = WF_NETWORKTYPE_ANTPLUS;
    }
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize the display based on HW connector and sensor state.
    if ( hardwareConnector.isCommunicationHWReady )
    {
        // check for an existing connection to this sensor type.
        NSArray* connections = [hardwareConnector getSensorConnections:sensorType];
        WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
        
        // if a connection exists, cache it and set the delegate to this
        // instance (this will allow receiving connection state changes).
        NSLog(@"viewDidLoad, hardware comm ready");
        self.sensorConnection = sensor;
        if ( sensor )
        {
            NSLog(@"has sensor conn, sensor is type %d", sensorType);
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
    btDeviceInfo.sensorType = sensorType;
    antDeviceInfo = [[ANTDeviceInfoVC alloc] initWithNibName:@"ANTDeviceInfoVC" bundle:nil];
    antDeviceInfo.sensorType = sensorType;
    
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL wsValForSensor = [[[appDelegate wildcardSwitches] objectForKey:[NSNumber numberWithInt:sensorType]] boolValue];
    if (wsValForSensor) wildcardSwitch.on = YES;
    
    BOOL psValForSensor = [[[appDelegate proximitySwitches] objectForKey:[NSNumber numberWithInt:sensorType]] boolValue];
    if (psValForSensor) proximitySwitch.on = YES;
    
    UIImage* titleImage = [UIImage imageNamed:@"NORDIC-LOGO.png"];
    UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [titleView addSubview:titleImageView];
    titleImageView.center = titleView.center;
    CGRect titleImageViewFrame = titleImageView.frame;
    titleImageView.frame = titleImageViewFrame;
    self.navigationItem.titleView = titleView;
    [titleImageView release];
    [titleView release];
    
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"NordicNavbar.png"]];
    // Create a custom back button
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
    ConfigAndHelpView *btns = [nib objectAtIndex:0];
    
    btns.configButton.hidden = YES;
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
    
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease] animated:YES];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorConnectionDelegate Implementation

//--------------------------------------------------------------------------------
- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState
{
    NSLog(@"SENSOR CONNECTION STATE CHANGED:  connState = %d (IDLE=%d)",connState,WF_SENSOR_CONNECTION_STATUS_IDLE);
    
    // check for a valid connection.
    if (connectionInfo.isValid)
    {
        // update the stored connection settings.
        [hardwareConnector.settings saveConnectionInfo:connectionInfo];
        
        // update the display.
        [self updateData];
    }
    
    // check for disconnected sensor.
    else if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // reset the display.
        [self resetDisplay];
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
    if ( !self.isWildcardSearch )
    {
        proximitySwitch.on = FALSE;
    }
    
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate wildcardSwitches] setObject:[NSNumber numberWithBool:wildcardSwitch.on] forKey:[NSNumber numberWithInt:sensorType]];
    [[appDelegate proximitySwitches] setObject:[NSNumber numberWithBool:proximitySwitch.on] forKey:[NSNumber numberWithInt:sensorType]];
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
- (void)fisicaConnected
{
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
	[self resetDisplay];
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
	// operatingTimeLabel.text = @"n/a";
	manufacturerIdLabel.text = @"n/a";
	serialNumberLabel.text = @"n/a";
	hardwareVersionLabel.text = @"n/a";
	softwareVersionLabel.text = @"n/a";
	modelNumberLabel.text = @"n/a";
	battStatusLabel.text = @"n/a";
	battVoltageLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [self updateDeviceInfo];
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

#pragma mark Properties

//--------------------------------------------------------------------------------
- (BOOL)isWildcardSearch
{
    return wildcardSwitch.on;
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
			if ( self.isWildcardSearch )
			{
				params = [[[WFConnectionParams alloc] init] autorelease];
				params.sensorType = sensorType;
			}
			//
			// otherwise, get the params from the stored settings.
			else
			{
                NSLog(@"stored settings search");
				params = [hardwareConnector.settings connectionParamsForSensorType:sensorType];
			}
			
			if ( params != nil)
			{
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
                        NSLog(@"proximity search");
                        self.sensorConnection = [hardwareConnector requestSensorConnection:params withProximity:WF_PROXIMITY_RANGE_1];
                    }
                    //
                    // use normal search.
                    else
                    {
                        NSLog(@"normal search");
                        self.sensorConnection = [hardwareConnector requestSensorConnection:params];
                    }
                }
                // otherwise, use normal connection request.
                else
                {
                    NSLog(@"also normal search");
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
        NSLog(@"has sensorconn of type %d", sensorType);
        // check the radio type of the sensor connection.
        if ( sensorConnection.isBTLEConnection )
        {
            // update device info and display VC.
            [self updateDeviceInfo]; 
            if (self.parentNavController) { // if the config view is in the ConfigScrollerController
                [self.parentNavController pushViewController:btDeviceInfo animated:TRUE];
            } else {
                [self.navigationController pushViewController:btDeviceInfo animated:TRUE];
            }
        }
        
        else
        {
            NSLog(@"ant sensor, display sensor info");
            // update device info and display VC.
            [self updateDeviceInfo]; 
            if (self.parentNavController) { // if the config view is in the ConfigScrollerController
                [self.parentNavController pushViewController:antDeviceInfo animated:TRUE];
            } else {
                [self.navigationController pushViewController:antDeviceInfo animated:TRUE];
            }
        }
    }
}

//--------------------------------------------------------------------------------
- (IBAction)manageClicked:(id)sender
{
    // configure and display the sensor manager view.
	SensorManagerViewController *managerView = [[SensorManagerViewController alloc] initWithNibName:@"SensorManagerViewController" bundle:nil];
	[managerView configForSensorType:sensorType onNetworks:applicableNetworks];
    managerView.delegate = self;
    if (self.parentNavController) { // if the config view is in the ConfigScrollerController
        [self.parentNavController pushViewController:managerView animated:TRUE];
    } else {
        [self.navigationController pushViewController:managerView animated:TRUE];
    }
    [managerView release];
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

- (void)doHelp:(id)sender
{
}

//--------------------------------------------------------------------------------
+ (NSString*)formatUUID:(NSString*)uuid
{
    // strip the leading zeros from the UUID.
    return [uuid stringByReplacingOccurrencesOfString:@"0000000000000000" withString:@""];
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
