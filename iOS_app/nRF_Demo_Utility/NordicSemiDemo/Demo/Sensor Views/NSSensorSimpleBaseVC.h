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
//  NSSensorSimpleBaseVC.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>
#import "NordicModalDelegate.h"

@interface NSSensorSimpleBaseVC : UIViewController <WFSensorConnectionDelegate, NordicModalDelegate> 
{

    WFHardwareConnector* hardwareConnector;
    NSArray * sensorTypes;
    NSMutableDictionary * sensorConnections;
    IBOutlet UIImageView* sensorStrength;
    IBOutlet UIActivityIndicatorView* connectingIndicator;
    IBOutlet UIButton* connectButton;
    BOOL sensorsConnected;
    WFNetworkType_t desiredNetwork;
}

@property (retain, nonatomic) NSMutableDictionary* sensorConnections;
@property (retain, nonatomic) NSArray* sensorTypes;
@property (retain, nonatomic) IBOutlet UIButton* connectButton;


- (IBAction)connectSensorClicked:(id)sender;
- (void)updateData;
- (void)resetDisplay;
-(NSString*)percentForBattStatus:(WFBatteryStatus_t)status;
- (void)doConfig:(id)sender;
- (void)doHelp:(id)sender;
- (UIImage*)sensorImageForStrength:(float)signal;
-(void)onSensorConnected:(WFSensorConnection*)connectionInfo;
@end
