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
//  BikeCadenceViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/23/10.
//

#import "BikeCadenceViewController.h"


@implementation BikeCadenceViewController

@synthesize lastCadenceTimeLabel;
@synthesize totalCadenceRevolutionsLabel;
@synthesize computedCadenceLabel;
@synthesize averageCadenceLabel;

#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[lastCadenceTimeLabel release];
	[totalCadenceRevolutionsLabel release];
	[computedCadenceLabel release];
	[averageCadenceLabel release];
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
    
    self.navigationItem.title = @"Bike Cadence";
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
	signalEfficiencyLabel.text = @"n/a";
	deviceIdLabel.text = @"n/a";
	lastCadenceTimeLabel.text = @"n/a";
	totalCadenceRevolutionsLabel.text = @"n/a";
	averageCadenceLabel.text = @"n/a";
	computedCadenceLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFBikeCadenceData* bcData = [self.bikeCadenceConnection getBikeCadenceData];
	if ( bcData != nil )
	{
        // update the signal efficiency.
		int deviceId = self.sensorConnection.deviceNumber;
		float signal = [self.sensorConnection signalEfficiency];
		deviceIdLabel.text = [NSString stringWithFormat:@"%d", deviceId];
		if (signal == -1) signalEfficiencyLabel.text = @"n/a";
		else signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f%%", (signal*100)];
		
        // update the basic data.
		lastCadenceTimeLabel.text = [NSString stringWithFormat:@"%3.3f", bcData.accumCadenceTime];
		totalCadenceRevolutionsLabel.text = [NSString stringWithFormat:@"%ld", bcData.accumCrankRevolutions];
		computedCadenceLabel.text = [bcData formattedCadence:FALSE];
        
        // using unformatted values.
		// computedCadenceLabel.text = [NSString stringWithFormat:@"%d", bcData.instantCrankRPM];

        // calculate the average cadence.
		if (bcData.accumCadenceTime > 0)
		{
			float averageCadence = (((float) bcData.accumCrankRevolutions / (float) bcData.accumCadenceTime) * 60);
			averageCadenceLabel.text = [NSString stringWithFormat:@"%0.0f", averageCadence];
		}
	}
	else
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark BikeCadenceViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBikeCadenceConnection*)bikeCadenceConnection
{
	WFBikeCadenceConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFBikeCadenceConnection class]] )
	{
		retVal = (WFBikeCadenceConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
