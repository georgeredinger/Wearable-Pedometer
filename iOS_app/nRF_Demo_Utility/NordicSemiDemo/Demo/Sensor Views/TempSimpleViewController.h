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
//  TempSimpleViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"

@interface TempSimpleViewController : NSSensorSimpleBaseVC
{
    UILabel* tempLabel;
    UILabel *battLevel;
}

@property (readonly, nonatomic) WFHealthThermometerConnection* healthThermometerConnection;
@property (retain, nonatomic) IBOutlet UILabel* tempLabel;
@property (retain, nonatomic) IBOutlet UILabel* battLevel;

@end
