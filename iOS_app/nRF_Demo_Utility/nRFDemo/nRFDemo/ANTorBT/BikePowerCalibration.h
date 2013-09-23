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
//  BikePowerCalibration.h
//  FisicaDemo
//
//  Created by Michael Moore on 3/30/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>


@interface BikePowerCalibration : UIViewController
{
	WFHardwareConnector* hardwareConnector;
	WFBikePowerConnection* bikePowerConnection;
	UILabel* calibrationValueLabel;
    UILabel* temperatureLabel;
	UILabel* promptLabel;
    
    UITextField* potLevelField;
}


@property (nonatomic, retain) WFBikePowerConnection* bikePowerConnection;
@property (nonatomic, retain) IBOutlet UILabel* calibrationValueLabel;
@property (nonatomic, retain) IBOutlet UILabel* temperatureLabel;
@property (nonatomic, retain) IBOutlet UILabel* promptLabel;

- (void)setCalibration;
- (void)calibrationResponse:(NSNotification*)unused;

- (IBAction)calibrateClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
