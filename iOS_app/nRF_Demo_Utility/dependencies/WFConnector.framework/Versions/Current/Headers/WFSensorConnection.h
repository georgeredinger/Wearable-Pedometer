//
//  WFSensorConnection.h
//  WFConnector
//
//  Created by Michael Moore on 10/20/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <WFConnector/_WFSensorConnection.h>
#import <WFConnector/WFSensorConnectionDelegate.h>


#define WF_INVALID_DATA_TIME -1;


/**
 * Represents the connection for an ANT sensor.
 *
 * The WFSensorConnection is the entry point for dealing with an ANT sensor.
 * Once the instance is obtained (via WFHardwareConnector::requestSensorConnection:),
 * it can be used to determine connection state, disconnect, or retrieve data.
 *
 * The pairing procedure is as follows:
 * <ol>
 * <li>Create a new WFConnectionParams instance</li>
 * <li>Specify the WFConnectionParams::sensorType but do not specify any
 * devices.  This will specify a wildcard search.</li>
 * <li>When specifying a wildcard search, optionally set the
 * WFConnectionParams::networkType to limit the search to a specific network.</li>
 * <li>Invoke the WFHardwareConnector::requestSensorConnection: method.</li>
 * <li>The WFSensorConnectionDelegate::connection:stateChanged: method will be
 * invoked when the connection is established.</li>
 * <li>Confirm that the WFSensorConnection::isConnected property is <c>TRUE</c>.</li>
 * <li>Store the WFSensorConnection::deviceNumber,
 * WFSensorConnection::transmissionType,  WFSensorConnection::networkType
 * adn WFSensorConnection::deviceUUIDString values for future connections to this
 * sensor.</li>
 * </ol>
 */
@interface WFSensorConnection : _WFSensorConnection
{
	/** \cond InterfaceDocs */

	id<WFSensorConnectionDelegate> delegate;
	
	/** \endcond */
}


/**
 * Gets the current connection status.
 */
@property (nonatomic, readonly) WFSensorConnectionStatus_t connectionStatus;

/**
 * Specifies the WFSensorConnectionDelegate instance which will handle callback
 * methods for this WFSensorConnection.
 */
@property (nonatomic, retain) id<WFSensorConnectionDelegate> delegate;

/**
 * Returns the Device ID of the connected sensor for both ANT and BTLE
 */
@property (nonatomic, readonly) NSString* deviceIDString;

/**
 * Gets the ANT device ID of the connected sensor.
 */
@property (nonatomic, readonly) USHORT deviceNumber;

/**
 * Specifies the BTLE Device UUID String
 */
@property (nonatomic, readonly) NSString* deviceUUIDString;

/**
 * Gets a boolean value indicating whether a connection timeout occurred.
 */
@property (nonatomic, readonly) BOOL didTimeout;

/** Get the error status for the connection. */
@property (nonatomic, readonly) WFSensorConnectionError_t error;

/**
 * <c>TRUE</c> if the sensor is currently connected, otherwise <c>FALSE</c>.
 */
@property (nonatomic, readonly) BOOL isConnected;

/**
 * <c>TRUE</c> if the sensor is a BTLE device, otherwise <c>FALSE</c>.
 */
@property (nonatomic, readonly) BOOL isBTLEConnection;

/**
 * <c>TRUE</c> if the sensor is a ANT device, otherwise <c>FALSE</c>.
 */
@property (nonatomic, readonly) BOOL isANTConnection;

/**
 * Gets a boolean value indicating whether this WFSensorConnection instance
 * is valid.
 *
 * The WFSensorConnection is invalidated when the sensor is disconnected, or
 * when the API is reset.
 *
 * @note The WFSensorConnection instance returned via the
 * WFHardwareConnector::requestSensorConnection: method should be retained by
 * the application for retrieving data and managing the connection.  The Wahoo
 * API will also maintain a reference to this instance (it may be retrieved by
 * the WFHardwareConnector::getSensorConnections: method).  When the sensor is
 * disconnected, the WFSensorConnection instance is invalidated.  At this point,
 * the Wahoo API will release its reference to the instance.  Once this happens,
 * the instance may not be used to retrieve data, and any properties of the
 * instance will contain spurious values, and should not be used.  An
 * application may check for this state with the WFSensorConnection::isValid property.
 */
