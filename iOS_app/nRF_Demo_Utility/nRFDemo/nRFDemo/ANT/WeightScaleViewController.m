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
//  WeightScaleViewController.m
//  FisicaDemo
//
//  Created by Michael Moore on 4/5/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "WeightScaleViewController.h"


@interface WeightScaleViewController (_PRIVATE_)

- (void)sendUserProfile;

@end


@implementation WeightScaleViewController

@synthesize bodyWeightLabel;
@synthesize hydrationPercentLabel;
@synthesize bodyFatPercentLabel;
@synthesize activeMetabolicRateLabel;
@synthesize basalMetabolicRateLabel;
@synthesize muscleMassLabel;
@synthesize boneMassLabel;
@synthesize isUserProfileSelectedLabel;
@synthesize userProfileIdLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[bodyWeightLabel release];
	[hydrationPercentLabel release];
	[bodyFatPercentLabel release];
	[activeMetabolicRateLabel release];
	[basalMetabolicRateLabel release];
	[muscleMassLabel release];
	[boneMassLabel release];
	[isUserProfileSelectedLabel release];
	[userProfileIdLabel release];
	
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
        sensorType = WF_SENSORTYPE_WEIGHT_SCALE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Weight Scale";
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
    
	bodyWeightLabel.text = @"n/a";
	hydrationPercentLabel.text = @"n/a";
	bodyFatPercentLabel.text = @"n/a";
	activeMetabolicRateLabel.text = @"n/a";
	basalMetabolicRateLabel.text = @"n/a";
	muscleMassLabel.text = @"n/a";
	boneMassLabel.text = @"n/a";
	isUserProfileSelectedLabel.text = @"n/a";
	userProfileIdLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFWeightScaleData* wsData = [self.weightScaleConnection getWeightScaleData];
    WFANTWeightScaleData* wsANTData = nil;
    if ( [wsData isKindOfClass:[WFANTWeightScaleData class]] ) wsANTData = (WFANTWeightScaleData*)wsData;
    
	if ( wsData != nil )
	{
        if ( wsData.bodyWeight == WF_WEIGHT_SCALE_INVALID )
        {
            bodyWeightLabel.text = @"n/a";
        }
        else if ( wsData.bodyWeight == WF_WEIGHT_SCALE_COMPUTING )
        {
            bodyWeightLabel.text = @"--";
        }
        else
        {
            bodyWeightLabel.text = [NSString stringWithFormat:@"%1.2f kg", wsData.bodyWeight];
        }
        
        if ( wsANTData.hydrationPercent == WF_WEIGHT_SCALE_INVALID )
        {
            hydrationPercentLabel.text = @"n/a";
        }
        else if ( wsANTData.hydrationPercent == WF_WEIGHT_SCALE_COMPUTING )
        {
            hydrationPercentLabel.text = @"--";
        }
        else
        {
            hydrationPercentLabel.text = [NSString stringWithFormat:@"%1.2f %%", wsANTData.hydrationPercent ];
        }
        
        if ( wsANTData.bodyFatPercent == WF_WEIGHT_SCALE_INVALID )
        {
            bodyFatPercentLabel.text = @"n/a";
        }
        else if ( wsANTData.bodyFatPercent == WF_WEIGHT_SCALE_COMPUTING )
        {
            bodyFatPercentLabel.text = @"--";
        }
        else
        {
            bodyFatPercentLabel.text = [NSString stringWithFormat:@"%1.2f %%", wsANTData.bodyFatPercent ];
        }
        
        if ( wsANTData.activeMetabolicRate == WF_WEIGHT_SCALE_INVALID )
        {
            activeMetabolicRateLabel.text = @"n/a";
        }
        else if ( wsANTData.activeMetabolicRate == WF_WEIGHT_SCALE_COMPUTING )
        {
            activeMetabolicRateLabel.text = @"--";
        }
        else
        {
            activeMetabolicRateLabel.text = [NSString stringWithFormat:@"%1.2f kcal", wsANTData.activeMetabolicRate];
        }
        
        if ( wsANTData.basalMetabolicRate == WF_WEIGHT_SCALE_INVALID )
        {
            basalMetabolicRateLabel.text = @"n/a";
        }
        else if ( wsANTData.basalMetabolicRate == WF_WEIGHT_SCALE_COMPUTING )
        {
            basalMetabolicRateLabel.text = @"--";
        }
        else
        {
            basalMetabolicRateLabel.text = [NSString stringWithFormat:@"%1.2f kcal", wsANTData.basalMetabolicRate];
        }
        
        if ( wsANTData.muscleMass == WF_WEIGHT_SCALE_INVALID )
        {
            muscleMassLabel.text = @"n/a";
        }
        else if ( wsANTData.muscleMass == WF_WEIGHT_SCALE_COMPUTING )
        {
            muscleMassLabel.text = @"--";
        }
        else
        {
            muscleMassLabel.text = [NSString stringWithFormat:@"%1.2f kg", wsANTData.muscleMass];
        }
        
        if ( wsANTData.boneMass == WF_WEIGHT_SCALE_INVALID )
        {
            boneMassLabel.text = @"n/a";
        }
        else if ( wsANTData.boneMass == WF_WEIGHT_SCALE_COMPUTING )
        {
            boneMassLabel.text = @"--";
        }
        else
        {
            boneMassLabel.text = [NSString stringWithFormat:@"%1.1f kg", wsANTData.boneMass];
        }
        
		isUserProfileSelectedLabel.text = wsANTData.isUserProfileSelected ? @"Yes" : @"No";
		userProfileIdLabel.text = [NSString stringWithFormat:@"%d", wsData.userProfileId];		
	}
	else
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark WeightScaleViewController Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)sendUserProfile
{
    // ensure a valid weight scale connection.
    if ( self.weightScaleConnection )
    {
        // create and configure a weight scale profile structure.
        WFWeightScaleUserProfile_t profile;
        
        profile.userProfileId = 16;
        profile.gender = WF_WSS_GENDER_MALE;
        profile.age = 32;
        profile.height = 178;
        profile.athelete = FALSE;
        profile.activityLevel = 1;
        
        // send the weight scale profile through the connection.
        [self.weightScaleConnection setWeightScaleUserProfile:&profile];
    }
}


#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFWeightScaleConnection*)weightScaleConnection
{
	WFWeightScaleConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFWeightScaleConnection class]] )
	{
		retVal = (WFWeightScaleConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)profileClicked:(id)sender
{
    [self sendUserProfile];
}

@end
