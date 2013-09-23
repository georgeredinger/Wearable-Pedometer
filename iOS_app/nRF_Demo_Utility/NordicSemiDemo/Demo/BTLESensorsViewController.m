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
//  AntSensorsViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/7/11.
//

#import "BTLESensorsViewController.h"
#import "NordicNavigationBar.h"
#import "HeartrateSimpleViewController.h"
#import "TempSimpleViewController.h"
#import "ProximitySimpleViewController.h"
#import "NordicSemiAppDelegate.h"
#import "NordicSemiAppDelegate.h"
#import "ConfigAndHelpView.h"
#import "SettingsViewController.h"
#import "HelpViewController.h"
#import <WFConnector/WFConnector.h>
#import "TemperatureViewController.h"
#import "BikingViewController.h"
#import "BTBloodPressureViewController.h"
#import "BGMViewController.h"
#import "WeightScaleViewController.h"

@implementation BTLESensorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
 //   [[WFHardwareConnector sharedConnector] enableBTLE:YES inBondingMode:NO];
    // Set the title view to the Instagram logo
    UIImage* titleImage = [UIImage imageNamed:@"NORDIC-LOGO.png"];
    UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [titleView addSubview:titleImageView];
    titleImageView.center = titleView.center;
    CGRect titleImageViewFrame = titleImageView.frame;
    // Offset the logo up a bit
   // titleImageViewFrame.origin.y = titleImageViewFrame.origin.y + 3.0;
    titleImageView.frame = titleImageViewFrame;
    self.navigationItem.titleView = titleView;
    [titleImageView release];
    [titleView release];
    
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"NordicNavbar.png"]];
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
    ConfigAndHelpView *btns = [nib objectAtIndex:0];
    [btns.configButton addTarget:self action:@selector(doConfig:) forControlEvents:UIControlEventTouchUpInside];
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
}


- (void)doConfig:(id)sender
{
    SettingsViewController* vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"btlehelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)back:(id)sender
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate animateRootBg:NO];
}


#pragma mark - IBActions

- (IBAction)hrmClicked:(id)sender 
{
    HeartrateSimpleViewController* vc = [[HeartrateSimpleViewController alloc] initWithNibName:@"HeartrateSimpleViewController" bundle:nil forNetwork:WF_NETWORKTYPE_BTLE];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)tempClicked:(id)sender
{
    TempSimpleViewController* vc = [[TempSimpleViewController alloc] initWithNibName:@"TempSimpleViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)proximityClicked:(id)sender
{
    ProximitySimpleViewController* vc = [[ProximitySimpleViewController alloc] initWithNibName:@"ProximitySimpleViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)bikingClicked:(id)sender
{
    BikingViewController* vc = [[BikingViewController alloc] initWithNibName:@"BikingViewController" bundle:nil forNetwork:WF_NETWORKTYPE_BTLE];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)bpClicked:(id)sender
{
    BTBloodPressureViewController* vc = [[BTBloodPressureViewController alloc] initWithNibName:@"BTBloodPressureViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)bgmClicked:(id)sender
{
    BGMViewController* vc = [[BGMViewController alloc] initWithNibName:@"BGMViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)weightClicked:(id)sender {
    WeightScaleViewController* vc = [[WeightScaleViewController alloc] initWithNibName:@"WeightScaleViewController" bundle:nil forNetwork:WF_NETWORKTYPE_BTLE];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
    
}
@end
