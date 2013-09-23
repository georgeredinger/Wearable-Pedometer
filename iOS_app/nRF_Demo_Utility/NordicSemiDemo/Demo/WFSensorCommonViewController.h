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
//  WFSensorCommonViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/23/10.
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
//	UILabel* operatingTimeLabel;
	UILabel* manufacturerIdLabel;
	UILabel* serialNumberLabel;
	UILabel* hardwareVersionLabel;
	UILabel* softwareVersionLabel;
	UILabel* modelNumberLabel;
    UILabel* battStatusLabel;
    UILabel* battVoltageLabel;
	
	UIButton* connectButton;
	UISwitch* wildcardSwitch;
    UISwitch* proximitySwitch;
    UIActivityIndicatorView* connectingIndicator;
    
    UINavigationController * parentNavController;
    
    ANTDeviceInfoVC* antDeviceInfo;
    BTDeviceInfoVC* btDeviceInfo;
    
    USHORT applicableNetworks;
}


@property (retain, nonatomic) WFSensorConnection* sensorConnection;
@property (nonatomic, readonly) BOOL isWildcardSearch;

@property (retain, nonatomic) IBOutlet UILabel* signalEfficiencyLabel;
@property (retain, nonatomic) IBOutlet UILabel* deviceIdLabel;
//@property (retain, nonatomic) IBOutlet UILabel* operatingTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel* manufacturerIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* serialNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel* hardwareVersionLabel;
@property (retain, nonatomic) IBOutlet UILabel* softwareVersionLabel;
@property (retain, nonatomic) IBOutlet UILabel* modelNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel* battStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel* battVoltageLabel;

@property (retain, nonatomic) IBOutlet UIButton* connectButton;
@property (retain, nonatomic) IBOutlet UISwitch* wildcardSwitch;
@property (retain, nonatomic) IBOutlet UISwitch* proximitySwitch;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* connectingIndicator;

@property (retain, nonatomic) UINavigationController * parentNavController;

@property USHORT applicableNetworks;

- (IBAction)connectSensorClicked:(id)sender;
- (IBAction)deviceInfoClicked:(id)sender;
- (IBAction)manageClicked:(id)sender;
- (IBAction)proximityToggled:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)wildcardToggled:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forSensor:(WFSensorType_t)sensType;
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo;
- (void)updateData;

- (void)resetDisplay;

+ (NSString*)formatUUID:(NSString*)uuid;
+ (NSString*)signalStrengthFromConnection:(WFSensorConnection*)conn;
+ (NSString*)stringFromSensorType:(WFSensorType_t)sensorType;

@end
