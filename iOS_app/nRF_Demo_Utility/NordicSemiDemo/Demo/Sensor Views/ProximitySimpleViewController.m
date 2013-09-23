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
//  HeartrateSimpleViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import "ProximitySimpleViewController.h"
#import "ProximityViewController.h"
#import "NordicSemiAppDelegate.h"
#import "HelpViewController.h"

@implementation ProximitySimpleViewController

@synthesize batteryLabel, padlock;

//--------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_PROXIMITY], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
       
    }
    return self;
}

//--------------------------------------------------------------------------------
-(void) dealloc 
{
    [batteryLabel release];
    [padlock release];
    [_alertThresholdSlider release];
    [_extremeSecuritySwitch release];
    [_findMyTagButton release];
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [self setAlertThresholdSlider:nil];
    [self setExtremeSecuritySwitch:nil];
    [self setFindMyTagButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // set the proximity delegate to this instance.
    self.proximityConnection.proximityDelegate = self;
    
    NordicSemiAppDelegate *appDelegate = (NordicSemiAppDelegate*) [[UIApplication sharedApplication] delegate];
    [self.alertThresholdSlider setValue:appDelegate.proximityAlertThreshold];
    
    // determine whether the device is within the proximity threshold.
    if ( [self.proximityConnection isInRange] )
    {
        NSLog(@"viewWillAppear in range");
        [padlock setImage:[UIImage imageNamed:@"PADLOCK-OPEN.png"]];
    }
    else
    {
        [padlock setImage:[UIImage imageNamed:@"PADLOCK.png"]];
    }
}

//--------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark NSSensorSimpleBaseVC Implementation

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    batteryLabel.text = @"n/a";
    [padlock setImage:[UIImage imageNamed:@"PADLOCK.png"]];
    [self.findMyTagButton setImage:[UIImage imageNamed:@"FIND-MY-TAG@2x.png"] forState:UIControlStateNormal];
    [self.findMyTagButton setImage:[UIImage imageNamed:@"FIND-MY-TAG-down@2x.png"] forState:UIControlStateHighlighted];
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    
    // set the proximity alert parameters.
    WFProximityConnection* proxConn = self.proximityConnection;
    if ( proxConn )
    {
        // set proximity monitoring to monitor link loss - device moving farther away.
        proxConn.proximityDelegate = self;
        [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_FARTHER];
        NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
        [proxConn setProximityAlertThreshold:appDelegate.proximityAlertThreshold alertLevel:appDelegate.proximityAlertLevel];
        
        [padlock setImage:[UIImage imageNamed:@"PADLOCK-OPEN.png"]];
    }
}

//--------------------------------------------------------------------------------
- (void)updateData
{
	WFProximityData* proxData = [self.proximityConnection getProximityData];
	if ( proxData != nil  )
	{
		float signal = [self.proximityConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        
        if ([self.extremeSecuritySwitch isOn])
        {
            if([self.proximityConnection isInRange]) {
                NSLog(@"update data In-range");
                [padlock setImage:[UIImage imageNamed:@"PADLOCK-OPEN.png"]];
            } else {
                NSLog(@"update data outofRange");
                [padlock setImage:[UIImage imageNamed:@"PADLOCK.png"]];
            }
        }
        else if ([self.proximityConnection isConnected])
        {
            [padlock setImage:[UIImage imageNamed:@"PADLOCK-OPEN.png"]];
        }
        else
        {
            [padlock setImage:[UIImage imageNamed:@"PADLOCK.png"]];
        }

        NSLog(@"invalid is %d, Battlevel is %d",WF_BTLE_BATT_LEVEL_INVALID, proxData.btleCommonData.batteryLevel);
        batteryLabel.text = (proxData.btleCommonData.batteryLevel==WF_BTLE_BATT_LEVEL_INVALID) ? @"n/a" : [NSString stringWithFormat:@"%u %%", proxData.btleCommonData.batteryLevel];
       [[self view] setNeedsDisplay];
	}
	else 
	{
		[self resetDisplay];
	}
}


#pragma mark -
#pragma mark ProximitySimpleViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFProximityConnection*)proximityConnection
{
	return (WFProximityConnection*) [sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_PROXIMITY]];
}

