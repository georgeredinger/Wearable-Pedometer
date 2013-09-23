//
//  WFProximityDelegate.h
//  WFConnector
//
//  Created by Michael Moore on 12/21/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>


@class WFProximityConnection;


/**
 * Provides the interface for callback methods used by the WFProximityConnection.
 */
@protocol WFProximityDelegate <NSObject>

@required

/**
 * Invoked when the WFProximityConnection receives an alert from the device indicating
 * that the device proximity has crossed the specified threshold.
 *
 * @param proxConn The WFProximityConnection instance.
 
 * @param alertLevel The level of alert issued by the device.
 * @param mode The proximity mode.
 *
 * @param signalLoss The difference between the transmitted signal level and the
 * received signal level.
 */
- (void)proximityConnection:(WFProximityConnection*)proxConn proximityAlert:(WFBTLEChAlertLevel_t)alertLevel proximityMode:(WFProximityAlertMode_t)mode signalLoss:(int)signalLoss;

@end
