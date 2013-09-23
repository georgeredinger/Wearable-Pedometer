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
//  BikePowerCalibration.m
//  FisicaDemo
//
//  Created by Michael Moore on 3/30/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "BikePowerCalibration.h"


/////////////////////////////////////////////////////////////////////////////
// Bike Power Calibration Definitions.
/////////////////////////////////////////////////////////////////////////////

#define BPS_CALIBRATION_RESERVE_BYTE    0xFF
#define BPS_CALIBRATION_TYPE_MANUAL     0xAA
#define BPS_CALIBRATION_TYPE_AUTO_ZERO  0xAB
#define BPS_CALIBRATION_TYPE_CTF        0x10

#define BPS_CALIBRATION_CTF_SLOPE_ID    0x02
#define BPS_CALIBRATION_CTF_SERIAL_ID   0x03
#define BPS_CALIBRATION_SLOPE		    ((uint16_t) 200)    // Default Bike wheel circumference (m)
#define BPS_CALIBRATION_SERIAL          ((uint16_t) 67890)  // Set Max # of no updates


/////////////////////////////////////////////////////////////////////////////
// BikePowerViewController Implementation.
/////////////////////////////////////////////////////////////////////////////

@implementation BikePowerCalibration

@synthesize bikePowerConnection;
@synthesize calibrationValueLabel;
@synthesize temperatureLabel;
@synthesize promptLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[bikePowerConnection release];
	[calibrationValueLabel release];
	[promptLabel release];
    
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
    
    self.navigationItem.title = @"Power Calibration";

    // configure the HW connector.
    hardwareConnector = [WFHardwareConnector sharedConnector];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calibrationResponse:) name:@"WFBikePowerCalibration" object:nil];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"WFBikePowerCalibration" object:nil];
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
}


#pragma mark -
#pragma mark BikePowerCalibration Implementation

//--------------------------------------------------------------------------------
- (void)setCalibration
{
	WFBikePowerCalibrationData_t calData;
	calData.calibrationId = BPS_CALIBRATION_TYPE_MANUAL;
	calData.reserved1 = BPS_CALIBRATION_RESERVE_BYTE;
	calData.reserved2 = BPS_CALIBRATION_RESERVE_BYTE;
	calData.reserved3 = BPS_CALIBRATION_RESERVE_BYTE;
	calData.reserved4 = BPS_CALIBRATION_RESERVE_BYTE;
	calData.reserved5 = BPS_CALIBRATION_RESERVE_BYTE;
	calData.reserved6 = BPS_CALIBRATION_RESERVE_BYTE;
	
	WFBikePowerCalibrationData_t calDataAuto;
	calDataAuto.calibrationId = BPS_CALIBRATION_TYPE_AUTO_ZERO;
	calDataAuto.reserved1 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataAuto.reserved2 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataAuto.reserved3 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataAuto.reserved4 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataAuto.reserved5 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataAuto.reserved6 = BPS_CALIBRATION_RESERVE_BYTE;
	
	WFBikePowerCalibrationData_t calDataSlope;
	calDataSlope.calibrationId = BPS_CALIBRATION_TYPE_CTF;
	calDataSlope.reserved1 = BPS_CALIBRATION_CTF_SLOPE_ID;
	calDataSlope.reserved2 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataSlope.reserved3 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataSlope.reserved4 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataSlope.reserved5 = (uint8_t)(BPS_CALIBRATION_SLOPE>>8);
	calDataSlope.reserved6 = (uint8_t)(BPS_CALIBRATION_SLOPE & 0xFF);
	
	WFBikePowerCalibrationData_t calDataSerial;
	calDataSerial.calibrationId = BPS_CALIBRATION_TYPE_CTF;
	calDataSerial.reserved1 = BPS_CALIBRATION_CTF_SERIAL_ID;
	calDataSerial.reserved2 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataSerial.reserved3 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataSerial.reserved4 = BPS_CALIBRATION_RESERVE_BYTE;
	calDataSerial.reserved5 = (uint8_t)(BPS_CALIBRATION_SERIAL>>8);
	calDataSerial.reserved6 = (uint8_t)(BPS_CALIBRATION_SERIAL & 0xFF);
	
	[bikePowerConnection setBikePowerCalibration:&calData];
}


#pragma mark -
#pragma mark Event Handler Implementation

//--------------------------------------------------------------------------------
- (IBAction)calibrateClicked:(id)sender
{
	promptLabel.text = @"Calibrating...";
	calibrationValueLabel.text = @"---";
    [self setCalibration];
}

//--------------------------------------------------------------------------------
- (void)calibrationResponse:(NSNotification*)unused
{
	// get the calibration data.
	WFBikePowerRawData* bpData = [bikePowerConnection getBikePowerRawData];
	int32_t calData = bpData.calibrationData.reserved5;
	calData |= (bpData.calibrationData.reserved6 << 8);
	
	// display the calibration data.
	promptLabel.text = @"Calibration";
	calibrationValueLabel.text = [NSString stringWithFormat:@"%d", calData];
    temperatureLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

@end
