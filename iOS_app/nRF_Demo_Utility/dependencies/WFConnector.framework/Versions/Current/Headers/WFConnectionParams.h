//
//  WFConnectionParams.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>

@class WFDeviceParams;


/**
 * Represents the connection parameters used to establish a connection to an
 * ANT device.
 *
 * Up to four devices may be specified in the connection parameters.  The API
 * will search until one of the devices is found, or the timeout expires.  If
 * no devices are specified, a wildcard search is performed.
 */
@interface WFConnectionParams : NSObject
{
	/** \cond InterfaceDocs */

	int deviceIndex;
	WFSensorType_t sensorType;
    WFNetworkType_t specifiedNetwork;
	USHORT searchTimeout;
	WFDeviceParams* device1;
	WFDeviceParams* device2;
	WFDeviceParams* device3;
	WFDeviceParams* device4;
    
    NSData* conditionalData;
    WFComparisonType_t conditionalComparisonType;
	
	/** \endcond */
}


/**
 * The first of four possible devices to connect.
 */
@property (nonatomic, retain) WFDeviceParams* device1;

/**
 * The second of four possible devices to connect.
 */
@property (nonatomic, retain) WFDeviceParams* device2;

/**
 * The third or four possible devices to connect.
 */
@property (nonatomic, retain) WFDeviceParams* device3;

/**
 * The fourth of four possible devices to connect.
 */
@property (nonatomic, retain) WFDeviceParams* device4;

/**
 * Specifies the type of comparison to use for conditional connection.
 *
 * @note This property is for internal use, and should not be assigned directly.
 */
@property (nonatomic, assign) WFComparisonType_t conditionalComparisonType;
/**
 * Gets or sets the data used to determine whether a conditional connection will
 * be established or not.
 *
 * @note This property is for internal use, and should not be assigned directly.
 */
@property (nonatomic, retain) NSData* conditionalData;

/**
 * <c>TRUE</c> if the params specify a conditional connection, otherwise <c>FALSE</c>.
 *
 * @see WFConnectionParams::conditionalData
 */
@property (nonatomic, readonly) BOOL isConnectionConditional;

/**
 * Returns a boolean value indicating whether this WFConnectionParams is
 * configured for a wildcard search.
 *
 * @return <c>TRUE</c> if a wildcard search is specified, otherwise <c>FALSE</c>.
 */
@property (nonatomic, readonly) BOOL isWildcard;

/**
 * Gets or sets the network type specified by this WFConnectionParams.
 *
 * @note Setting this property is only valid in the context of a wildcard search.
 * If any of the four WFDeviceParams (<c>deviceX</c>) properties are set, the value
 * of this property is derived from the WFDeviceParams::networkType of the specified
 * device params.
 */
@property (nonatomic, assign) WFNetworkType_t networkType;

/**
 * Specifies the search timeout, in seconds.
 */
@property (nonatomic, assign) USHORT searchTimeout;

/**
 * Specifies the type of sensor to be connected.
 */
@property (nonatomic, assign) WFSensorType_t sensorType;


/**
 * Returns a boolean value indicating whether the specified device ID is
 * specified in any of the device parameters.
 *
 * @param devNumber The device ID to check.
 *
 * @return <c>TRUE</c> if the specified device ID is included in this
 * WFConnectionParameters, otherwise <c>FALSE</c>.
 */
- (BOOL)hasDeviceNumber:(USHORT)devNumber;

/**
 * Returns a boolean value indicating whether the specified device UUID is
 * specified in any of the device parameters.
 *
 * @param uuidString The device UUID string to check.
 *
 * @return <c>TRUE</c> if the specified device UUID is included in this
 * WFConnectionParameters, otherwise <c>FALSE</c>.
 */
- (BOOL)hasDeviceUUID:(NSString*)uuidString;

@end
