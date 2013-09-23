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
//  TemperatureViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 12/22/11.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"


@class WFHealthThermometerConnection;


@interface TemperatureViewController : WFSensorCommonViewController
{
    UILabel* tempLabel;
    UILabel* tempTypeLabel;
}


@property (readonly, nonatomic) WFHealthThermometerConnection* healthThermometerConnection;
@property (nonatomic, retain) IBOutlet UILabel* tempLabel;
@property (nonatomic, retain) IBOutlet UILabel* tempTypeLabel;

@end
