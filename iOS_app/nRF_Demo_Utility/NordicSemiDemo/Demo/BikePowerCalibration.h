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
//  BikePowerCalibration.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 3/30/10.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>


@interface BikePowerCalibration : UIViewController
{
	WFHardwareConnector* hardwareConnector;
	WFBikePowerConnection* bikePowerConnection;
	UILabel* calibrationValueLabel;
	UILabel* promptLabel;
}


@property (nonatomic, retain) WFBikePowerConnection* bikePowerConnection;
@property (nonatomic, retain) IBOutlet UILabel* calibrationValueLabel;
@property (nonatomic, retain) IBOutlet UILabel* promptLabel;


- (void)setCalibration;

- (IBAction)calibrateClicked:(id)sender;
- (void)calibrationResponse:(NSNotification*)unused;

@end
