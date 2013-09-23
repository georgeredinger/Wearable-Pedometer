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
//  NordicSemiAppDelegate.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/1/11.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>
#import <WFConnector/WFAntFS.h>


@interface NordicSemiAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate, WFHardwareConnectorDelegate, UINavigationControllerDelegate>
{
    WFHardwareConnector* hardwareConnector;
    UINavigationController *navigationController;
    NSMutableDictionary * wildcardSwitches;
    NSMutableDictionary * proximitySwitches;
    NSMutableDictionary * sensorSettings;
    WFProximityAlertThreshold_t proximityAlertThreshold;
    WFBTLEChAlertLevel_t proximityAlertLevel;
    BOOL allowMultitask;
    UIImageView * splashView;
    UIView * rootBg;
    IBOutlet UIWindow * window;
    NSMutableArray * cgmPlotData;
    NSMutableArray * hrmPlotData;
    NSNumber * initialCGMTime;
    NSNumber * initialHRMTime;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIView * rootBg;
@property (nonatomic, retain) NSMutableDictionary * wildcardSwitches;
@property (nonatomic, retain) NSMutableDictionary * proximitySwitches;
@property WFProximityAlertThreshold_t proximityAlertThreshold;
@property WFBTLEChAlertLevel_t proximityAlertLevel;
@property BOOL allowMultitask;
@property (nonatomic, retain) NSMutableArray * cgmPlotData;
@property (nonatomic, retain) NSMutableArray * hrmPlotData;
@property (nonatomic, retain) NSNumber * initialCGMTime;
@property (nonatomic, retain) NSNumber * initialHRMTime;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)animateRootBg:(BOOL)left;
- (NSString*)getPasskey:(WFAntFSDeviceType_t)deviceType;
- (BOOL)savePasskey:(NSString*)passkey forDeviceType:(WFAntFSDeviceType_t)deviceType;

- (void)copyPlistToDocs;
-(void)generateData;
-(void)storeGGMPlot:(NSDictionary*)point;
-(void)storeHRMPlot:(NSDictionary*)point;

@end
