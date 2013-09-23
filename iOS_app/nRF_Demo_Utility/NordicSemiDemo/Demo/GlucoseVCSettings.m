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
//  GlucoseVCSettings.m
//  WahooDemo
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "GlucoseVCSettings.h"
#import "HistoryManager.h"
#import "HelpViewController.h"
#import "NordicSemiAppDelegate.h"


@interface GlucoseVCSettings (_PRIVATE_)

@end


@implementation GlucoseVCSettings

@synthesize permissionKeyField;
@synthesize txIdField;
@synthesize highField;
@synthesize lowField;

@synthesize highAlert, lowAlert, riseAlert, fallAlert;
@synthesize riseRateAlertLevel, fallRateAlertLevel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [permissionKeyField release];
    [txIdField release];
    [highField release];
    [lowField release];
    
    [highAlert release];
    [lowAlert release];
    [fallAlert release];
    [riseAlert release];
    [riseRateAlertLevel release];
    [riseRateAlertLevel release];
	
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
    // set the glucose delegate parameters.
    NSLog(@"CGM Settings viewDidLoad");
    CGRect switchfr = riseRateAlertLevel.frame;
    CGRect frame = CGRectMake(switchfr.origin.x, switchfr.origin.y, 80, 27);
    [riseRateAlertLevel setFrame:frame];
    switchfr = fallRateAlertLevel.frame;
    frame = CGRectMake(switchfr.origin.x, switchfr.origin.y, 80, 27);
    [fallRateAlertLevel setFrame:frame];
    [self configSettings];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSString * low = lowField.text;
    NSNumber *lowNum = [f numberFromString:low];
    NSString * high = highField.text;
    NSNumber *highNum = [f numberFromString:high];
    int riseAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN;
    int fallAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN;
    if (riseRateAlertLevel.selectedSegmentIndex == 1) riseAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN;
    if (fallRateAlertLevel.selectedSegmentIndex == 1) fallAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              txIdField.text, @"txId",
                              permissionKeyField.text, @"permissionKey",
                              lowNum, @"low",
                              highNum, @"high",
                              [NSNumber numberWithBool:highAlert.on], @"highAlert",
                              [NSNumber numberWithBool:lowAlert.on], @"lowAlert",
                              [NSNumber numberWithBool:riseAlert.on], @"riseAlert",
                              [NSNumber numberWithBool:fallAlert.on], @"fallAlert",
                              [NSNumber numberWithInt:riseAlertLevel], @"riseAlertLevel",
                              [NSNumber numberWithInt:fallAlertLevel], @"fallAlertLevel",
                              nil];
     HistoryManager * hm = [[HistoryManager alloc] init];
    [hm saveCGMInfo:infoDict];
    [hm release];
    [f release];
    
    
    // the app shall not be allowed to chagne settings on the sensor. 
    /* 
    WFGlucoseRateAlertLevel_t eRAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_DISABLED;
    WFGlucoseRateAlertLevel_t eFAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_DISABLED;
    if (riseAlert.on) {
        if (riseAlertLevel == 2) eRAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN;
        else if (riseAlertLevel == 3) eRAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN;
    }
    if (fallAlert.on) {
        if (fallAlertLevel == 2) eFAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN;
        else if (fallAlertLevel == 3) eFAlertLevel = WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN;
    }
    [self.glucoseConnection setAlertLevelsRising:eRAlertLevel
                              falling:eFAlertLevel
                          highGlucose:[highNum intValue]
                           lowGlucose:[lowNum intValue]]; */
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
}

//--------------------------------------------------------------------------------
- (void)updateData
{
}

- (void)doHelp:(id)sender
{
}

#pragma mark -
#pragma mark GlucoseVCSettings Implementation

-(void)configSettings
{
    if (lowField == nil) return;
    HistoryManager * hm = [[HistoryManager alloc] init];
    NSDictionary *info = [hm getCGMInfo];
    [hm release];
    NSLog(@"info: %@", info.description);
    txIdField.text = [info objectForKey:@"txId"];
    permissionKeyField.text = [info objectForKey:@"permissionKey"];
    lowField.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"low"]];
    highField.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"high"]];
    highField.keyboardType = lowField.keyboardType = UIKeyboardTypeNumberPad;
    riseAlert.on = [[info objectForKey:@"riseAlert"] boolValue];
    fallAlert.on = [[info objectForKey:@"fallAlert"] boolValue];
    highAlert.on = [[info objectForKey:@"highAlert"] boolValue];
    lowAlert.on = [[info objectForKey:@"lowAlert"] boolValue];
    NSNumber * riseAlertLevel = [info objectForKey:@"riseAlertLevel"];

    if ([riseAlertLevel intValue] == WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN) {
        riseRateAlertLevel.selectedSegmentIndex = 0;
    }
    else {
        riseRateAlertLevel.selectedSegmentIndex = 1;
    }
    NSNumber * fallAlertLevel = [info objectForKey:@"fallAlertLevel"];
    
    if ([fallAlertLevel intValue] == WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN) {
        fallRateAlertLevel.selectedSegmentIndex = 0;
    }
    else {
        fallRateAlertLevel.selectedSegmentIndex = 1;
    }
}

#pragma mark Private Methods

//--------------------------------------------------------------------------------


#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFGlucoseConnection*)glucoseConnection
{
	WFGlucoseConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFGlucoseConnection class]] )
	{
		retVal = (WFGlucoseConnection*)self.sensorConnection;
	}
	
	return retVal;
}

@end
