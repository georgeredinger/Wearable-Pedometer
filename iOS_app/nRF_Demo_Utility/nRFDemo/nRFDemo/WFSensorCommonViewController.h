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
//  WFSensorCommonViewController.h
//  FisicaDemo
//
//  Created by Michael Moore on 2/23/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>
#import "SensorManagerViewController.h"


@class ANTDeviceInfoVC;
@class BTDeviceInfoVC;


@interface WFSensorCommonViewController : UIViewController <WFSensorConnectionDelegate, SensorManagerDelegate>
{
	WFHardwareConnector* hardwareConnector;
	WFSensorConnection* sensorConnection;
	WFSensorType_t sensorType;
	UILabel* deviceIdLabel;
	UILabel* signalEfficiencyLabel;
	
	UIButton* connectButton;
	UISwitch* wildcardSwitch;
    UISwitch* proximitySwitch;
    
    ANTDeviceInfoVC* antDeviceInfo;
    BTDeviceInfoVC* btDeviceInfo;
    
    USHORT applicableNetworks;
}


@property (retain, nonatomic) WFSensorConnection* sensorConnection;
@property (retain, nonatomic) IBOutlet UILabel* signalEfficiencyLabel;
@property (retain, nonatomic) IBOutlet UILabel* deviceIdLabel;

@property (retain, nonatomic) IBOutlet UIButton* connectButton;
@property (retain, nonatomic) IBOutlet UISwitch* wildcardSwitch;
@property (retain, nonatomic) IBOutlet UISwitch* proximitySwitch;


- (IBAction)connectSensorClicked:(id)sender;
- (IBAction)deviceInfoClicked:(id)sender;
- (IBAction)manageClicked:(id)sender;
- (IBAction)proximityToggled:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)wildcardToggled:(id)sender;

- (void)onSensorConnected:(WFSensorConnection*)connectionInfo;
- (void)updateData;

- (void)resetDisplay;


+ (NSString*)formatUUIDString:(NSString*)uuid;
+ (NSString*)signalStrengthFromConnection:(WFSensorConnection*)conn;
+ (NSString*)stringFromSensorType:(WFSensorType_t)sensorType;

@end
