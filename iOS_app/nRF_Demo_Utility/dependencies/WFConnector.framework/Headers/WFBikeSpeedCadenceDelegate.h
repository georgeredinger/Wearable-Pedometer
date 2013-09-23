//
//  WFBikeSpeedCadenceDelegate.h
//  WFConnector
//
//  Created by Michael Moore on 3/30/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WFBikeSpeedCadenceConnection;
@class WFOdometerHistory;


/**
 * Provides the interface for callback methods used by the WFBikeSpeedCadenceConnection.
 */
@protocol WFBikeSpeedCadenceDelegate <NSObject>

/**
 * Invoked when the WFBikeSpeedCadenceConnection receives odometer history from the
 * device.
 *
 * @param cscConn The WFBikeSpeedCadenceConnection instance.
 *
 * @param history A WFOdometerHistory representing the glucose data record.
 */
- (void)cscConnection:(WFBikeSpeedCadenceConnection*)cscConn didReceiveOdometerHistory:(WFOdometerHistory*)history;

/**
 * Invoked when the WFBikeSpeedCadenceConnection receives the status of a request
 * to reset the odometer value.
 *
 * @param cscConn The WFBikeSpeedCadenceConnection instance.
 *
 * @param bSuccess <c>TRUE</c> if the request to reset the odometer was successful,
 * otherwise <c>FALSE</c>.
 */
- (void)cscConnection:(WFBikeSpeedCadenceConnection*)cscConn didResetOdometer:(BOOL)bSuccess;

@end
