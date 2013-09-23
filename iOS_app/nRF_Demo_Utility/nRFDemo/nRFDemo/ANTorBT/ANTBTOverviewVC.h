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
//  ANTBTOverviewVC.h
//  WahooDemo
//
//  Created by Michael Moore on 2/14/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFHardwareConnector;
@class WFSensorConnection;


@interface ANTBTOverviewVC : UIViewController
{
	WFHardwareConnector* hardwareConnector;
    
	UILabel* fisicaConnectedLabel;
    UILabel* btConnectedLabel;
    
	UILabel* hrConnectedLabel;
	UILabel* hrDeviceIdLabel;
	UILabel* hrSignalLabel;
	
	UILabel* bscConnectedLabel;
	UILabel* bscDeviceIdLabel;
	UILabel* bscSignalLabel;
    
	UILabel* bpConnectedLabel;
	UILabel* bpDeviceIdLabel;
	UILabel* bpSignalLabel;
}


@property (retain, nonatomic) IBOutlet UILabel* fisicaConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* btConnectedLabel;

@property (retain, nonatomic) IBOutlet UILabel* hrConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* hrDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* hrSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bscConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bscDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bscSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bpConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bpDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bpSignalLabel;


- (IBAction)heartrateClicked:(id)sender;
- (IBAction)bikeSpeedCadenceClicked:(id)sender;
- (IBAction)bikePowerClicked:(id)sender;
- (IBAction)discoverDevices:(id)sender;

@end
