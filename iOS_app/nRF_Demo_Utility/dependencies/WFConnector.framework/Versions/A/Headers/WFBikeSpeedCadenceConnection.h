//
//  WFBikeSpeedCadenceConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>
#import <WFConnector/wf_btle_types.h>
#import <WFConnector/WFBikeSpeedCadenceDelegate.h>


@class WFBikeSpeedCadenceData;
@class WFBikeSpeedCadenceRawData;
@class WFBTLEBikeSpeedCadenceData;


/**
 * Represents a connection to an ANT+ combined Bike Speed and Cadence sensor.
 */
@interface WFBikeSpeedCadenceConnection : WFSensorConnection <WFBikeSpeedCadenceDelegate>
{
	/** \cond InterfaceDocs */
    
    id<WFBikeSpeedCadenceDelegate> cscDelegate;
    
	/** \endcond */
}


/**
 * Specifies the WFBikeSpeedCadenceDelegate instance which will handle callback
 * methods for this WFBikeSpeedCadenceConnection.
 */
@property (nonatomic, retain) id<WFBikeSpeedCadenceDelegate> cscDelegate;


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFBikeSpeedCadenceData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBikeSpeedCadenceData*)getBikeSpeedCadenceData;

/**
 * Returns the latest raw (unformatted) data available from the sensor.
 *
 * @see WFSensorConnection::getRawData
 *
 * @return A WFBikeSpeedCadenceRawData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBikeSpeedCadenceRawData*)getBikeSpeedCadenceRawData;

/**
 * Returns the latest data available from the sensor.
 *
 * @note This property is only available for BTLE speed and cadence sensors.
 * For other types, this property will be <c>nil</c>.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFBTLEBikeSpeedCadenceData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBTLEBikeSpeedCadenceData*)getCSCData;

/**
 * Sends a request for the odometer history within the specified range.
 *
 * @note This method is only available for Wahoo Fitness BlueSC BTLE speed and
 * cadence devices.  For other types, this method will return <c>FALSE</c>, and
 * will have no effect.
 *
 * Odometer history is indexed in descending order.  The latest week is
 * indexed <c>0</c>, the week before that is <c>1</c>, etc.  The earliest possible
 * week is ::WF_ODOMETER_HISTORY_MAX_SIZE, though history for this week is not
 * necessarily available.
 *
 * The device will return all available odometer history between the starting and
 * ending indices, inclusive.
 *
 * @param ucStart The index of the latest week for which odometer history should
 * be retrieved.
 *
 * @param ucEnd The index of the earliest week for which odometer history should
 * be retrieved.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestOdometerHistoryFrom:(UCHAR)ucStart to:(UCHAR)ucEnd;

/**
 * Sends a request to reset the odometer value on the device.
 *
 * @note This method is only available for BTLE speed and cadence devices.  For
 * other types, this method will return <c>FALSE</c>, and will have no effect.
 *
 * The device odometer will be reset to the specified value.
 *
 * @note For Wahoo Fitness BlueSC devices, this command will also clear the
 * odometer history.
 *
 * @param resetVal The value to which the odometer will be reset.  This value is
 * interpreted based on the current WFConnectorSettings values for metric and
 * bike wheel circumference.  If WFConnectorSettings::useMetricUnits is <c>TRUE</c>,
 * the value will be interpreted as kilometers, otherwise it will be interpreted
 * as miles.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestOdometerReset:(float)resetVal;

/**
 * Sends a command to the CSC device.
 *
 * @note This method is only available for Wahoo Fitness BlueSC BTLE speed and
 * cadence devices.  For other types, this method will return <c>FALSE</c>, and
 * will have no effect.
 *
 * @param opCode The type of command to be sent.
 * @param op The operator for the command.
 * @param operands The operands for the command.  This value is variable length,
 * and the contents are dependent on the command (<c>opCode</c>).  For some
 * commands, this value may be <c>nil</c>.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)sendRecordCommand:(WFBTLEWahooCSCOpCode_t)opCode withOperator:(WFBTLERecordOperator_t)op operands:(NSData*)operands;

/**
 * Sets the time on a Wahoo Fitness BlueSC device.
 *
 * This method is called internally when the device connects.
 *
 * @note This method is only available for Wahoo Fitness BlueSC BTLE speed and
 * cadence devices.  For other types, this method will return <c>FALSE</c>, and
 * will have no effect.
 *
 * @return <c>TRUE</c> if the request to set the device time was sent successfully,
 * otherwise <c>FALSE</c>.
 */
- (BOOL)setDeviceTime;

@end
