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
//  ProximityViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 12/19/11.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"


@class WFProximityConnection;


@interface ProximityViewController : WFSensorCommonViewController <WFProximityDelegate>
{
    UILabel* alertLevelLabel;
    UILabel* txPowerLabel;
    UILabel* proxLabel;
    UILabel* battLevelLabel;
    UISegmentedControl* linkLossAlertSegment;
}


@property (readonly, nonatomic) WFProximityConnection* proximityConnection;
@property (nonatomic, retain) IBOutlet UILabel* alertLevelLabel;
@property (nonatomic, retain) IBOutlet UILabel* txPowerLabel;
@property (nonatomic, retain) IBOutlet UILabel* proxLabel;
@property (nonatomic, retain) IBOutlet UILabel* battLevelLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl* linkLossAlertSegment;


- (IBAction)mildAlertClicked:(id)sender;
- (IBAction)highAlertClicked:(id)sender;
- (IBAction)changedAlertLevel:(id)sender;

@end
