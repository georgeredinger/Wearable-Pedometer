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
//  ANTOverviewVC.h
//  FisicaDemo
//
//  Created by Michael Moore on 3/25/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFHardwareConnector;
@class WFSensorConnection;


@interface ANTOverviewVC : UIViewController
{
	WFHardwareConnector* hardwareConnector;
    
	UILabel* fisicaConnectedLabel;
    
	UILabel* bsConnectedLabel;
	UILabel* bsDeviceIdLabel;
	UILabel* bsSignalLabel;
	
	UILabel* bcConnectedLabel;
	UILabel* bcDeviceIdLabel;
	UILabel* bcSignalLabel;
	
	UILabel* fpConnectedLabel;
	UILabel* fpDeviceIdLabel;
	UILabel* fpSignalLabel;
	
	UILabel* wsConnectedLabel;
	UILabel* wsDeviceIdLabel;
	UILabel* wsSignalLabel;
	
	UILabel* cgmConnectedLabel;
	UILabel* cgmDeviceIdLabel;
	UILabel* cgmSignalLabel;
}


@property (retain, nonatomic) IBOutlet UILabel* fisicaConnectedLabel;

@property (retain, nonatomic) IBOutlet UILabel* bsConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bsDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bsSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bcConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bcDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bcSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* fpConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* fpDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* fpSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* wsConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* wsDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* wsSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* cgmConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* cgmDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* cgmSignalLabel;


- (IBAction)bikeSpeedClicked:(id)sender;
- (IBAction)bikeCadenceClicked:(id)sender;
- (IBAction)strideSensorClicked:(id)sender;
- (IBAction)weightSensorClicked:(id)sender;
- (IBAction)glucoseSensorClicked:(id)sender;

@end
