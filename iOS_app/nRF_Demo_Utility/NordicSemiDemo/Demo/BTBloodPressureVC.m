// Copyright (c) 2011 Nordic Semiconductor. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA.
// Terms and conditions of usage are described in detail in // NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
//
//  BTBloodPressureVC.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/17/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "BTBloodPressureVC.h"
#import "HelpViewController.h"


@implementation BTBloodPressureVC

@synthesize inProgressLabel;
@synthesize pressureLabel;
@synthesize systolicLabel;
@synthesize diastolicLabel;
@synthesize meanPressureLabel;
@synthesize heartRateLabel;
@synthesize userIdLabel;
@synthesize timestampLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [inProgressLabel release];
    [pressureLabel release];
	[systolicLabel release];
    [diastolicLabel release];
    [meanPressureLabel release];
    [heartRateLabel release];
    [userIdLabel release];
    [timestampLabel release];
	
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
    
    self.navigationItem.title = @"Blood Pressure";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
    inProgressLabel.hidden = TRUE;
    pressureLabel.text = @"Systolic:";
	signalEfficiencyLabel.text = @"n/a";
	deviceIdLabel.text = @"n/a";
	systolicLabel.text = @"n/a";
	diastolicLabel.text = @"n/a";
	meanPressureLabel.text = @"n/a";
	heartRateLabel.text = @"n/a";
	userIdLabel.text = @"n/a";
	timestampLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFBloodPressureData* bpData = [self.bloodPressureConnection getBloodPressureData];
	if ( bpData != nil )
	{
        // update the device id
        //use the deviceIDString property as this will return the ID for both ANT+
        //and BTLE devices
        NSString* deviceID = self.sensorConnection.deviceIDString;
        if (deviceID==nil) deviceID=@"n/a";
        else deviceID = [WFSensorCommonViewController formatUUID:deviceID];
		deviceIdLabel.text = [NSString stringWithFormat:@"%@", deviceID];
        
        // update the signal efficiency.
		float signal = [self.sensorConnection signalEfficiency];
        //
        // signal efficency is dBm for BTLE.
		signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f dBm", signal];
        
        userIdLabel.text = [NSString stringWithFormat:@"%u", bpData.userId];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        timestampLabel.text = [df stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:bpData.timestamp]];
        [df release];
        df = nil;
        if ( bpData.isMeasurementInProgress )
        {
            // configure the in-progress labels.
            inProgressLabel.hidden = FALSE;
            pressureLabel.text = @"Pressure:";
            
            // configure the pressure label values.
            systolicLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.cuffPressure];
            diastolicLabel.text = @"n/a";
            meanPressureLabel.text = @"n/a";
        } else {
            // configure the in-progress labels.
            inProgressLabel.hidden = TRUE;
            pressureLabel.text = @"Systolic:";
                
            systolicLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.systolic];
            diastolicLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.diastolic];
            meanPressureLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.meanArterialPressure];
            heartRateLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.heartRate];
        }
        
	}
	else 
	{
	//	[self resetDisplay];
	}
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"btlebpconfighelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}


#pragma mark -
#pragma mark BTBloodPressureVC Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBloodPressureConnection*)bloodPressureConnection
{
	WFBloodPressureConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFBloodPressureConnection class]] )
	{
		retVal = (WFBloodPressureConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
