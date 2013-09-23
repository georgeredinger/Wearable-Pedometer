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
//  SettingsViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 11/11/11.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController
{
    UILabel* dongleConnectedLabel;
    UILabel* btConnectedLabel;
	UITextField* sampleRateText;
    UITextField* staleDataStringText;
    UITextField* staleDataTimeText;
    UITextField* coastingTimeText;
    UITextField* wheelCircText;
    UISwitch* metricSwitch;
    UISwitch*multitaskSwitch;
    UILabel *appVersion;
    UILabel *apiVersion;
}

@property (retain, nonatomic) IBOutlet UILabel* dongleConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* btConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* appVersion;
@property (retain, nonatomic) IBOutlet UILabel* apiVersion;
@property (retain, nonatomic) IBOutlet UITextField* sampleRateText;
@property (retain, nonatomic) IBOutlet UITextField* staleDataStringText;
@property (retain, nonatomic) IBOutlet UITextField* staleDataTimeText;
@property (retain, nonatomic) IBOutlet UITextField* coastingTimeText;
@property (retain, nonatomic) IBOutlet UITextField* wheelCircText;
@property (retain, nonatomic) IBOutlet UISwitch* metricSwitch;
@property (retain, nonatomic) IBOutlet UISwitch* multitaskSwitch;
   

- (IBAction)setValuesClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)doHelp:(id)sender;
@end
