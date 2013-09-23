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

#import "AntSensorsViewController.h"
#import "NordicNavigationBar.h"
#import "HeartrateSimpleViewController.h"
#import "RunningViewController.h"
#import "BikingViewController.h"
#import "NordicSemiAppDelegate.h"
#import "ConfigAndHelpView.h"
#import "SettingsViewController.h"
#import "HelpViewController.h"
#import "FitDeviceViewController.h"
#import "BloodPressureViewController.h"
#import "WeightScaleViewController.h"
#import "CGMViewController.h"
#import <WFConnector/WFConnector.h>

@interface AntSensorsViewController (_PRIVATE_)
@end

@implementation AntSensorsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    
    [super dealloc];
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
    
  //  [[WFHardwareConnector sharedConnector] enableBTLE:NO inBondingMode:NO];
    // Set the title view to the logo
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
    
    [btns.configButton addTarget:self action:@selector(doConfig:) forControlEvents:UIControlEventTouchUpInside];
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
    
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease] animated:YES];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
    BOOL fisicaConnected = hwConn.isFisicaConnected;
    if (!fisicaConnected && !alertedNoConnector) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ANT+ Accessory Not Present:" message:@"Connect the hardware accessory and try again."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];    
    } 
}

- (void)doConfig:(id)sender
{
    alertedNoConnector = YES;
    SettingsViewController* vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (void)doHelp:(id)sender
{
    alertedNoConnector = YES;
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"anthelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

- (void)back:(id)sender
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate animateRootBg:NO];
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

#pragma mark - IBActions

- (IBAction)hrmClicked:(id)sender 
{
    alertedNoConnector = YES;
    HeartrateSimpleViewController* vc = [[HeartrateSimpleViewController alloc] initWithNibName:@"HeartrateSimpleViewController" bundle:nil forNetwork:WF_NETWORKTYPE_ANTPLUS];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)runningClicked:(id)sender
{
    alertedNoConnector = YES;
    RunningViewController* vc = [[RunningViewController alloc] initWithNibName:@"RunningViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)bikingClicked:(id)sender
{
    alertedNoConnector = YES;
    BikingViewController* vc = [[BikingViewController alloc] initWithNibName:@"BikingViewController" bundle:nil forNetwork:WF_NETWORKTYPE_ANTPLUS];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)weightClicked:(id)sender
{
    alertedNoConnector = YES;
    WeightScaleViewController* vc = [[WeightScaleViewController alloc] initWithNibName:@"WeightScaleViewController" bundle:nil forNetwork:WF_NETWORKTYPE_ANTPLUS];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)bpClicked:(id)sender
{
    alertedNoConnector = YES;
    BloodPressureViewController* vc = [[BloodPressureViewController alloc] initWithNibName:@"BloodPressureViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}
- (IBAction)cgmClicked:(id)sender
{
    alertedNoConnector = YES;
    CGMViewController* vc = [[CGMViewController alloc] initWithNibName:@"CGMViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (IBAction)fsClicked:(id)sender
{
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
    [hwConn resetConnections];
    
    alertedNoConnector = YES;
    // load the FIT import view.
    FitDeviceViewController* fitView = [[FitDeviceViewController alloc] initWithNibName:@"FitDeviceViewController" bundle:nil];
    [self.navigationController pushViewController:fitView animated:TRUE];
    [fitView release];
    fitView = nil; 
}

@end
