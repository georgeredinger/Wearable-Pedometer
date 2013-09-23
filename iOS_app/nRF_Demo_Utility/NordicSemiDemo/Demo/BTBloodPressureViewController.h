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
//  BTBloodPressureViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 2/22/12.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"


@interface BTBloodPressureViewController : NSSensorSimpleBaseVC
{
    UILabel* inProgressLabel;
    UILabel* pressurelabel;
	UILabel* systolicLabel;
	UILabel* diastolicLabel;
	UILabel* pulserateLabel;
	UILabel* meanAPLabel;
    UILabel* battLevel;
    BOOL bHistoryLoaded;
}

@property (readonly, nonatomic) WFBloodPressureConnection* bloodPressureConnection;
@property (nonatomic, retain) IBOutlet UILabel* inProgressLabel;
@property (nonatomic, retain) IBOutlet UILabel* pressureLabel;
@property (retain, nonatomic) IBOutlet UILabel* systolicLabel;
@property (retain, nonatomic) IBOutlet UILabel* diastolicLabel;
@property (retain, nonatomic) IBOutlet UILabel* pulserateLabel;
@property (retain, nonatomic) IBOutlet UILabel* meanAPLabel;
@property (retain, nonatomic) IBOutlet UILabel* battLevel;

- (IBAction)historyClicked:(id)sender;
@end