//--------------------------------------------------------------------------------
- (void)doConfig:(id)sender
{
    ProximityViewController* vc = [[ProximityViewController alloc] initWithNibName:@"ProximityViewController" bundle:nil forSensor:WF_SENSORTYPE_PROXIMITY];
    vc.applicableNetworks = WF_NETWORKTYPE_BTLE;
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];

}

//--------------------------------------------------------------------------------
- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"btlesensorhelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

//--------------------------------------------------------------------------------
- (IBAction)extremeSecuritySwitchChanged:(id)sender {
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.proximityConnection setProximityAlertThreshold:appDelegate.proximityAlertThreshold alertLevel:appDelegate.proximityAlertLevel];
    [self.alertThresholdSlider setEnabled:[self.extremeSecuritySwitch isOn]];

}

- (IBAction)alertThresholdChanged:(id)sender {
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];

    appDelegate.proximityAlertThreshold = (int)ceil(self.alertThresholdSlider.value);
}

- (IBAction)findTag:(id)sender
{
    static bool hasSentAlarm = NO;
    if (hasSentAlarm)
    {
        hasSentAlarm = NO;
        [self.proximityConnection sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_NONE];
        [self.findMyTagButton setImage:[UIImage imageNamed:@"FIND-MY-TAG@2x.png"] forState:UIControlStateNormal];
        [self.findMyTagButton setImage:[UIImage imageNamed:@"FIND-MY-TAG-down@2x.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        hasSentAlarm = YES;
        [self.proximityConnection sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_HIGH];
        [self.findMyTagButton setImage:[UIImage imageNamed:@"SILENCE-TAG@2x.png"] forState:UIControlStateNormal];
        [self.findMyTagButton setImage:[UIImage imageNamed:@"SILENCE-TAG-down@2x.png"] forState:UIControlStateHighlighted];
    }
}


#pragma mark -
#pragma mark WFProximityDelegate Implementation

//--------------------------------------------------------------------------------
- (void)proximityConnection:(WFProximityConnection*)proxConn proximityAlert:(WFBTLEChAlertLevel_t)alertLevel proximityMode:(WFProximityAlertMode_t)mode signalLoss:(int)signalLoss
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    // action based on current proximity monitoring mode.
    switch ( mode )
    {
        case WF_PROXIMITY_ALERT_MODE_FARTHER:
            if ([self.extremeSecuritySwitch isOn])
            {
                // the device has moved out of range.
                [padlock setImage:[UIImage imageNamed:@"PADLOCK.png"]];
                
                // send immediate alert - makes device beep.
                [proxConn sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_MILD];
                
                UILocalNotification *alarm = [[UILocalNotification alloc] init];
                alarm.alertBody = @"Tag has moved out of range.";
                alarm.alertAction = @"OK";
                alarm.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
            }
            // begin monitoring for device back in range.
            [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_CLOSER];
            [proxConn setProximityAlertThreshold:appDelegate.proximityAlertThreshold-1 alertLevel:appDelegate.proximityAlertLevel];
            break;
            
        case WF_PROXIMITY_ALERT_MODE_CLOSER:
            if ([self.extremeSecuritySwitch isOn])
            {
                // the device has moved in range.
                NSLog(@"alert mode closer in range");
                [padlock setImage:[UIImage imageNamed:@"PADLOCK-OPEN.png"]];
                
                // send immediate alert - makes device aware that is inside range.
                [proxConn sendImmediateAlert:WF_BTLE_CH_ALERT_LEVEL_NONE];
            }
            // begin monitoring for device out of range.
            [proxConn setProximityMode:WF_PROXIMITY_ALERT_MODE_FARTHER];
            [proxConn setProximityAlertThreshold:appDelegate.proximityAlertThreshold alertLevel:appDelegate.proximityAlertLevel];
            break;
            
    }
}

@end
