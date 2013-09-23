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
//  NSSensorSimpleBaseVC.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import "NSSensorSimpleBaseVC.h"
#import "NordicNavigationBar.h"
#import "NordicSemiAppDelegate.h"
#import "ConfigAndHelpView.h"
#import "HelpViewController.h"

#define ACCEPT_NIL_WILDCARD 0

@interface NSSensorSimpleBaseVC (_PRIVATE_)

- (void)fisicaConnected;
- (void)fisicaDisconnected;
- (void)checkState;
- (void)buildCustomNavbar:(UIImage*)background;
- (void)storeSensorConnection:(WFSensorConnection *)conn;
- (void)disconnectSensors;
- (void)disconnectSensor:(NSNumber*)sensorType;
@end

@implementation NSSensorSimpleBaseVC

@synthesize connectButton;
@synthesize sensorConnections;
@synthesize sensorTypes;

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[connectButton release];
	[sensorConnections release];
    [sensorTypes release];
	
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        hardwareConnector = [WFHardwareConnector sharedConnector];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    [connectingIndicator stopAnimating];
    connectingIndicator.hidden = YES;
    
    [self buildCustomNavbar:[UIImage imageNamed:@"NordicNavbarWhite.png"]];
    // initialize the display based on HW connector and sensor state.
    if ( hardwareConnector.isCommunicationHWReady )
    {   
        for (NSNumber * st in sensorTypes) {
            WFSensorConnection *sConn = [sensorConnections objectForKey:st];
            sConn.delegate = nil;
            // check for an existing connection to this sensor type.
            NSArray* connections = [hardwareConnector getSensorConnections:[st intValue]];
            WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
            
            // if a connection exists, cache it and set the delegate to this
            // instance (this will allow receiving connection state changes).
            if ( sensor )
            {
                [self storeSensorConnection:sensor];
            }
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
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [connectingIndicator stopAnimating];
    connectingIndicator.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark WFSensorConnectionDelegate Implementation

//--------------------------------------------------------------------------------
- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState
{
    NSLog(@"SENSOR CONNECTION STATE CHANGED:  connState = %d (IDLE=%d)",connState,WF_SENSOR_CONNECTION_STATUS_IDLE);
    
    // check for a valid connection.
    if (connectionInfo.isValid  && connectionInfo.isConnected )
    {
        
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
                    
                default:
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
#pragma mark NSSensorSimpleBaseVC Implementation

#pragma mark Private Methdods


//--------------------------------------------------------------------------------
- (void)checkState
{
	// get the current connection status.
	WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
    BOOL transitioning = NO;
    BOOL hasConnections = NO;
    for (NSNumber * st in sensorTypes) {
        WFSensorConnection *sConn = [sensorConnections objectForKey:st];
        if ( sConn != nil )
        {
            connState = sConn.connectionStatus;
        }
        // set the button state based on the connection state.
        switch (connState)
        {
            case WF_SENSOR_CONNECTION_STATUS_IDLE:
                break;
            case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
                hasConnections = YES;
                transitioning = YES;
                break;
            case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
                
                if(sConn.networkType==WF_NETWORKTYPE_BTLE && ( desiredNetwork == WF_NETWORKTYPE_ANTPLUS || desiredNetwork == WF_NETWORKTYPE_SUUNTO ))
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Sensor Found" message:@"You found a BT Smart sensor when searching for ANT+ or Suunto. Try using proximity."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                    [self disconnectSensor:st];
                }
                else if ((sConn.networkType==WF_NETWORKTYPE_ANTPLUS || sConn.networkType == WF_NETWORKTYPE_SUUNTO ) 
                         && desiredNetwork == WF_NETWORKTYPE_BTLE)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Sensor Found" message:@"You found an ANT sensor when searching for BT Smart. Try using proximity."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                    [self disconnectSensor:st];
                } else {
                    hasConnections = YES;
                }
                break;
            case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
                NSLog(@"disconnecting");
                transitioning = YES;
                break;
            case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
                break;
        }
        connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
    }
    if (hasConnections && !transitioning) {
        NSLog(@"show disconnect button");
        [connectButton setImage:[UIImage imageNamed:@"DISCONNECT.png"] forState:UIControlStateNormal];
        [connectButton setImage:[UIImage imageNamed:@"DISCONNECT-down.png"] forState:UIControlStateHighlighted];
        [connectButton setImage:[UIImage imageNamed:@"DISCONNECT-down.png"] forState:UIControlStateSelected];
        [connectingIndicator stopAnimating];
        connectingIndicator.hidden = YES;
    } else if (hasConnections && transitioning) {
        [connectButton setImage:[UIImage imageNamed:@"DISCONNECT.png"] forState:UIControlStateNormal];
        [connectButton setImage:[UIImage imageNamed:@"DISCONNECT-down.png"] forState:UIControlStateHighlighted];
        [connectButton setImage:[UIImage imageNamed:@"DISCONNECT-down.png"] forState:UIControlStateSelected];
        [connectingIndicator startAnimating];
        connectingIndicator.hidden = NO;
    } else if (!hasConnections && !transitioning) {
        NSLog(@"show connect button");
        [connectButton setImage:[UIImage imageNamed:@"CONNECT.png"] forState:UIControlStateNormal];
        [connectButton setImage:[UIImage imageNamed:@"CONNECT-down.png"] forState:UIControlStateHighlighted];
        [connectButton setImage:[UIImage imageNamed:@"CONNECT-down.png"] forState:UIControlStateSelected];
        [connectingIndicator stopAnimating];
        connectingIndicator.hidden = YES;
        
    } else if (!hasConnections && transitioning) {
        [connectButton setImage:[UIImage imageNamed:@"CONNECT.png"] forState:UIControlStateNormal];
        [connectButton setImage:[UIImage imageNamed:@"CONNECT-down.png"] forState:UIControlStateHighlighted];
        [connectButton setImage:[UIImage imageNamed:@"CONNECT-down.png"] forState:UIControlStateSelected];
        [connectingIndicator stopAnimating];
        connectingIndicator.hidden = NO;
        
    }
    sensorsConnected = hasConnections;
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

- (UIImage*)sensorImageForStrength:(float)signal
{
    // check the case for invalid signal strength (-1).
    UIImage *sigImg= [UIImage imageNamed:@"NO-CONNECTION.png"];
    if (signal == -1) return sigImg;

    // ANT signal strength is range [0 .. 1.0] representing a percentage
    // of messages received over messages expected.  BTLE signal strength
    // is RSSI in dBm.  Assuming TX power is 0, the RSSI will never be
    // 0 or greater.  If the TX power is higher, there may be situations
    // where RSSI could be positive.  If this happens, and RSSI is 1, that
    // would still be full strength on the ANT scale.  Since the RSSI value
    // is an integer, the only errant value would be the case in which
    // the RSSI is 0, which on the ANT scale is no signal.
    //
    // check for the BTLE signal strength.
    if ( signal < 0 || signal > 1)
    {
        // BTLE sensor with connection
        if ( signal > -50 )
        {
            sigImg = [UIImage imageNamed:@"3-BARS.png"];
        }
        else if ( signal > -75 )
        {
            sigImg = [UIImage imageNamed:@"2-BARS.png"];
        }
        else
        {
            sigImg = [UIImage imageNamed:@"1-BAR.png"];
        }
    }
    //
    // check for the ANT signal strength.
    else
    {
        // ANT+ sensor or disconnected sensor
        if (signal > 0.8)
        {
            sigImg = [UIImage imageNamed:@"3-BARS.png"];
        }
        else if (signal > 0.4)
        {
            sigImg = [UIImage imageNamed:@"2-BARS.png"];
        }
        else
        {
            sigImg = [UIImage imageNamed:@"1-BAR.png"];
        }
    }
    return sigImg;
}

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    
}


//--------------------------------------------------------------------------------
- (void)updateData
{
}

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    // update the stored connection settings.
    [hardwareConnector.settings saveConnectionInfo:connectionInfo];
}

//--------------------------------------------------------------------------------
- (void)disconnectSensors
{
    NSLog(@"Disconnect sensors");
    for (NSNumber * st in sensorTypes) {
        WFSensorConnection *sConn = [sensorConnections objectForKey:st];
        if (sConn) {
            sConn.delegate = nil;
            [sConn disconnect];
            [sensorConnections removeObjectForKey:st];
        }
    }
    sensorsConnected = NO;
    [self resetDisplay];
}

- (void)disconnectSensor:(NSNumber*)sensorType
{
    NSLog(@"Disconnect sensor");
    WFSensorConnection *sConn = [sensorConnections objectForKey:sensorType];
    if (sConn) {
        sConn.delegate = nil;
        [sConn disconnect];
        [sensorConnections removeObjectForKey:sensorType];
    }
    if ([sensorConnections count]==0) {
        sensorsConnected = NO;
        [self resetDisplay];
    }
}

#pragma mark Properties

//--------------------------------------------------------------------------------
- (void)storeSensorConnection:(WFSensorConnection *)conn
{
    NSNumber * sensorType = [NSNumber numberWithInt:conn.sensorType];
    WFSensorConnection *oldConn = [sensorConnections objectForKey:sensorType];
    
    oldConn.delegate = nil;
    [sensorConnections removeObjectForKey:sensorType];
    if (conn !=nil) {
        [sensorConnections setObject:conn forKey:sensorType];
        conn.delegate = self;
    }
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)connectSensorClicked:(id)sender
{
    if (sensorsConnected) {
        NSLog(@"disconnect sensors");
         [self disconnectSensors];
    } else {
        // get the current connection status.
     //   if (desiredNetwork == WF_NETWORKTYPE_ANTPLUS) [hardwareConnector enableBTLE:NO];
        NSLog(@"Connect sensors");
        WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
        NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSDictionary * wildcardSwitches = [appDelegate wildcardSwitches];
        NSDictionary * proximitySwitches = [appDelegate proximitySwitches];
        for (NSNumber * st in sensorTypes) {
            WFSensorConnection *sConn = [sensorConnections objectForKey:st];
            if ( sConn != nil )
            {
                connState = sConn.connectionStatus;
            }
            BOOL paramsFromConnector = NO;
            // set the button state based on the connection state.
            switch (connState)
            {
                case WF_SENSOR_CONNECTION_STATUS_IDLE:
                {
                    // create the connection params.
                    WFConnectionParams* params = nil;
                    //
                    // if wildcard search is specified, create empty connection params.
                    if ( (ACCEPT_NIL_WILDCARD && [wildcardSwitches objectForKey:st] == nil) || [[wildcardSwitches objectForKey:st] boolValue] == YES)
                    {
                        params = [[[WFConnectionParams alloc] init] autorelease];
                        params.sensorType = [st intValue];
                        
                        NSLog(@"wildcard params");
                    }
                    //
                    // otherwise, get the params from the stored settings.
                    else
                    {
                        NSLog(@"params from connector");
                        params = [hardwareConnector.settings connectionParamsForSensorType:[st intValue]];
                        paramsFromConnector = YES;
                    }
                    
                    if ( params != nil)
                    {
                        if ( params.isWildcard && !paramsFromConnector)
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
                            if ( [proximitySwitches objectForKey:st] != nil && [[proximitySwitches objectForKey:st] boolValue] == YES )
                            {
                                sConn = [hardwareConnector requestSensorConnection:params withProximity:WF_PROXIMITY_RANGE_1];
                            }
                            //
                            // use normal search.
                            else
                            {
                                NSLog(@"normal wildcard search");
                                sConn = [hardwareConnector requestSensorConnection:params];
                            }
                            
                        }
                        // otherwise, use normal connection request.
                        else
                        {
                            sConn = [hardwareConnector requestSensorConnection:params];
                            
                            NSLog(@"request specific sensor");
                        }
                        
                        [self storeSensorConnection:sConn];
                        sConn.delegate = self;
                    }
                    break;
                }
                    
                case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
                case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
                    if ([sensorTypes count] == 1) [self disconnectSensor:st];
                    break;
                case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
                case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
                    // do nothing.
                    break;
            }
           
            connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
        }
	}
	[self checkState];
}

- (void)buildCustomNavbar:(UIImage*)background
{
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
    [customNavigationBar setBackgroundWith:background];
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
    ConfigAndHelpView *btns = [nib objectAtIndex:0];
    
    [btns.configButton addTarget:self action:@selector(doConfig:) forControlEvents:UIControlEventTouchUpInside];
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
}

-(NSString*)percentForBattStatus:(WFBatteryStatus_t)status {
    NSString* battStatus = @"n/a";
    switch (status)
    {
        case WF_BATTERY_STATUS_NEW:
            battStatus = @"100%";
            break;
        case WF_BATTERY_STATUS_GOOD:
            battStatus = @"90%";
            break;
        case WF_BATTERY_STATUS_OK:
            battStatus = @"70%";
            break;
        case WF_BATTERY_STATUS_LOW:
            battStatus = @"30%";
            break;
        case WF_BATTERY_STATUS_CRITICAL:
            battStatus = @"10%";
            break;
        case WF_BATTERY_STATUS_NOT_AVAILABLE:
        default:
            battStatus = @"n/a";
            break;
    }
    return battStatus;
}

- (void)doConfig:(id)sender
{
}

- (void)doHelp:(id)sender
{
}


- (void)dismissModal
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
