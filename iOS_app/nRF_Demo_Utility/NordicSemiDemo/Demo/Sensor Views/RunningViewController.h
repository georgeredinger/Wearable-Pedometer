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
//  RunningViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"

@interface RunningViewController : NSSensorSimpleBaseVC
{
    UILabel* speedLabel;
    UILabel* distanceLabel;
    UILabel* cadenceLabel;
    UILabel* paceLabel;
    UILabel* computedHeartrateLabel;
    UILabel* distanceUnit;
}

@property (readonly, nonatomic) WFHeartrateConnection* heartrateConnection;
@property (readonly, nonatomic) WFFootpodConnection* footpodConnection;
@property (retain, nonatomic) IBOutlet UILabel* speedLabel;
@property (retain, nonatomic) IBOutlet UILabel* distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel* cadenceLabel;
@property (retain, nonatomic) IBOutlet UILabel* paceLabel;
@property (retain, nonatomic) IBOutlet UILabel* computedHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* distanceUnit;
@property (retain, nonatomic) IBOutlet UILabel *hrmBatteryLabel;
@property (retain, nonatomic) IBOutlet UILabel *spdBatteryLabel;


@end
