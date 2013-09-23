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
//  SettingsViewController.m
//  WahooDemo
//
//  Created by Michael Moore on 11/11/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import "SettingsViewController.h"
#import <WFConnector/WFConnector.h>


@interface SettingsViewController()

- (void)hwConnectChanged;

@end



@implementation SettingsViewController

@synthesize dongleConnectedLabel;
@synthesize btConnectedLabel;
@synthesize sampleRateText;
@synthesize staleDataTimeText;
@synthesize staleDataStringText;
@synthesize coastingTimeText;
@synthesize wheelCircText;
@synthesize searchTimeout;
@synthesize discoveryTimeout;
@synthesize metricSwitch;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[dongleConnectedLabel release];
    [btConnectedLabel release];
	[sampleRateText release];
    [staleDataTimeText release];
    [staleDataStringText release];
    [coastingTimeText release];
    [wheelCircText release];
    [searchTimeout release];
    [discoveryTimeout release];
    [metricSwitch release];
	

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

    self.navigationItem.title = @"Status and Settings";

    // initialize the settings fields.
    WFConnectorSettings* settings = [WFHardwareConnector sharedConnector].settings;
    searchTimeout.text = [NSString stringWithFormat:@"%1.1f", settings.searchTimeout];
    discoveryTimeout.text = [NSString stringWithFormat:@"%1.1f", settings.discoveryTimeout];
    staleDataTimeText.text = [NSString stringWithFormat:@"%1.1f", settings.staleDataTimeout];
    staleDataStringText.text = settings.staleDataString;
    coastingTimeText.text = [NSString stringWithFormat:@"%1.1f", settings.bikeCoastingTimeout];
    wheelCircText.text = [NSString stringWithFormat:@"%1.0f", settings.bikeWheelCircumference * 100];
    metricSwitch.on = settings.useMetricUnits;
    
    [self hwConnectChanged];
    
    // subscribe for the HW Connector notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hwConnectChanged) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hwConnectChanged) name:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Implementation

//--------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Dismisses the email composition interface when users tap Cancel or Send.
	// Proceeds to update the message field with the result of the operation.
	[self dismissModalViewControllerAnimated:YES];
    
    // delete log files.
    if ( result == MFMailComposeResultSent )
    {
        BOOL bLogExists = TRUE;
        int logIndex = 0;
        while ( bLogExists )
        {
            NSString* logName = [NSString stringWithFormat:@"log_data_%u.csv", logIndex++];
            NSString* logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:logName];
            if ( (bLogExists = [[NSFileManager defaultManager] fileExistsAtPath:logPath]) )
            {
                [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
            }
        }
    }
}


#pragma mark -
#pragma mark SettingsViewController Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)hwConnectChanged
{
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
	dongleConnectedLabel.text = hwConn.isFisicaConnected ? @"Yes" : @"No";
    btConnectedLabel.text = hwConn.isBTLEEnabled ? @"Yes" : @"No";
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)emailLogClicked:(id)sender
{
    // create an email composer.
    MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    // attach the log to the email.
	NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"console.log"];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        NSData* fileData = [NSData dataWithContentsOfFile:path];
        [mailer addAttachmentData:fileData mimeType:@"application/octet-stream" fileName:@"console.log"];
    }
    
    // attache debug data logs.
    int logIndex = 0;
    BOOL bLogExists = TRUE;
    while ( bLogExists )
    {
        NSString* logName = [NSString stringWithFormat:@"log_data_%u.csv", logIndex++];
        NSString* logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:logName];
        if ( (bLogExists = [[NSFileManager defaultManager] fileExistsAtPath:logPath]) )
        {
            NSData* fileData = [NSData dataWithContentsOfFile:logPath];
            [mailer addAttachmentData:fileData mimeType:@"application/octet-stream" fileName:logName];
        }
    }

    // send the show the email composer.
    [mailer setSubject:@"Diagnostic Log"];
    [self presentModalViewController:mailer animated:YES];
    [mailer release];
}

//--------------------------------------------------------------------------------
- (IBAction)setValuesClicked:(id)sender
{
    // update the sample rate.
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
	NSTimeInterval sampleRate = [sampleRateText.text doubleValue] / 1000;
	hwConn.sampleRate = sampleRate;
    
    // update the connector settings.
    WFConnectorSettings* settings = hwConn.settings;
    settings.searchTimeout = [searchTimeout.text doubleValue];
    settings.discoveryTimeout = [discoveryTimeout.text doubleValue];
    settings.staleDataTimeout = [staleDataTimeText.text doubleValue];
    settings.staleDataString = staleDataStringText.text;
    settings.bikeCoastingTimeout = [coastingTimeText.text doubleValue];
    settings.bikeWheelCircumference = [wheelCircText.text floatValue] / 100;
    settings.useMetricUnits = metricSwitch.on;
}

//--------------------------------------------------------------------------------
- (IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

@end
