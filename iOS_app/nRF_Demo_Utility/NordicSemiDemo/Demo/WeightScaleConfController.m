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

#import "WeightScaleConfController.h"
#import "NordicNavigationBar.h"
#import "ConfigAndHelpView.h"
#import "HelpViewController.h"


@interface WeightScaleConfController (_PRIVATE_)

- (void)sendUserProfile;

@end


@implementation WeightScaleConfController

@synthesize bodyWeightLabel;
@synthesize hydrationPercentLabel;
@synthesize bodyFatPercentLabel;
@synthesize muscleMassLabel;
@synthesize boneMassLabel;
@synthesize activeMetabolicRateLabel;
@synthesize basalMetabolicRateLabel;
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
	[muscleMassLabel release];
	[boneMassLabel release];
	[activeMetabolicRateLabel release];
	[basalMetabolicRateLabel release];
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
    
    
    UIImage* titleImage = [UIImage imageNamed:@"NORDIC-LOGO.png"];
    UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [titleView addSubview:titleImageView];
    titleImageView.center = titleView.center;
    CGRect titleImageViewFrame = titleImageView.frame;
    titleImageView.frame = titleImageViewFrame;
    self.navigationItem.titleView = titleView;
    [titleImageView release];
    [titleView release];
    
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"NordicNavbar.png"]];
    // Create a custom back button
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
    ConfigAndHelpView *btns = [nib objectAtIndex:0];
    
    btns.configButton.hidden = YES;
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
    
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease] animated:YES];
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
	muscleMassLabel.text = @"n/a";
	boneMassLabel.text = @"n/a";
	activeMetabolicRateLabel.text = @"n/a";
	basalMetabolicRateLabel.text = @"n/a";
	isUserProfileSelectedLabel.text = @"n/a";
	userProfileIdLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFWeightScaleData* wsData = [self.weightScaleConnection getWeightScaleData];
    
    WFANTWeightScaleData *wsANTData = nil;
    if ([wsData isKindOfClass:[WFANTWeightScaleData class]]) {
        wsANTData = (WFANTWeightScaleData *) wsData;
    }
	
	if ( wsData != nil )
	{
        if ( wsData.bodyWeight == WF_WEIGHT_SCALE_COMPUTING )
        {
            bodyWeightLabel.text = @"--";
        }
        else
        {
            float weight = (wsData.bodyWeight == -1 ? 0 : wsData.bodyWeight);
            bodyWeightLabel.text = [NSString stringWithFormat:@"%1.2f kg", weight];
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
        // update the signal efficiency.
		int deviceId = self.weightScaleConnection.deviceNumber;
		float signal = [self.weightScaleConnection signalEfficiency];
		deviceIdLabel.text = [NSString stringWithFormat:@"%d", deviceId];
		if (signal == -1) signalEfficiencyLabel.text = @"n/a";
		else signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f%%", (signal*100)];
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

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"wsconfighelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}
@end
