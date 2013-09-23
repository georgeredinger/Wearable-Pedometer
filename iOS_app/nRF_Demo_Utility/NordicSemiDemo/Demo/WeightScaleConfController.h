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
//  WeightScaleConfController.h
//  FisicaDemo
//
//  Created by Michael Moore on 4/5/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"


@interface WeightScaleConfController : WFSensorCommonViewController
{
	UILabel* bodyWeightLabel;
	UILabel* hydrationPercentLabel;
	UILabel* muscleMassLabel;
	UILabel* boneMassLabel;
	UILabel* bodyFatPercentLabel;
	UILabel* activeMetabolicRateLabel;
	UILabel* basalMetabolicRateLabel;
	UILabel* isUserProfileSelectedLabel;
	UILabel* userProfileIdLabel;
}


@property (readonly, nonatomic) WFWeightScaleConnection* weightScaleConnection;
@property (nonatomic, retain) IBOutlet UILabel* bodyWeightLabel;
@property (nonatomic, retain) IBOutlet UILabel* hydrationPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel* bodyFatPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel* muscleMassLabel;
@property (nonatomic, retain) IBOutlet UILabel* boneMassLabel;
@property (nonatomic, retain) IBOutlet UILabel* activeMetabolicRateLabel;
@property (nonatomic, retain) IBOutlet UILabel* basalMetabolicRateLabel;
@property (nonatomic, retain) IBOutlet UILabel* isUserProfileSelectedLabel;
@property (nonatomic, retain) IBOutlet UILabel* userProfileIdLabel;


- (IBAction)profileClicked:(id)sender;

@end
