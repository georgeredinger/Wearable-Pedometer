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
//  AntSensorsViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/7/11.
//

#import <UIKit/UIKit.h>

@interface AntSensorsViewController : UIViewController
{
    BOOL alertedNoConnector;
}
- (IBAction)hrmClicked:(id)sender;
- (IBAction)runningClicked:(id)sender;
- (IBAction)bikingClicked:(id)sender;
- (IBAction)weightClicked:(id)sender;
- (IBAction)bpClicked:(id)sender;
- (IBAction)cgmClicked:(id)sender;
- (IBAction)fsClicked:(id)sender;

@end
