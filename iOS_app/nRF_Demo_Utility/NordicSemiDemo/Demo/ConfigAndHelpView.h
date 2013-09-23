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
//  ConfigAndHelpView.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/17/11.
//

#import <UIKit/UIKit.h>

@interface ConfigAndHelpView : UIView
{
    IBOutlet UIButton * configButton;
    IBOutlet UIButton * helpButton;
}

@property (nonatomic, retain) IBOutlet UIButton * configButton;
@property (nonatomic, retain) IBOutlet UIButton * helpButton;

@end
