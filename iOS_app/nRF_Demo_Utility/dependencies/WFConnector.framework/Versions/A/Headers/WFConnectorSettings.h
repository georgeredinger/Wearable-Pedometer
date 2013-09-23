//
//  WFConnectorSettings.h
//  WFConnector
//
//  Created by Michael Moore on 9/6/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>

@class WFConnectionParams;
@class WFSensorConnection;
@class WFDeviceParams;


/**
 * Provides a means of persisting settings for the WFConnector.
 *
 * This class provides methods to store and retrieve connection parameters for
 * paired sensors.  When a new connection is made, the WFSensorConnection for
 * that connection can be passed to the WFConnectorSettings::saveConnectionInfo:
 * method.  This method will persist the connection parameters for use in
 * connection requests at a later time.  The
 * WFConnectorSettings::connectionParamsForSensorType: method is used to retrieve
 * these connection parameters (for up to four previously-paired devices).
 */
@interface WFConnectorSettings : NSObject
{
	/** \cond InterfaceDocs */
	
    NSString* settingsDirectory;
	NSMutableDictionary* settingsRoot;
    
	/** \endcond */
}


/**
 * The bike coasting timeout, in seconds.
 * 
 * If no data is received for this duration, the bike is considered to
 * be coasting.  When coasting, the data formatters will return the
 * WFConnectorSettings::staleDataString for instantaneous values.
 *
 * @note The default value is 3 seconds.
 */
@property (nonatomic, assign) NSTimeInterval bikeCoastingTimeout;

/**
 * Specifies the bike wheel circumference, in meters.
 * 
 * This value is used to determine speed and distance in the bike sensors.
 *
 * @note The default value is 2.07 m (207 cm).
 */
@property (nonatomic, assign) float bikeWheelCircumference;

/**
 * Gets or sets the search timeout, in seconds.
 *
 * This value may be persisted and used in a connection request to specify
 * the timeout for the searh.
 */
@property (nonatomic, assign) NSTimeInterval searchTimeout;

/**
 * Gets or sets the device discovery timeout, in seconds.
 *
 * This value may be persisted and used in the device discovery request to
 * specify the discovery timeout.
 */
@property (nonatomic, assign) NSTimeInterval discoveryTimeout;

/**
 * The string returned by data formatting methods when data for the sensor
 * is considered "stale".
 * 
 * @note The default value is "--".
 *
 * @see WFConnectorSettings::staleDataTimeout
 */
@property (nonatomic, assign) NSString* staleDataString;

/**
 * The stale data timeout, in seconds.
 * 
 * If the time since the latest data was received from the sensor exceeds
 * this value, the data for that sensor will be considered "stale".  In this
 * case, the data formatting methods for that sensor type will return the
 * WFConnectorSettings::staleDataString for instantaneous data types.
 * 
 * An example of a data formatting method for an instantaneous data type is
 * the WFBikeSpeedCadenceData::formattedSpeed:
 * method.  The WFConnectorSettings::staleDataString is used for this type
 * when data is in the "stale" condition.  An example data formatting
 * method for an accumulated data type is the
 * WFBikeSpeedCadenceData.formattedDistance:
 * method.  The value for this type is returned, whether or not data is
 * considered stale.
 *
 * @note The default value is 5 seconds.
 */
@property (nonatomic, assign) NSTimeInterval staleDataTimeout;

/**
 * Specifies whether the data formatting methods use metric units.
 * 
 * If this value is <c>true</c>, data is formatted using metric units,
 * otherwise, imperial units are used.
 *
 * @note The default value is <c>FALSE</c>.
 */
@property (nonatomic, assign) BOOL useMetricUnits;


/**
 * Retrieves the connection parameters for the specified sensor type.
 *
 * @param sensorType The type of sensor for which to retrieve connection params.
 *
 * @return A WFConnectionParams instance suitable for initiating a connection
 * to any of up to four previously paired sensors.  If no previously paired
 * sensors exist, the WFConnectionParams returned will be suitable for
 * initiating a wildcard connection to the specified sensor type.
 */
- (WFConnectionParams*)connectionParamsForSensorType:(WFSensorType_t)sensorType;

/**
 * Returns an array of device params for the specified sensor type.
 *
 * @param sensorType The type of sensor for which to retrieve params.
 *
 * @return An array of WFDeviceParams representing the connection parameters of
 * up to four previously paired devices.  If no previously paired devices exist,
 * an empty array is returned.
 */
- (NSArray*)deviceParamsForSensorType:(WFSensorType_t)sensorType;

/**
 * Removes the specified connection parameters from the paired sensors store.
 *
 * @param devParams The device connection parameters to be removed.
 *
 * @param sensorType The type of sensor for which the pairing params are to be removed.
 * 
 * @return <c>TRUE</c> if the params were removed, otherwise <c>FALSE</c>.
 */
- (BOOL)removeDeviceParams:(WFDeviceParams*)devParams forSensorType:(WFSensorType_t)sensorType;

/**
 * Saves the parameters for the specified WFSensorConnection in the paired sensor store.
 * 
 * Up to four sensors may be paired for any sensor type.  The latest connection
 * parameters are stored at the top of the array.  When a new connection is saved,
 * in the case where four connections were previously saved, the oldest is dropped.
 * If a connection is saved, but had been saved previously, it is moved to the
 * top of the array.  This essentially means that the four latest connections
 * are stored.
 *
 * @param connectionInfo The connection to be stored.
 *
 * @return <c>TRUE</c> if the params were stored, otherwise <c>FALSE</c>.
 */
- (BOOL)saveConnectionInfo:(WFSensorConnection*)connectionInfo;

@end
