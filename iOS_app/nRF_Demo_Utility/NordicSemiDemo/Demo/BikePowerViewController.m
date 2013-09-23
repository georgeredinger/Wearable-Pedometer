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
//  BikePowerViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 3/25/10.
//

#import "BikePowerViewController.h"
#import "BikePowerCalibration.h"



/////////////////////////////////////////////////////////////////////////////
// BikePowerViewController Implementation.
/////////////////////////////////////////////////////////////////////////////

@implementation BikePowerViewController

@synthesize eventCountLabel;
@synthesize instantCadenceLabel;
@synthesize accumulatedTorqueLabel;
@synthesize instantPowerLabel;
@synthesize averagePowerLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[eventCountLabel release];
	[instantCadenceLabel release];
	[accumulatedTorqueLabel release];
	[instantPowerLabel release];
	[averagePowerLabel release];
	
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
    
    self.navigationItem.title = @"Bike Power";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	deviceIdLabel.text = @"n/a";
	signalEfficiencyLabel.text = @"n/a";
	eventCountLabel.text = @"n/a";
	instantCadenceLabel.text = @"n/a";
	accumulatedTorqueLabel.text = @"n/a";
	instantPowerLabel.text = @"n/a";
	averagePowerLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFBikePowerData* bpData = [self.bikePowerConnection getBikePowerData];
	WFBikePowerRawData* bpRawData = [self.bikePowerConnection getBikePowerRawData];
	if ( bpData != nil )
	{
        // update the signal efficiency.
		int deviceId = self.sensorConnection.deviceNumber;
		float signal = [self.sensorConnection signalEfficiency];
		deviceIdLabel.text = [NSString stringWithFormat:@"%d", deviceId];
		if (signal == -1) signalEfficiencyLabel.text = @"n/a";
		else signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f%%", (signal*100)];
		
        // update the basic data.
		eventCountLabel.text = [NSString stringWithFormat:@"%ld", bpData.crankRevolutions];
		instantCadenceLabel.text = [NSString stringWithFormat:@"%d rpm", bpData.instantCadence];
		accumulatedTorqueLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.accumulatedTorque];
        averagePowerLabel.text = [bpData formattedPower:TRUE];
        // using unformatted value.
		// averagePowerLabel.text = [NSString stringWithFormat:@"%d", bpData.ulAveragePower];
        //
        // only available for "power-only" meters.
		instantPowerLabel.text = [NSString stringWithFormat:@"%d watts", bpRawData.powerOnlyData.instantPower];
        
	}
	else
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark BikePowerViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBikePowerConnection*)bikePowerConnection
{
	WFBikePowerConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFBikePowerConnection class]] )
	{
		retVal = (WFBikePowerConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)calibrateClicked:(id)sender
{
    // configure and display a power calibration view controller.
	BikePowerCalibration *calView = [[BikePowerCalibration alloc] initWithNibName:@"BikePowerCalibration" bundle:nil];
	calView.bikePowerConnection = [self bikePowerConnection];
    if (self.parentNavController) { // config view is in ConfigScrollerController
        [self.parentNavController pushViewController:calView animated:TRUE];
    } else {
        [self.navigationController pushViewController:calView animated:TRUE];
    }
	[calView release];
}

@end
