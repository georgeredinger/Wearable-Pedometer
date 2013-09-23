//
//  OverviewViewController.h
//  nRF Demo
//
//  Created by Michael Moore on 3/25/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFHardwareConnector;
@class WFSensorConnection;


@interface OverviewViewController : UIViewController
{
	WFHardwareConnector* hardwareConnector;
    
	UILabel* hardwareConnectedLabel;
    
	UILabel* hrConnectedLabel;
	UILabel* hrDeviceIdLabel;
	UILabel* hrSignalLabel;
	
	UILabel* bscConnectedLabel;
	UILabel* bscDeviceIdLabel;
	UILabel* bscSignalLabel;
	
	UILabel* bsConnectedLabel;
	UILabel* bsDeviceIdLabel;
	UILabel* bsSignalLabel;
	
	UILabel* bcConnectedLabel;
	UILabel* bcDeviceIdLabel;
	UILabel* bcSignalLabel;
	
	UILabel* bpConnectedLabel;
	UILabel* bpDeviceIdLabel;
	UILabel* bpSignalLabel;
	
	UILabel* fpConnectedLabel;
	UILabel* fpDeviceIdLabel;
	UILabel* fpSignalLabel;
	
	UILabel* wsConnectedLabel;
	UILabel* wsDeviceIdLabel;
	UILabel* wsSignalLabel;
}


@property (retain, nonatomic) IBOutlet UILabel* hardwareConnectedLabel;

@property (retain, nonatomic) IBOutlet UILabel* hrConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* hrDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* hrSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bscConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bscDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bscSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bsConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bsDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bsSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bcConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bcDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bcSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bpConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bpDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bpSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* fpConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* fpDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* fpSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* wsConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* wsDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* wsSignalLabel;


- (IBAction)settingsClicked:(id)sender;
- (IBAction)heartrateClicked:(id)sender;
- (IBAction)bikeSpeedCadenceClicked:(id)sender;
- (IBAction)bikeSpeedClicked:(id)sender;
- (IBAction)bikeCadenceClicked:(id)sender;
- (IBAction)bikePowerClicked:(id)sender;
- (IBAction)strideSensorClicked:(id)sender;
- (IBAction)weightSensorClicked:(id)sender;

@end