@property (nonatomic, readonly) BOOL isValid;

/** <c>TRUE</c> if an error has occured, otherwise <c>FALSE</c>. */
@property (nonatomic, readonly) BOOL hasError;

/**
 * Gets a boolean value indicating whether this WFSensorConnection has valid
 * connection parameters.
 *
 * When the WFSensorConnection is initiated as a wildcard search, the connection
 * parameters (WFSensorConnection::deviceNumber, WFSensorConnection::transmissionType,
 * etc.) are not set to a specific device.  Once the sensor connection is
 * established, the connection parameters will contain values which uniquely
 * identify the connected sensor.  At this point the connection parameters may
 * be persisted and used in the future to establish a connection with this same
 * sensor (pairing).
 * <br /><br />
 *
 * The value of this property is <c>TRUE</c> when the connection parameters are
 * suitable for uniquely identifying a specific sensor.  Otherwise, the value
 * is <c>FALSE</c>.
 *
 * @see WFSensorConnection::hasWildcardParams
 */
@property (nonatomic, readonly) BOOL hasValidParams;

/**
 * Gets a boolean value indicating whether the connection parameters for this
 * WFSensorConnection indicate a wildcard search.
 *
 * @see WFSensorConnection::hasValidParams
 */
@property (nonatomic, readonly) BOOL hasWildcardParams;

/**
 * Specifies the network type of this WFSensorConnection (ANT+, BTLE, etc).
 */
@property (nonatomic, readonly) WFNetworkType_t networkType;

/**
 * Gets the ANT sensor type for this WFSensorConnection.
 */
@property (nonatomic, readonly) WFSensorType_t sensorType;

/**
 * Gets the time since the last ANT message was received (in seconds).
 *
 * <c>WF_INVALID_DATA_TIME</c> if unknown or invalid.
 */
@property (nonatomic, readonly) NSTimeInterval timeSinceLastMessage;

/**
 * Gets the ANT transmission type of the connected sensor.
 */
@property (nonatomic, readonly) UCHAR transmissionType;



/**
 * Disconnects the sensor.
 */
- (void)disconnect;

/**
 * Retrieves the most current data available from the sensor.
 *
 * @note WFSensorData is an abstract base class for all sensor data types.
 * The specific type will be determined by the type of sensor.  The instance
 * returned must be cast to the specific type in order to be useful.
 *
 * @return A WFSensorData derived instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFSensorData*)getData;

/**
 * Retrieves the most current raw data available from the sensor.
 *
 * @note This method will return raw (unformatted) data from the sensor.
 * It is made available for applications which require processing of data
 * as close to the original measured values a possible.  There may be other
 * rarely used data available via this method as well.  For most applications,
 * the WFSensorConnection::getData method should be used instead.
 * <br /><br />
 * WFSensorData is an abstract base class for all sensor data types.
 * The specific type will be determined by the type of sensor.  The instance
 * returned must be cast to the specific type in order to be useful.
 *
 * @return A WFSensorData derived instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFSensorData*)getRawData;

/**
 * Returns a boolean value indicating whether new data is available.
 *
 * @return <c>TRUE</c> if new data is available since the last time
 * WFSensorConnection::getData was invoked, otherwise <c>FALSE</c>.
 */
- (BOOL)hasData;

/**
 * Returns the signal efficiency for the connected sensor.
 *
 * @return For ANT connections, this property represents the ratio of messages
 * received from the sensor over the number of messages expected (range [0, 1.0]).
 * This value should give a good indication of the reception quality for the sensor.
 * For BTLE connections, this property represents the RSSI (in dBm).
 * If the sensor is not currently connected, the return value is <c>-1</c>.
 */
- (float)signalEfficiency;

@end
