//
//  WFFisicaInfo.h
//  WFConnector
//
//  Created by Michael Moore on 9/14/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>


/**
 * Represents information describing the properties and capabilities of the
 * currently connected fisica device.
 */
@interface WFFisicaInfo : NSObject
{
	/** \cond InterfaceDocs */
	
    ULONG serialNumber;
    ULONG firmwareVersion;
    NSString* model;
    
	UCHAR maxAntConnections;
	BOOL supportsAntFSClient;
	BOOL supportsFitnessEquipment;
    BOOL supportsProximitySearch;
    
	/** \endcond */
}

/** Gets the fisica device serial number. */
@property (nonatomic, assign) ULONG serialNumber;
/**
 * Gets the fisica device firmware version.
 *
 * The firmware version is encoded in the lower three bytes:<br />
 * B2:  The major version number.<br />
 * B1:  The minor version number.<br />
 * B0:  The revision number.
 */
@property (nonatomic, assign) ULONG firmwareVersion;
/** Gets the fisica device model name. */
@property (nonatomic, retain) NSString* model;

/** Gets the maximum number of ANT devices which may be connected at one time. */
@property (nonatomic, assign) UCHAR maxAntConnections;
/** <c>TRUE</c> if the fisica hardware supports ANT FS Client mode, otherwise <c>FALSE</c>. */
@property (nonatomic, assign) BOOL supportsAntFSClient;
/** <c>TRUE</c> if the fisica hardware supports Fit1e enabled Fitness Equipment, otherwise <c>FALSE</c>. */
@property (nonatomic, assign) BOOL supportsFitnessEquipment;
/**
 * <c>TRUE</c> if the fisica hardware supports proximity search, otherwise <c>FALSE</c>.
 *
 * @see WFHardwareConnector::requestSensorConnection:withProximity:
 */
@property (nonatomic, assign) BOOL supportsProximitySearch;


/** \cond InterfaceDocs */
/**
 * Initializes a new WFFisicaInfo instance as a copy of the specified original.
 *
 * @note This method is for internal use.
 *
 * @param original The WFFisicaInfo instance to be copied.
 *
 * @return The new WFFisicaInfo instance.
 */
- (id)initAsCopy:(WFFisicaInfo*)original;
/** \endcond */

@end
