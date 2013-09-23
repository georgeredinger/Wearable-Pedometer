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
//  BikePowerViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 3/25/10.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"

@class WFBikePowerConnection;


@interface BikePowerViewController : WFSensorCommonViewController
{
	UILabel* eventCountLabel;
	UILabel* instantCadenceLabel;
	UILabel* accumulatedTorqueLabel;
	UILabel* instantPowerLabel;
	UILabel* averagePowerLabel;
}


@property (readonly, nonatomic) WFBikePowerConnection* bikePowerConnection;
@property (retain, nonatomic) IBOutlet UILabel* eventCountLabel;
@property (retain, nonatomic) IBOutlet UILabel* instantCadenceLabel;
@property (retain, nonatomic) IBOutlet UILabel* accumulatedTorqueLabel;
@property (retain, nonatomic) IBOutlet UILabel* instantPowerLabel;
@property (retain, nonatomic) IBOutlet UILabel* averagePowerLabel;


- (IBAction)calibrateClicked:(id)sender;

@end
