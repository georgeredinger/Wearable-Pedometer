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
//  HeartrateViewController.m
//  FisicaDemo
//
//  Created by Michael Moore on 2/20/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "HeartrateViewController.h"


@implementation HeartrateViewController

@synthesize computedHeartrateLabel;
@synthesize beatTimeLabel;
@synthesize beatCountLabel;
@synthesize previousBeatLabel;
@synthesize battLevelLabel;



#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[computedHeartrateLabel release];
	[beatTimeLabel release];
	[beatCountLabel release];
	[previousBeatLabel release];
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
        //Their is 3 types of HR monitors that work with the Wahoo API,
        // ANT+, Suunto (a version of ANT) and Bluetooth 4 (BTLE)
        //You can choose to search for indivdual types or ANY
        //If you select ANT, you are connected to the first availible 
        //HR sensor
        
        
        sensorType = WF_SENSORTYPE_HEARTRATE;
        applicableNetworks = WF_NETWORKTYPE_ANTPLUS | WF_NETWORKTYPE_BTLE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Heart Rate";
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
- (void)resetDisplay
{
    [super resetDisplay];
    
	computedHeartrateLabel.text = @"n/a";
	beatTimeLabel.text = @"n/a";
	beatCountLabel.text = @"n/a";
	previousBeatLabel.text = @"n/a";
    battLevelLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFHeartrateData* hrData = [self.heartrateConnection getHeartrateData];
	WFHeartrateRawData* hrRawData = [self.heartrateConnection getHeartrateRawData];
	if ( hrData != nil )
	{
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:hrData.computedHeartrate];
        
        // unformatted value.
		// computedHeartrateLabel.text = [NSString stringWithFormat:@"%d", hrData.computedHeartrate];
        
        // update basic data.
        computedHeartrateLabel.text = [hrData formattedHeartrate:TRUE];
		beatTimeLabel.text = [NSString stringWithFormat:@"%d", hrData.beatTime];
		
        // update raw data.
		beatCountLabel.text = [NSString stringWithFormat:@"%d", hrRawData.beatCount];
		previousBeatLabel.text = [NSString stringWithFormat:@"%d", hrRawData.previousBeatTime];
        
        // BTLE HR monitors optionally transmit R-R intervals.  this demo does not
        // display R-R values.  however, the following code is included to demonstrate
        // how to read and parse R-R intervals.
        if ( [hrData isKindOfClass:[WFBTLEHeartrateData class]] )
        {
            NSArray* rrIntervals = [(WFBTLEHeartrateData*)hrData rrIntervals];
            for ( NSNumber* rr in rrIntervals )
            {
                NSLog(@"R-R Interval: %1.3f s.", [rr doubleValue]);
            }
        }
        
        // the common data for BTLE sensors is still in beta state.  this data
        // will eventually be merged with the existing common data.  for current demo
        // purposes, the battery level is updated directly from this HR view controller.
        if ( hrRawData.btleCommonData )
        {
            battLevelLabel.text = [NSString stringWithFormat:@"%u %%", hrRawData.btleCommonData.batteryLevel];
        }
	}
	else 
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark HeartrateViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHeartrateConnection*)heartrateConnection
{
	WFHeartrateConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFHeartrateConnection class]] )
	{
		retVal = (WFHeartrateConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
