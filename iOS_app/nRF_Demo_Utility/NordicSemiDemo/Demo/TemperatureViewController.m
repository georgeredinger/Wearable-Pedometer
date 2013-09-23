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
//  TemperatureViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 12/22/11.
//

#import "TemperatureViewController.h"
#import "HelpViewController.h"


@implementation TemperatureViewController

@synthesize tempLabel;
@synthesize tempTypeLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[tempLabel release];
    [tempTypeLabel release];
	
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
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	signalEfficiencyLabel.text = @"n/a";
	deviceIdLabel.text = @"n/a";
	tempLabel.text = @"n/a";
	tempTypeLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFHealthThermometerData* htData = [self.healthThermometerConnection getHealthThermometerData];
	if ( htData != nil )
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
        
        tempLabel.text = [NSString stringWithFormat:@"%1.2f", htData.temperature];
        tempTypeLabel.text = [NSString stringWithFormat:@"%u", htData.temperatureType];
	}
	else 
	{
		[self resetDisplay];
	}
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tempconfighelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

#pragma mark -
#pragma mark TemperatureViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHealthThermometerConnection*)healthThermometerConnection
{
	WFHealthThermometerConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFHealthThermometerConnection class]] )
	{
		retVal = (WFHealthThermometerConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
