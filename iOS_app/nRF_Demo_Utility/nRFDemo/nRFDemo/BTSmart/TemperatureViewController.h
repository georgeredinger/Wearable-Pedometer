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
//  TemperatureViewController.h
//  WahooDemo
//
//  Created by Michael Moore on 12/22/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"


@interface TemperatureViewController : WFSensorCommonViewController
{
    UILabel* tempLabel;
    UILabel* tempTypeLabel;
}


@property (readonly, nonatomic) WFHealthThermometerConnection* healthThermometerConnection;
@property (nonatomic, retain) IBOutlet UILabel* tempLabel;
@property (nonatomic, retain) IBOutlet UILabel* tempTypeLabel;

@end
