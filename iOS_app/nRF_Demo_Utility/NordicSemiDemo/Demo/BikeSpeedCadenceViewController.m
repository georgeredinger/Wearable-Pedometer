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
//  BikeSpeedCadenceViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/21/10.
//

#import "BikeSpeedCadenceViewController.h"
#import "OdometerHistoryVC.h"


@implementation BikeSpeedCadenceViewController

@synthesize lastCadenceTimeLabel;
@synthesize totalCadenceRevolutionsLabel;
@synthesize lastSpeedTimeLabel;
@synthesize totalSpeedRevolutionsLabel;
@synthesize computedCadenceLabel;
@synthesize computedSpeedLabel;
@synthesize distanceLabel;
@synthesize temperatureLabel;
@synthesize odoBtn;
@synthesize ambTemp;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[lastCadenceTimeLabel release];
	[totalCadenceRevolutionsLabel release];
	[lastSpeedTimeLabel release];
	[totalSpeedRevolutionsLabel release];
	[computedCadenceLabel release];
	[computedSpeedLabel release];
    [distanceLabel release];
    [temperatureLabel release];
    [odoBtn release];
    [ambTemp release];
    
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
    
    self.navigationItem.title = @"Bike Speed & Cadence";
    if (applicableNetworks == WF_NETWORKTYPE_BTLE) {
        odoBtn.hidden = NO;
        temperatureLabel.hidden = NO;
        ambTemp.hidden = NO;
    }
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
	deviceIdLabel.text = @"n/a";
	lastCadenceTimeLabel.text = @"n/a";
	totalCadenceRevolutionsLabel.text = @"n/a";
	lastSpeedTimeLabel.text = @"n/a";
	totalSpeedRevolutionsLabel.text = @"n/a";
	computedCadenceLabel.text = @"n/a";
	computedSpeedLabel.text = @"n/a";
    distanceLabel.text = @"n/a";
	signalEfficiencyLabel.text = @"n/a";
    temperatureLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFBikeSpeedCadenceData* bscData = [self.bikeSpeedCadenceConnection getBikeSpeedCadenceData];
	if ( bscData != nil )
	{
        // update the signal efficiency.
		int deviceId = self.sensorConnection.deviceNumber;
		float signal = [self.sensorConnection signalEfficiency];
		deviceIdLabel.text = [NSString stringWithFormat:@"%d", deviceId];
		if (signal == -1) signalEfficiencyLabel.text = @"n/a";
		else signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f%%", (signal*100)];
		
        // update basic data.
		lastCadenceTimeLabel.text = [NSString stringWithFormat:@"%3.3f", bscData.accumCadenceTime];
		totalCadenceRevolutionsLabel.text = [NSString stringWithFormat:@"%ld", bscData.accumCrankRevolutions];
		lastSpeedTimeLabel.text = [NSString stringWithFormat:@"%3.3f", bscData.accumSpeedTime];
		totalSpeedRevolutionsLabel.text = [NSString stringWithFormat:@"%ld", bscData.accumWheelRevolutions];
		
		computedSpeedLabel.text = [bscData formattedSpeed:TRUE];
        computedCadenceLabel.text = [bscData formattedCadence:TRUE];
        distanceLabel.text = [bscData formattedDistance:TRUE];
        
        // get BTLE specific data.
        if ( [bscData isKindOfClass:[WFBTLEBikeSpeedCadenceData class]] )
        {
            WFBTLEBikeSpeedCadenceData* btleData = (WFBTLEBikeSpeedCadenceData*)bscData;
            
            // check for Wahoo CBSC device extended data.
            if ( btleData.wahooData )
            {
                // the Wahoo device reports ambient temperature.
                float temp = btleData.wahooData.temperature;
                NSString* units = @"° C";
                if ( !hardwareConnector.settings.useMetricUnits )
                {
                    const float convFactor = (9.0/5.0);
                    temp = (convFactor * temp) + 32;
                    units = @"° F";
                }
                temperatureLabel.text = [NSString stringWithFormat:@"%1.2f%@", temp, units];
            }
        }
        NSLog(@"BSC DISTANCE:  %@", [bscData formattedDistance:TRUE]);
        /*
         * this demonstrates computing speed manually, using unformatted values.
         
        // calculate the speed.
        //
		// API provides wheel cadence in RPM's, need to multiply by circumference(6.79ft) or metric and 60 minutes
		// Be sure and add Wheel Size variable somewhere in App
		
		computedSpeedLabel.text = [NSString stringWithFormat:@"%0.0f", (float) bscData.instantWheelRPM * 0.0771743];
		computedCadenceLabel.text = [NSString stringWithFormat:@"%d", bscData.instantCrankRPM];
        */
	}
	else
	{
		[self resetDisplay];
	}
}

#pragma mark -
#pragma mark WFBikeSpeedCadenceDelegate Implementation

//--------------------------------------------------------------------------------
- (void)cscConnection:(WFBikeSpeedCadenceConnection*)cscConn didReceiveOdometerHistory:(WFOdometerHistory*)history
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"BlueSC" message:@"Received Odometer History" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
}

//--------------------------------------------------------------------------------
- (void)cscConnection:(WFBikeSpeedCadenceConnection*)cscConn didResetOdometer:(BOOL)bSuccess
{
    NSString* msg = [NSString stringWithFormat:@"Received Odometer Reset response.\n\nStatus: %@", bSuccess?@"SUCCESS":@"FAILED"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"BTLE CSC" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
}

#pragma mark -
#pragma mark BikeSpeedCadenceViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFBikeSpeedCadenceConnection*)bikeSpeedCadenceConnection
{
	WFBikeSpeedCadenceConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFBikeSpeedCadenceConnection class]] )
	{
		retVal = (WFBikeSpeedCadenceConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)odometerClicked:(id)sender
{
    BOOL bAlert = FALSE;
    NSString* msg = nil;
    
    // only available for BTLE S/C sensor.
    WFBTLEBikeSpeedCadenceData* cscData = [self.bikeSpeedCadenceConnection getCSCData];
    if ( cscData )
    {
        // check for Wahoo BlueSC device.
        if ( cscData.wahooData )
        {
            // check for odometer history.
            if ( cscData.wahooData.odometerHistory )
            {
                // configure and display the sensor manager view.
                OdometerHistoryVC* vc = [[OdometerHistoryVC alloc] initWithNibName:@"OdometerHistoryVC" bundle:nil];
                vc.odometerHistory = cscData.wahooData.odometerHistory;
                vc.bscConnection = self.bikeSpeedCadenceConnection;
                if (self.parentNavController) { // if the config view is in the ConfigScrollerController
                    [self.parentNavController pushViewController:vc animated:TRUE];
                } else {
                    [self.navigationController pushViewController:vc animated:TRUE];
                }
                [vc release];
            }
            // history not available yet.
            else
            {
                msg = @"The odometer history has not been received yet.";
                bAlert = TRUE;
            }
        }
        // not a Wahoo BlueSC device.
        else
        {
            msg = @"Odometer history is only available from the Wahoo BlueSC.";
            bAlert = TRUE;
        }
    }
    else
    {
        msg = @"Odometer history is not available from ANT+ devices.";
        bAlert = TRUE;
    }
    
    // show the error message.
    if ( bAlert  )
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Odometer History" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        alert = nil;
    }
    
}

@end
