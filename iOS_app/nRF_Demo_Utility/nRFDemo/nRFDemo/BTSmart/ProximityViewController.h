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
//  ProximityViewController.h
//  WahooDemo
//
//  Created by Michael Moore on 12/19/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"


@interface ProximityViewController : WFSensorCommonViewController <WFProximityDelegate>
{
    UILabel* alertLevelLabel;
    UILabel* txPowerLabel;
    UILabel* proxLabel;
    UILabel* battLevelLabel;
}


@property (readonly, nonatomic) WFProximityConnection* proximityConnection;
@property (nonatomic, retain) IBOutlet UILabel* alertLevelLabel;
@property (nonatomic, retain) IBOutlet UILabel* txPowerLabel;
@property (nonatomic, retain) IBOutlet UILabel* proxLabel;
@property (nonatomic, retain) IBOutlet UILabel* battLevelLabel;


- (IBAction)mildAlertClicked:(id)sender;
- (IBAction)highAlertClicked:(id)sender;
- (IBAction)setMildClicked:(id)sender;
- (IBAction)setHighClicked:(id)sender;

@end
