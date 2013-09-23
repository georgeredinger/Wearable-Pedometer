//
//  WFGlucoseConnection.h
//  WFConnector
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>
#import <WFConnector/WFGlucoseDelegate.h>
#import <WFConnector/wf_glucose_types.h>


@class WFGlucoseData;


/**
 * Represents a connection to an ANT+ Glucose Monitor sensor.
 */
@interface WFGlucoseConnection : WFSensorConnection <WFGlucoseDelegate>
{
	/** \cond InterfaceDocs */
    
    id<WFGlucoseDelegate> glucoseDelegate;
    
	/** \endcond */
}


/**
 * Specifies the WFGlucoseDelegate instance which will handle callback
 * methods for this WFGlucoseConnection.
 */
@property (nonatomic, retain ) id<WFGlucoseDelegate> glucoseDelegate;


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFGlucoseData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFGlucoseData*)getGlucoseData;

/**
 * Sets the levels at which the device issues alerts.
 *
 * @param rising The level at which the device will issue alerts for rising
 * glucose level.
 *
 * @param falling The level at which the device will issue alerts for falling
 * glucose level.
 *
 * @param usHigh The level at which the device will issue alerts for high glucose.
 * @param usLow The level at which the device will issue alerts for low glucose.
 *
 * @return <c>TRUE</c> if the alert levels were set successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)setAlertLevelsRising:(WFGlucoseRateAlertLevel_t)rising falling:(WFGlucoseRateAlertLevel_t)falling highGlucose:(USHORT)usHigh lowGlucose:(USHORT)usLow;

/**
 * Sets the permission key and transmitter ID used for device authentication.
 *
 * @note A connected device will not transfer data until this method has been
 * invoked with the proper values.  This method may be invoked any time after
 * the WFGlucoseConnection instance is created.  It is only necessary to invoke
 * the method once (per instance).
 *
 * @param permKey An NSData instance containing the permission key.  This is a
 * four byte value specific to the device.
 *
 * @param txId An NSData instance containing the transmitter ID.  This is a
 * five byte value specific to the device.
 *
 * @return <c>TRUE</c> if the values were set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setPermissionKey:(NSData*)permKey andTxId:(NSData*)txId;

@end
