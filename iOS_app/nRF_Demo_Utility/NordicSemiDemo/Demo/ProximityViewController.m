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
//  ProximityViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 12/19/11.
//

#import "ProximityViewController.h"
#import "NordicSemiAppDelegate.h"
#import "HelpViewController.h"

@implementation ProximityViewController

@synthesize alertLevelLabel;
@synthesize txPowerLabel;
@synthesize proxLabel;
@synthesize battLevelLabel;
@synthesize linkLossAlertSegment;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[alertLevelLabel release];
    [txPowerLabel release];
    [proxLabel release];
    [battLevelLabel release];
    [linkLossAlertSegment release];
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Proximity";
    
    [linkLossAlertSegment setFrame:CGRectMake(76, 203, 158, 35)];
    
    // get the app delegate.
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // initialize the link-loss alert level.
    switch ( appDelegate.proximityAlertLevel )
    {
        case WF_BTLE_CH_ALERT_LEVEL_NONE:
            linkLossAlertSegment.selectedSegmentIndex = 0;
            break;
            
        case WF_BTLE_CH_ALERT_LEVEL_MILD:
            linkLossAlertSegment.selectedSegmentIndex = 1;
            break;
            
        case WF_BTLE_CH_ALERT_LEVEL_HIGH:
            linkLossAlertSegment.selectedSegmentIndex = 2;
            break;
    }
    //
    // set the link-loss alert level on the device.
    [self.proximityConnection setAlertLevel:appDelegate.proximityAlertLevel];
    
    // set the proximity delegate to this instance.
    self.proximityConnection.proximityDelegate = self;
    
    // determine whether the device is within the proximity threshold.
    if ( [self.proximityConnection isInRange] )
    {
        proxLabel.text = @"IN RANGE";
    }
    else
    {
        proxLabel.text = @"OUT OF RANGE";
    }
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFProximityDelegate Implementation

//--------------------------------------------------------------------------------
- (void)proximityConnection:(WFProximityConnection*)proxConn proximityAlert:(WFBTLEChAlertLevel_t)alertLevel proximityMode:(WFProximityAlertMode_t)mode signalLoss:(int)signalLoss
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    // action based on current proximity monitoring mode.
    switch ( mode )
    {
        case WF_PROXIMITY_ALERT_MODE_FARTHER:
            // the device has moved out of range.
            proxLabel.text = @"OUT OF RANGE";
            //
            // begin monitoring for device back in range.
            [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_CLOSER];
            [proxConn setProximityAlertThreshold:appDelegate.proximityAlertThreshold-1 alertLevel:appDelegate.proximityAlertLevel];
            //
            // send immediate alert - makes device beep.
            [proxConn sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_MILD];
            break;
            
        case WF_PROXIMITY_ALERT_MODE_CLOSER:
            // the device has moved in range.
            proxLabel.text = @"IN RANGE";
            //
            // begin monitoring for device out of range.
            [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_FARTHER];
            [proxConn setProximityAlertThreshold:appDelegate.proximityAlertThreshold alertLevel:appDelegate.proximityAlertLevel];
    }
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    
    // set the proximity alert parameters.
    WFProximityConnection* proxConn = self.proximityConnection;
    if ( proxConn )
    {
        if ( [proxConn isInRange] )proxLabel.text = @"IN RANGE";
        // set proximity monitoring to monitor link loss - device moving farther away.
        proxConn.proximityDelegate = self;
        [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_FARTHER];
        NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
        [proxConn setProximityAlertThreshold:appDelegate.proximityAlertThreshold alertLevel:appDelegate.proximityAlertLevel];
    }
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	signalEfficiencyLabel.text = @"n/a";
	deviceIdLabel.text = @"n/a";
	alertLevelLabel.text = @"n/a";
	txPowerLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFProximityData* proxData = [self.proximityConnection getProximityData];
	if ( proxData != nil )
	{
        // update the device id
        //use the deviceIDString property as this will return the ID for both ANT+
        //and BTLE devices
        NSString* deviceID = self.sensorConnection.deviceIDString;
        if (deviceID==nil) deviceID=@"n/a";
        else deviceID = [WFSensorCommonViewController formatUUID:deviceID];
		deviceIdLabel.text = [NSString stringWithFormat:@"%@", deviceID];
        
        // update the signal efficiency.
		float signal = [self.sensorConnection signalEfficiency];
        //
        // signal efficency is % for ANT connections, dBm for BTLE.
		signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f dBm", signal];
        
        alertLevelLabel.text = [NSString stringWithFormat:@"%u", proxData.alertLevel];
        txPowerLabel.text = [NSString stringWithFormat:@"%d dBm", proxData.txPowerLevel];
        
        if ( proxData.btleCommonData.batteryLevel == 0xFF )
        {
            battLevelLabel.text = @"n/a";
        }
        else
        {
            battLevelLabel.text = [NSString stringWithFormat:@"%u %%", proxData.btleCommonData.batteryLevel];
        }
	}
	else 
	{
		[self resetDisplay];
	}
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"proximityconfighelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

#pragma mark -
#pragma mark ProximityViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFProximityConnection*)proximityConnection
{
	WFProximityConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFProximityConnection class]] )
	{
		retVal = (WFProximityConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)mildAlertClicked:(id)sender
{
    [self.proximityConnection sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_MILD];
}

//--------------------------------------------------------------------------------
- (IBAction)highAlertClicked:(id)sender
{
    [self.proximityConnection sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_HIGH];
}

//--------------------------------------------------------------------------------
- (IBAction)changedAlertLevel:(id)sender
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    switch ( linkLossAlertSegment.selectedSegmentIndex )
    {
        case 0:
            NSLog(@"set alert level OFF");
            appDelegate.proximityAlertLevel = WF_BTLE_CH_ALERT_LEVEL_NONE;
            [self.proximityConnection setAlertLevel:WF_BTLE_CH_ALERT_LEVEL_NONE];
            break;
        case 1:
            NSLog(@"set alert level MILD");
            appDelegate.proximityAlertLevel = WF_BTLE_CH_ALERT_LEVEL_MILD;
            [self.proximityConnection setAlertLevel:WF_BTLE_CH_ALERT_LEVEL_MILD];
            break;
        case 2:
            NSLog(@"set alert level HIGH");
            appDelegate.proximityAlertLevel = WF_BTLE_CH_ALERT_LEVEL_HIGH;
            [self.proximityConnection setAlertLevel:WF_BTLE_CH_ALERT_LEVEL_HIGH];
            break;
    }
}

@end
