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
//  SettingsViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 11/11/11.
//

#import "SettingsViewController.h"
#import <WFConnector/WFConnector.h>
#import "NordicModalDelegate.h"
#import "NordicSemiAppDelegate.h"
#import "HelpViewController.h"
#import "NordicNavigationBar.h"
#import "ConfigAndHelpView.h"

@interface SettingsViewController()

- (void)hwConnectChanged;

@end



@implementation SettingsViewController

@synthesize dongleConnectedLabel;
@synthesize btConnectedLabel;
@synthesize appVersion;
@synthesize apiVersion;
@synthesize sampleRateText;
@synthesize staleDataTimeText;
@synthesize staleDataStringText;
@synthesize coastingTimeText;
@synthesize wheelCircText;
@synthesize metricSwitch;
@synthesize multitaskSwitch;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[dongleConnectedLabel release];
    [btConnectedLabel release];
    [appVersion release];
    [apiVersion release];
	[sampleRateText release];
    [staleDataTimeText release];
    [staleDataStringText release];
    [coastingTimeText release];
    [wheelCircText release];
    [metricSwitch release];
    [multitaskSwitch release]; 

    [super dealloc];
}

//--------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    // initialize the settings fields.
    WFConnectorSettings* settings = [WFHardwareConnector sharedConnector].settings;
    staleDataTimeText.text = [NSString stringWithFormat:@"%1.1f", settings.staleDataTimeout];
    staleDataStringText.text = settings.staleDataString;
    coastingTimeText.text = [NSString stringWithFormat:@"%1.1f", settings.bikeCoastingTimeout];
    wheelCircText.text = [NSString stringWithFormat:@"%1.0f", settings.bikeWheelCircumference * 1000];
    metricSwitch.on = settings.useMetricUnits;
    
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    multitaskSwitch.on = appDelegate.allowMultitask;
    
    apiVersion.text = [[WFHardwareConnector sharedConnector] apiVersion];
    NSBundle *mainBundle = [NSBundle mainBundle];
	appVersion.text = [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    [self hwConnectChanged];
    
    // subscribe for the HW Connector notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hwConnectChanged) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hwConnectChanged) name:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setValuesClicked:nil];
}

#pragma mark -
#pragma mark SettingsViewController Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)hwConnectChanged
{
    NSLog(@"hwConnectChanged");
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
	dongleConnectedLabel.text = hwConn.isFisicaConnected ? @"Yes" : @"No";
    btConnectedLabel.text = hwConn.isBTLEEnabled ? @"Yes" : @"No";
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)setValuesClicked:(id)sender
{
    // update the sample rate.
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
	NSTimeInterval sampleRate = [sampleRateText.text doubleValue] / 1000;
	hwConn.sampleRate = sampleRate;
    
    // update the connector settings.
    WFConnectorSettings* settings = hwConn.settings;
    settings.staleDataTimeout = [staleDataTimeText.text doubleValue];
    settings.staleDataString = staleDataStringText.text;
    settings.bikeCoastingTimeout = [coastingTimeText.text doubleValue];
    settings.bikeWheelCircumference = [wheelCircText.text floatValue] / 1000;
    settings.useMetricUnits = metricSwitch.on;
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.allowMultitask = multitaskSwitch.on;
}

//--------------------------------------------------------------------------------
- (IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

- (IBAction)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"settingshelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}
@end
