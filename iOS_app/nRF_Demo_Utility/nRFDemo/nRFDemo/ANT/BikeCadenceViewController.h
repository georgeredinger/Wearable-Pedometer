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
//  BikeCadenceViewController.h
//  FisicaDemo
//
//  Created by Michael Moore on 2/23/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"

@class WFBikeCadenceConnection;


@interface BikeCadenceViewController : WFSensorCommonViewController
{
	UILabel* totalCadenceRevolutionsLabel;
	UILabel* lastCadenceTimeLabel;
	UILabel* computedCadenceLabel;
	UILabel* averageCadenceLabel;
}

@property (readonly, nonatomic) WFBikeCadenceConnection* bikeCadenceConnection;
@property (retain, nonatomic) IBOutlet UILabel* averageCadenceLabel;
@property (retain, nonatomic) IBOutlet UILabel* lastCadenceTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel* totalCadenceRevolutionsLabel;
@property (retain, nonatomic) IBOutlet UILabel* computedCadenceLabel;

@end
