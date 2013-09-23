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
//  BikingViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"

@interface BikingViewController : NSSensorSimpleBaseVC
{
    UILabel* speedLabel;
    UILabel* distanceLabel;
    UILabel* cadenceLabel;
    UILabel* powerLabel;
    UILabel* powerUnit;
    UILabel* powerTitle;
    UILabel* computedHeartrateLabel;
    UILabel* distanceUnit;
    UILabel* btSpeedCadBatt;
    UILabel* hrmBatt;
    UILabel* btSpeedCadBattTitle;
    UILabel* hrmBattTitle;
    UILabel* pwrBattTitle;
    UILabel* pwrBatt;
    UIImageView *ANTLogo;
    UIImageView *BTLogo;
    UIImageView *btSCBattImg;
    UIImageView *hrmBattImg;
    UIImageView *pwrBattImg;
}

@property (readonly, nonatomic) WFHeartrateConnection* heartrateConnection;
@property (readonly, nonatomic) WFBikePowerConnection* powerConnection;
@property (readonly, nonatomic) WFBikeSpeedConnection* speedConnection;
@property (readonly, nonatomic) WFBikeSpeedCadenceConnection* speedCadenceConnection;
@property (readonly, nonatomic) WFBikeCadenceConnection* cadenceConnection;
@property (retain, nonatomic) IBOutlet UILabel* speedLabel;
@property (retain, nonatomic) IBOutlet UILabel* distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel* cadenceLabel;
@property (retain, nonatomic) IBOutlet UILabel* powerTitle;
@property (retain, nonatomic) IBOutlet UILabel* powerLabel;
@property (retain, nonatomic) IBOutlet UILabel* powerUnit;
@property (retain, nonatomic) IBOutlet UILabel* computedHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* distanceUnit;
@property (retain, nonatomic) IBOutlet UILabel* btSpeedCadBatt;
@property (retain, nonatomic) IBOutlet UILabel* hrmBatt;
@property (retain, nonatomic) IBOutlet UILabel* pwrBatt;
@property (retain, nonatomic) IBOutlet UILabel* pwrBattTitle;
@property (retain, nonatomic) IBOutlet UIImageView *ANTLogo;
@property (retain, nonatomic) IBOutlet UIImageView *BTLogo;
@property (retain, nonatomic) IBOutlet UILabel* btSpeedCadBattTitle;
@property (retain, nonatomic) IBOutlet UILabel* hrmBattTitle;
@property (retain, nonatomic) IBOutlet UIImageView *btSCBattImg;
@property (retain, nonatomic) IBOutlet UIImageView *hrmBattImg;
@property (retain, nonatomic) IBOutlet UIImageView *pwrBattImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forNetwork:(WFNetworkType_t)network;

@end
