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
//  BikePowerViewController.m
//  FisicaDemo
//
//  Created by Michael Moore on 3/25/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
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
@synthesize speedLabel;
@synthesize speedUnitsLabel;
@synthesize pedalRightLabel;
@synthesize pedalLeftLabel;
@synthesize pedalPower;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[eventCountLabel release];
	[instantCadenceLabel release];
	[accumulatedTorqueLabel release];
	[instantPowerLabel release];
	[speedLabel release];
	
    [pedalRightLabel release];
    [pedalLeftLabel release];
    [pedalPower release];
    [speedUnitsLabel release];
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
        sensorType = WF_SENSORTYPE_BIKE_POWER;
    }
    
    return self;
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
    [self setSpeedUnitsLabel:nil];
    [self setPedalPower:nil];
    [self setPedalLeftLabel:nil];
    [self setPedalRightLabel:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	eventCountLabel.text = @"n/a";
	instantCadenceLabel.text = @"n/a";
	accumulatedTorqueLabel.text = @"n/a";
	instantPowerLabel.text = @"n/a";
	speedLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFBikePowerData* bpData = [self.bikePowerConnection getBikePowerData];
	WFBikePowerRawData* bpRawData = [self.bikePowerConnection getBikePowerRawData];
	if ( bpData != nil )
	{
        // update the basic data.
		eventCountLabel.text = [NSString stringWithFormat:@"%ld", bpData.accumulatedEventCount];
        accumulatedTorqueLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.accumulatedTorque];
		
        // POWER
        //instantPowerLabel.text = [NSString stringWithFormat:@"%d", bpData.instantPower];
        instantPowerLabel.text = [bpData formattedPower:FALSE];
        
        
        // CADENCE
        if(bpData.crankRevolutionSupported)
        {
            //instantCadenceLabel.text = [NSString stringWithFormat:@"%d", bpData.instantCadence];
            instantCadenceLabel.text = [bpData formattedCadence:FALSE];
        }
        else
        {
            instantCadenceLabel.text = @"n/a";
        }
        
        // SPEED
        if(bpData.wheelRevolutionSupported)
        {
            //double spd = 0.06 * instantWheelRPM * hardwareConnector.settings.bikeWheelCircumference;
            speedLabel.text = [bpData formattedSpeed:FALSE];
            speedUnitsLabel.text = hardwareConnector.settings.useMetricUnits ? @"kph" : @"mph";
        }
        else
        {
            speedLabel.text = @"n/a";
        }
            
            
        
        //Update Pedal power
        if(bpRawData.powerOnlyData.pedalPowerSupported)
        {
            //Some power meters don't know the difference between left and right
            if(bpRawData.powerOnlyData.pedalDifferentiation)
            {
                pedalRightLabel.text = @"R";
                pedalLeftLabel.text = @"L";
            }
            else
            {
                pedalRightLabel.text = @"?";
                pedalLeftLabel.text = @"?";
            }
            
            //set the actual power contribution
            pedalPower.progress = 1.0-bpRawData.powerOnlyData.pedalPowerContributionPercent; 
            pedalRightLabel.text = [NSString stringWithFormat:@"%@ %g%%", pedalRightLabel.text, (bpRawData.powerOnlyData.pedalPowerContributionPercent*100.0)];
            pedalLeftLabel.text = [NSString stringWithFormat:@"%@ %g%%", pedalLeftLabel.text, ((1.0-bpRawData.powerOnlyData.pedalPowerContributionPercent)*100.0)];
            
        }
        else
        {
            //Not supported, disabled
            pedalRightLabel.text = @"X";
            pedalLeftLabel.text = @"X";
            pedalPower.progress = 0.5;
        }
            
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
	[self.navigationController pushViewController:calView animated:TRUE];

	[calView release];
}

@end
