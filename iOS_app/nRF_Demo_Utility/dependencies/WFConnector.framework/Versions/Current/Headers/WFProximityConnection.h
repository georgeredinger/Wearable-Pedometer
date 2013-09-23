//
//  WFProximityConnection.h
//  WFConnector
//
//  Created by Michael Moore on 12/19/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>
#import <WFConnector/WFProximityDelegate.h>


@class WFProximityData;


/**
 * Represents a connection to a BTLE Proximity sensor.
 */
@interface WFProximityConnection : WFSensorConnection <WFProximityDelegate>
{
	/** \cond InterfaceDocs */
    
    id<WFProximityDelegate> proximityDelegate;
    
	/** \endcond */
}


/**
 * Specifies the WFProximityDelegate instance which will handle callback
 * methods for this WFProximityConnection.
 */
@property (nonatomic, retain ) id<WFProximityDelegate> proximityDelegate;


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFProximityData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFProximityData*)getProximityData;

/**
 * Returns a boolean value indicating whether the device is within the specified
 * proximity threshold.
 *
 * @see setProximityAlertThreshold:alertLevel:
 * @see WFProximityConnection::setProximityMode:
 *
 * @return <c>TRUE</c> if the device is within the specified threshold, or if the
 * proximity threshold is disabled.  Otherwise, <c>FALSE</c>.
 */
- (BOOL)isInRange;

/**
 * Sends a request for the proximity device to alert at the specified level.
 *
 * @note This method affects the alert indication on the device.
 *
 * @param alertLevel The level at which the device is to alert.
 *
 * @return <c>TRUE</c> if the request was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)sendImmediateAlert:(WFBTLEChAlertLevel_t)alertLevel;

/**
 * Sets the level at which the device is to alert when an alert condition is present.
 *
 * @note This method affects the alert indication on the device.  To set the
 * alert level for alerts received by the application through the WFProximityDelegate
 * methods, use the WFProximityConnection::setProximityAlertThreshold:alertLevel:
 * method instead.
 *
 * @param alertLevel The new alert level.
 *
 * @return <c>TRUE</c> if the alert level was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setAlertLevel:(WFBTLEChAlertLevel_t)alertLevel;

/**
 * Sets the alert threshold and level for alerts received by the application.
 *
 * @note This method affects the alert indication which will be sent to the
 * application through the WFProximityDelegate methods.  To modify alert indications
 * on the device, use the WFProximityConnection::setAlertLevel: method instead.
 *
 * @see WFProximityConnection::isInRange:
 * @see WFProximityConnection::setProximityMode:
 *
 * @param threshold The threshold past which an alert will be issued.
 * @param alertLevel The alert level.
 *
 * @return <c>TRUE</c> if the values are set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setProximityAlertThreshold:(WFProximityAlertThreshold_t)threshold alertLevel:(WFBTLEChAlertLevel_t)alertLevel;

/**
 * Sets the proximity mode for alerts received by the application.
 *
 * @note This method affects the alert indication which will be sent to the
 * application through the WFProximityDelegate methods.  The mode determines
 * whether the alert will be issued when the device is moving farther away or
 * when it is moving closer.
 *
 * @param mode The proximity mode.
 *
 * @return <c>TRUE</c> if the mode was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setProximityMode:(WFProximityAlertMode_t)mode;

@end
