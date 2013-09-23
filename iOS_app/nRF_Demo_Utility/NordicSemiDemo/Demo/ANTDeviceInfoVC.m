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
//  ANTDeviceInfoVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/28/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "ANTDeviceInfoVC.h"
#import "NordicNavigationBar.h"
#import "HelpViewController.h"
#import "ConfigAndHelpView.h"


@interface ANTDeviceInfoVC (_PRIVATE_)

- (NSString*)stringFromBattStatus:(WFBatteryStatus_t)battStatus;
- (void)doHelp:(id)sender;

@end



@implementation ANTDeviceInfoVC

@synthesize commonData;
@synthesize sensorType;
@synthesize manufacturerIdLabel;
@synthesize modelNumberLabel;
@synthesize hardwareVerLabel;
@synthesize softwareVerLabel;
@synthesize serialUpperLabel;
@synthesize serialLowerLabel;
@synthesize serialNumberLabel;
@synthesize operatingTimeLabel;
@synthesize battVoltageLabel;
@synthesize battStatusLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [commonData release];
    
    [manufacturerIdLabel release];
    [modelNumberLabel release];
    [hardwareVerLabel release];
    [softwareVerLabel release];
    [serialUpperLabel release];
    [serialLowerLabel release];
    [serialNumberLabel release];
    [operatingTimeLabel release];
    [battVoltageLabel release];
    [battStatusLabel release];
    
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
    
    // update the display data.
    [self updateDisplay];
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
#pragma mark ANTDeviceInfoVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (NSString*)stringFromBattStatus:(WFBatteryStatus_t)battStatus
{
    NSString* retVal = @"n/a";
    switch ( battStatus )
    {
        case WF_BATTERY_STATUS_NOT_AVAILABLE:
            retVal = @"N/A";
            break;
        case WF_BATTERY_STATUS_NEW:
            retVal = @"New";
            break;
        case WF_BATTERY_STATUS_GOOD:
            retVal = @"Good";
            break;
        case WF_BATTERY_STATUS_OK:
            retVal = @"OK";
            break;
        case WF_BATTERY_STATUS_LOW:
            retVal = @"Low";
            break;
        case WF_BATTERY_STATUS_CRITICAL:
            retVal = @"Critical";
            break;
    }
    
    return retVal;
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"antsensorinfohelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)updateDisplay
{
    // update the display data.
    manufacturerIdLabel.text = [NSString stringWithFormat:@"%u", commonData.manufacturerId];
    modelNumberLabel.text = [NSString stringWithFormat:@"%u", commonData.modelNumber];
    hardwareVerLabel.text = [NSString stringWithFormat:@"%u", commonData.hardwareVersion];
    softwareVerLabel.text = [NSString stringWithFormat:@"%u", commonData.softwareVersion];
    serialUpperLabel.text = [NSString stringWithFormat:@"%u", commonData.serialNumberUpper];
    serialLowerLabel.text = [NSString stringWithFormat:@"%u", commonData.serialNumberLower];
    serialNumberLabel.text = [NSString stringWithFormat:@"%lu", commonData.serialNumber];
    operatingTimeLabel.text = [NSString stringWithFormat:@"%lu", commonData.operatingTime];
    battVoltageLabel.text = (commonData.batteryVoltage==WF_COMMON_BATTERY_INVALID) ? @"n/a" : [NSString stringWithFormat:@"%1.2f V", commonData.batteryVoltage];
    battStatusLabel.text = [self stringFromBattStatus:commonData.batteryStatus];
}

@end
