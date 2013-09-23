//
//  WFBTLEBikeSpeedCadenceData.h
//  WFConnector
//
//  Created by Michael Moore on 3/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFBikeSpeedCadenceData.h"
#import "wf_btle_types.h"


@class WFBTLECommonData;
@class WFWahooCSCData;


/**
 * Represents the data available from the BTLE Bike Speed and Cadence sensor.
 *
 * BTLE sensors send data in multiple packets.  The WFBTLEBikeSpeedCadenceData
 * combines the most commonly used of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 *
 * @note The WFBTLEBikeSpeedCadenceData is an extension of the WFBikeSpeedCadenceData
 * class.  This class is specific to the data available from the BTLE speed and
 * cadence sensors.  Much of the data is the same as that available from the
 * ANT+ speed and cadence sensors.  The Wahoo Fitness Speed and Cadence sensors
 * provide data beyond that specified by the BTLE CSC profile.  This data is
 * available through the WFBTLEBikeSpeedCadenceData::wahooData property.  If the
 * connected sensor is a non-Wahoo sensor, this data is not available.
 */
@interface WFBTLEBikeSpeedCadenceData : WFBikeSpeedCadenceData
{
	/** \cond InterfaceDocs */
	
    BOOL hasFeatures;
    
    WFBTLECommonData* btleCommonData;
    ULONG ulOdometerWheelRevolutions;
    WFWahooCSCData* wahooData;
    
    WFBTLECSCFeatures_t stFeatures;
    WFBTLESensorLocation_t eSensorLocation;
    
	/** \endcond */
}


/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;
/** Gets the total wheel revolutions for the device, since the last reset. */
@property (nonatomic, assign) ULONG ulOdometerWheelRevolutions;
/**
 * Gets the additional data available from Wahoo Fitness BTLE CSC devices.
 *
 * @note This property is only available for Waho Fitness BTLE Bike Speed and
 * Cadence devices.  For all other devices, this property will be <c>nil</c>.
 */
@property (nonatomic, retain) WFWahooCSCData* wahooData;
/**
 * Gets a pointer to a ::WFBTLECSCFeatures_t structure which contains information
 * about the device features.
 *
 * @note If the sensor does not report features, this property will be <c>nil</c>.
 */
@property (nonatomic, readonly) WFBTLECSCFeatures_t* pstFeatures;
/** Gets a ::WFBTLESensorLocation_t which describes the sensor location. */
@property (nonatomic, assign) WFBTLESensorLocation_t eSensorLocation;


/** \cond InterfaceDocs */
/**
 * Initializes a new WFSensorData instance with the specified timestamps.
 *
 * @note This method is for internal use.
 *
 * @param dataTime The data timestamp.
 * @param wheelTime The speed data timestamp.
 * @param cadenceTime The cadence data timestamp.
 * @param bFeatures A boolean value indicating whether the features are available.
 *
 * @return The new WFSensorData instance.
 */
- (id)initWithTime:(NSTimeInterval)dataTime wheelTime:(NSTimeInterval)wheelTime cadenceTime:(NSTimeInterval)cadenceTime hasFeatures:(BOOL)bFeatures;
/** \endcond */


@end
