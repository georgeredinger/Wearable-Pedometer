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
//  BloodPressureViewController.h
//  FisicaUtility
//
//  Created by chip on 6/8/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFFSSensorVCBase.h"


@interface BloodPressureViewController : WFFSSensorVCBase
{
	UILabel* systolicLabel;
	UILabel* diastolicLabel;
	UILabel* pulserateLabel;
	UILabel* sampledateLabel;
	UILabel* sampletimeLabel;
}

@property (retain, nonatomic) IBOutlet UILabel* systolicLabel;
@property (retain, nonatomic) IBOutlet UILabel* diastolicLabel;
@property (retain, nonatomic) IBOutlet UILabel* pulserateLabel;
@property (retain, nonatomic) IBOutlet UILabel* sampledateLabel;
@property (retain, nonatomic) IBOutlet UILabel* sampletimeLabel;

@end




