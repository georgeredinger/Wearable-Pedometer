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
//  ProximityViewController.m
//  WahooDemo
//
//  Created by Michael Moore on 12/19/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import "ProximityViewController.h"
#import "BTOverviewVC.h"


@implementation ProximityViewController

@synthesize alertLevelLabel;
@synthesize txPowerLabel;
@synthesize proxLabel;
@synthesize battLevelLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[alertLevelLabel release];
    [txPowerLabel release];
    [proxLabel release];
    [battLevelLabel release];
	
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
        sensorType = WF_SENSORTYPE_PROXIMITY;
        applicableNetworks = WF_NETWORKTYPE_BTLE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Proximity";
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
    // action based on current proximity monitoring mode.
    switch ( mode )
    {
        case WF_PROXIMITY_ALERT_MODE_FARTHER:
            // the device has moved out of range.
            proxLabel.text = @"OUT OF RANGE";
            //
            // begin monitoring for device back in range.
            [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_CLOSER];
            [proxConn setProximityAlertThreshold:WF_PROXIMITY_ALERT_THRESHOLD_1 alertLevel:WF_BTLE_CH_ALERT_LEVEL_MILD];
            break;
            
        case WF_PROXIMITY_ALERT_MODE_CLOSER:
            // the device has moved in range.
            proxLabel.text = @"IN RANGE";
            //
            // begin monitoring for device out of range.
            [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_FARTHER];
            [proxConn setProximityAlertThreshold:WF_PROXIMITY_ALERT_THRESHOLD_2 alertLevel:WF_BTLE_CH_ALERT_LEVEL_MILD];
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
        // set proximity monitoring to monitor link loss - device moving farther away.
        proxConn.proximityDelegate = self;
        [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_FARTHER];
        [proxConn setProximityAlertThreshold:WF_PROXIMITY_ALERT_THRESHOLD_2 alertLevel:WF_BTLE_CH_ALERT_LEVEL_MILD];
    }
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
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
- (IBAction)setMildClicked:(id)sender
{
    [self.proximityConnection setAlertLevel:WF_BTLE_CH_ALERT_LEVEL_MILD];
}

//--------------------------------------------------------------------------------
- (IBAction)setHighClicked:(id)sender
{
    [self.proximityConnection setAlertLevel:WF_BTLE_CH_ALERT_LEVEL_HIGH];
}

@end
