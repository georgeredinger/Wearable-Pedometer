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
//  GlucoseVCSettings.h
//  WahooDemo
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"


@interface GlucoseVCSettings : WFSensorCommonViewController
{
    uint8_t auc_tx_id[5];
    uint8_t auc_perm_key[4];
    
    UITextField* permissionKeyField;
    UITextField* txIdField;
    UITextField* highField;
    UITextField* lowField;
    
    UISwitch  * highAlert;
    UISwitch  * lowAlert;
    UISwitch  * riseAlert;
    UISwitch  * fallAlert;
    UISegmentedControl * riseRateAlertLevel;
    UISegmentedControl * fallRateAlertLevel;
}


@property (readonly, nonatomic) WFGlucoseConnection* glucoseConnection;

@property (nonatomic, retain) IBOutlet UITextField* permissionKeyField;
@property (nonatomic, retain) IBOutlet UITextField* txIdField;
@property (nonatomic, retain) IBOutlet UITextField* highField;
@property (nonatomic, retain) IBOutlet UITextField* lowField;

@property (nonatomic, retain) IBOutlet UISwitch  * highAlert;
@property (nonatomic, retain) IBOutlet UISwitch  * fallAlert;
@property (nonatomic, retain) IBOutlet UISwitch  * riseAlert;
@property (nonatomic, retain) IBOutlet UISwitch  * lowAlert;
@property (nonatomic, retain) IBOutlet  UISegmentedControl * riseRateAlertLevel;
@property (nonatomic, retain) IBOutlet  UISegmentedControl * fallRateAlertLevel;

-(void)configSettings;
@end
