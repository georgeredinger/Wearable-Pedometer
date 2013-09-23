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
//  HeartrateViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/20/10.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"

@class WFHeartrateConnection;


@interface HeartrateViewController : WFSensorCommonViewController
{
	UILabel* computedHeartrateLabel;
	UILabel* beatTimeLabel;
	UILabel* beatCountLabel;
	UILabel* previousBeatLabel;
    UILabel* battLevelLabel;
}


@property (readonly, nonatomic) WFHeartrateConnection* heartrateConnection;
@property (retain, nonatomic) IBOutlet UILabel* computedHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* beatTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel* beatCountLabel;
@property (retain, nonatomic) IBOutlet UILabel* previousBeatLabel;
@property (retain, nonatomic) IBOutlet UILabel* batLevelLabel;

@end
