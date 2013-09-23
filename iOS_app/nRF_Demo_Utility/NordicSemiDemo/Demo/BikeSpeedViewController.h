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
//  BikeSpeedViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/23/10.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"

@class WFBikeSpeedConnection;


@interface BikeSpeedViewController : WFSensorCommonViewController
{
	UILabel* lastSpeedTimeLabel;
	UILabel* totalSpeedRevolutionsLabel;
	UILabel* computedSpeedLabel;
	UILabel* averageSpeedLabel;
    UILabel* distanceLabel;
}

@property (readonly, nonatomic) WFBikeSpeedConnection* bikeSpeedConnection;
@property (retain, nonatomic) IBOutlet UILabel* averageSpeedLabel;
@property (retain, nonatomic) IBOutlet UILabel* lastSpeedTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel* totalSpeedRevolutionsLabel;
@property (retain, nonatomic) IBOutlet UILabel* computedSpeedLabel;
@property (retain, nonatomic) IBOutlet UILabel* distanceLabel;

@end
