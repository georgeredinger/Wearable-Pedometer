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
//  SettingsViewController.h
//  WahooDemo
//
//  Created by Michael Moore on 11/11/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    UILabel* dongleConnectedLabel;
    UILabel* btConnectedLabel;
	UITextField* sampleRateText;
    UITextField* staleDataStringText;
    UITextField* staleDataTimeText;
    UITextField* coastingTimeText;
    UITextField* wheelCircText;
    UITextField* searchTimeout;
    UITextField* discoveryTimeout;
    UISwitch* metricSwitch;
}


@property (retain, nonatomic) IBOutlet UILabel* dongleConnectedLabel;
@property (retain, nonatomic) IBOutlet UILabel* btConnectedLabel;
@property (retain, nonatomic) IBOutlet UITextField* sampleRateText;
@property (retain, nonatomic) IBOutlet UITextField* staleDataStringText;
@property (retain, nonatomic) IBOutlet UITextField* staleDataTimeText;
@property (retain, nonatomic) IBOutlet UITextField* coastingTimeText;
@property (retain, nonatomic) IBOutlet UITextField* wheelCircText;
@property (retain, nonatomic) IBOutlet UITextField* searchTimeout;
@property (retain, nonatomic) IBOutlet UITextField* discoveryTimeout;
@property (retain, nonatomic) IBOutlet UISwitch* metricSwitch;
   

- (IBAction)emailLogClicked:(id)sender;
- (IBAction)setValuesClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
