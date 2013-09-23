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
//  BTOverviewVC.h
//  WahooDemo
//
//  Created by Michael Moore on 2/14/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WFHardwareConnector;



@interface BTOverviewVC : UIViewController
{
	WFHardwareConnector* hardwareConnector;
    
    UILabel* btConnectedLabel;
    
	UILabel* proxConnectedLabel;
	UILabel* proxDeviceIdLabel;
	UILabel* proxSignalLabel;
    
	UILabel* tempConnectedLabel;
	UILabel* tempDeviceIdLabel;
	UILabel* tempSignalLabel;
    
	UILabel* bpConnectedLabel;
	UILabel* bpDeviceIdLabel;
	UILabel* bpSignalLabel;
    
	UILabel* glucConnectedLabel;
	UILabel* glucDeviceIdLabel;
	UILabel* glucSignalLabel;
}


@property (retain, nonatomic) IBOutlet UILabel* btConnectedLabel;

@property (retain, nonatomic) IBOutlet UILabel* proxConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* proxDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* proxSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* tempConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* tempDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* tempSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* bpConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* bpDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* bpSignalLabel;

@property (retain, nonatomic) IBOutlet UILabel* glucConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* glucDeviceIdLabel;
@property (retain, nonatomic) IBOutlet UILabel* glucSignalLabel;


- (IBAction)bpClicked:(id)sender;
- (IBAction)glucClicked:(id)sender;
- (IBAction)proximityClicked:(id)sender;
- (IBAction)temperatureClicked:(id)sender;


@end
