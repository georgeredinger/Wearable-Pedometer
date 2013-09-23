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
//  ProximitySimpleViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"

@interface ProximitySimpleViewController : NSSensorSimpleBaseVC <WFProximityDelegate>
{
    UILabel* batteryLabel;
    UIImageView* padlock;
}

@property (readonly, nonatomic) WFProximityConnection* proximityConnection;
@property (retain, nonatomic) IBOutlet UILabel* batteryLabel;
@property (retain, nonatomic) IBOutlet UIImageView* padlock;
@property (retain, nonatomic) IBOutlet UISwitch *extremeSecuritySwitch;
@property (retain, nonatomic) IBOutlet UIButton *findMyTagButton;
@property (retain, nonatomic) IBOutlet UISlider *alertThresholdSlider;
- (IBAction)extremeSecuritySwitchChanged:(id)sender;
- (IBAction)alertThresholdChanged:(id)sender;

- (IBAction)findTag:(id)sender;

@end
