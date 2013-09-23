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
//  BTGlucoseDetailVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "BTGlucoseDetailVC.h"
#import "NordicNavigationBar.h"
#import "ConfigAndHelpView.h"
#import "HelpViewController.h"


@interface BTGlucoseDetailVC (_PRIVATE_)

- (NSString*)stringFromSampleType:(WFBTLEGlucoseSampleType_t)sampleType;
- (NSString*)stringFromSampleLocation:(WFBTLEGlucoseSampleLocation_t)sampleLocation;

@end



@implementation BTGlucoseDetailVC

@synthesize glucoseRecord;
@synthesize sequenceLabel;
@synthesize baseTimeLabel;
@synthesize timeOffsetLabel;
@synthesize concentrationLabel;
@synthesize sampleTypeLabel;
@synthesize sampleLocationLabel;
@synthesize statusLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [glucoseRecord release];
    [sequenceLabel release];
    [baseTimeLabel release];
    [timeOffsetLabel release];
    [concentrationLabel release];
    [sampleTypeLabel release];
    [sampleLocationLabel release];
    [statusLabel release];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // get the record data.
    WFBTLEGlucoseMeasurementData_t* pData = glucoseRecord.pstGlucoseMeasurement;
    
    sequenceLabel.text = [NSString stringWithFormat:@"%u", pData->usSequence];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    NSTimeInterval timeOffset = pData->baseTime;
    NSDate* timestamp = [NSDate dateWithTimeIntervalSinceReferenceDate:timeOffset];
    baseTimeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:timestamp]];
    [df release];
    timeOffsetLabel.text = [NSString stringWithFormat:@"%d sec", pData->ssTimeOffset];
    concentrationLabel.text = [NSString stringWithFormat:@"%1.2f mg/dL", pData->concentration];
    sampleTypeLabel.text = [NSString stringWithFormat:@"%@", [self stringFromSampleType:pData->sampleType]];
    sampleLocationLabel.text = [NSString stringWithFormat:@"%@", [self stringFromSampleLocation:pData->sampleLocation]];
    statusLabel.text = [NSString stringWithFormat:@"%u", pData->sensorStatus];
}

//--------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//--------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark BTGlucoseDetailVC Implementation

//--------------------------------------------------------------------------------
- (NSString*)stringFromSampleType:(WFBTLEGlucoseSampleType_t)sampleType
{
    NSString* retVal = @"n/a";
    
    switch (sampleType)
    {
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_UNDEFINED:
            retVal = @"UNDEFINED";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_CAPILLARY_WHOLE_BLOOD:
            retVal = @"Capillary Whole";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_CAPILLARY_PLASMA:
            retVal = @"Capillary Plasma";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_VENOUS_WHOLE_BLOOD:
            retVal = @"Venous Whole";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_VENOUS_PLASMA:
            retVal = @"Venous Plasma";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_ARTERIAL_WHOLE_BLOOD:
            retVal = @"Arterial Whole";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_ARTERIAL_PLASMA:
            retVal = @"Arterial Plasma";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_UNDETERMINED_WHOLE_BLOOD:
            retVal = @"Undetermined Whole";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_UNDETERMINED_PLASMA:
            retVal = @"Undetermined Plasma";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_INTERSTITIAL_FLUID:
            retVal = @"Interstitial Fluid";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_TYPE_CONTROL_SOLUTION:
            retVal = @"Control Solution";
            break;
    }
    
    return  retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)stringFromSampleLocation:(WFBTLEGlucoseSampleLocation_t)sampleLocation
{
    NSString* retVal = @"n/a";
    
    switch (sampleLocation)
    {
        case WF_BTLE_GLUCOSE_SAMPLE_LOC_UNDEFINED:
            retVal = @"UNDEFINED";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_LOC_FINGER:
            retVal = @"Finger";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_LOC_ALTERNATE_TEST_SITE:
            retVal = @"Alternate Site";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_LOC_EARLOBE:
            retVal = @"Earlobe";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_LOC_CONTROL_SOLUTION:
            retVal = @"Control Solution";
            break;
        case WF_BTLE_GLUCOSE_SAMPLE_LOC_NOT_AVAILABLE:
            retVal = @"Not Available";
            break;
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
