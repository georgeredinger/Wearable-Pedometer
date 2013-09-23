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
//  TemperatureViewController.m
//  WahooDemo
//
//  Created by Michael Moore on 12/22/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import "TemperatureViewController.h"
#import "BTOverviewVC.h"


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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
    {
        sensorType = WF_SENSORTYPE_HEALTH_THERMOMETER;
        applicableNetworks = WF_NETWORKTYPE_BTLE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Temperature";
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
        float temp = htData.temperature;
        NSString* units = @"° C";
        if ( !hardwareConnector.settings.useMetricUnits )
        {
            const float convFactor = (9.0/5.0);
            temp = (convFactor * temp) + 32;
            units = @"° F";
        }
        tempLabel.text = [NSString stringWithFormat:@"%1.2f%@", temp, units];
        tempTypeLabel.text = [NSString stringWithFormat:@"%u", htData.temperatureType];
	}
	else 
	{
		[self resetDisplay];
	}
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
