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
//  BTGlucoseVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/22/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "BTGlucoseVC.h"
#import "HelpViewController.h"


@implementation BTGlucoseVC



#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    
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
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	signalEfficiencyLabel.text = @"n/a";
	deviceIdLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFBTLEGlucoseData* glucData = [self.glucoseConnection getGlucoseData];
	if ( glucData != nil )
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
	}
	else 
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark BTGlucoseVC Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBTLEGlucoseConnection*)glucoseConnection
{
	WFBTLEGlucoseConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFBTLEGlucoseConnection class]] )
	{
		retVal = (WFBTLEGlucoseConnection*)self.sensorConnection;
	}
	
	return retVal;
}


- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bgmconfighelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}
@end
