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
//  GlucoseVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "GlucoseVC.h"
#import "HistoryManager.h"
#import "HelpViewController.h"
#import "NordicSemiAppDelegate.h"


@interface GlucoseVC (_PRIVATE_)

@end


@implementation GlucoseVC

@synthesize concentrationLabel;
@synthesize changeRateLabel;
@synthesize timestampLabel;
@synthesize alertHighLabel;
@synthesize alertLowLabel;
@synthesize alertRisingLabel;
@synthesize alertFallingLabel;
@synthesize alertBelow55Label;

@synthesize deviceTimeLabel;
@synthesize elapsedTimeLabel;



#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [concentrationLabel release];
    [changeRateLabel release];
    [timestampLabel release];
    [alertHighLabel release];
    [alertLowLabel release];
    [alertRisingLabel release];
    [alertFallingLabel release];
    [alertBelow55Label release];
    
    [deviceTimeLabel release];
    [elapsedTimeLabel release];
	
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark WFGlucoseDelegate Implementation

//--------------------------------------------------------------------------------
- (void)glucoseConnection:(WFGlucoseConnection*)glucoseConn didReceiveRecord:(WFGlucoseData*)record
{
    NSLog(@"GLUCOSE RECORD RECEIVED");
    
    if ( record.usConcentration <= WF_GLUCOSE_VALUES_EQUILIBRIUM_100 )
    {
        switch (record.usConcentration)
        {
            case WF_GLUCOSE_VALUES_UNINITIALIZED:
                concentrationLabel.text = @"U/I";
                break;
            case WF_GLUCOSE_VALUES_UNAVAILABLE:
                concentrationLabel.text = @"U/A";
                break;
            case WF_GLUCOSE_VALUES_FILE_DATA_ONLY:
                concentrationLabel.text = @"FILE";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_25:
                concentrationLabel.text = @"EQ < 25";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_50:
                concentrationLabel.text = @"EQ < 50";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_75:
                concentrationLabel.text = @"EQ < 75";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_100:
                concentrationLabel.text = @"EQ < 100";
                break;
        }
    }
    else {
        concentrationLabel.text = [NSString stringWithFormat:@"%u", record.usConcentration];
    }
    
    changeRateLabel.text = [NSString stringWithFormat:@"%u", record.rateOfChange];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    timestampLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:record.timestamp]];
    deviceTimeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:record.currentDeviceTime]];
    [df release];
    
    elapsedTimeLabel.text = [NSString stringWithFormat:@"%lu", record.ulElapsedTime];
    
    alertHighLabel.text = record.status.bHighAlert ? @"YES" : @"NO";
    alertLowLabel.text = record.status.bLowAlert ? @"YES" : @"NO";
    alertRisingLabel.text = record.status.bRisingAlert ? @"YES" : @"NO";
    alertFallingLabel.text = record.status.bFallingAlert ? @"YES" : @"NO";
    alertBelow55Label.text = record.status.bBelow55 ? @"YES" : @"NO";
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
	concentrationLabel.text = @"n/a";
	changeRateLabel.text = @"n/a";
	timestampLabel.text = @"n/a";
	alertHighLabel.text = @"n/a";
	alertLowLabel.text = @"n/a";
	alertRisingLabel.text = @"n/a";
	alertFallingLabel.text = @"n/a";
	alertBelow55Label.text = @"n/a";
    
	deviceTimeLabel.text = @"n/a";
	elapsedTimeLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
}

- (void)doHelp:(id)sender
{
}

#pragma mark -
#pragma mark GlucoseVC Implementation

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
