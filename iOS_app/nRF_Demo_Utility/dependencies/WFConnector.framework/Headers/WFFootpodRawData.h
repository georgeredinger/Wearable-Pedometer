//
//  WFFootpodRawData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

@class WFCommonData;


/**
 * Represents the raw data available from the ANT+ Stride sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFFootpodRawData combines the
 * more advanced (less commonly used) of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 */
@interface WFFootpodRawData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	WFCommonData* commonData;
	float lastTime;
	float distance;
	float instantaneousSpeed;
	UCHAR strideCount;
	UCHAR latency;
	float cadence;
	UCHAR moduleLocation;
	UCHAR unitHealth;
	UCHAR useState;
	
	/** \endcond */
}


/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, readonly) WFCommonData* commonData;
/**
 * The time of the last distance and/or speed computation.
 *
 * Time starts when SDM is powered ON and continues until it is powered OFF.
 * The integral component of the time data from the sensor is a single byte.
 * Therefore, the time value will roll over after 256 seconds.  This should
 * be taken into account when calculating time offsets.
 */
@property (nonatomic, assign) float lastTime;
/**
 * The current distance in meters.
 *
 * The integral component of the distance value is sent from the sensor as
 * a single byte.  Therefore, the distance value will roll over after 256
 * meters.  This should be taken into account when calculating accumulated
 * distance measurements.
 */
@property (nonatomic, assign) float distance;
/**
 * The instantaneous speed in meters per second.
 */
@property (nonatomic, assign) float instantaneousSpeed;
/**
 * The current stride count.
 *
 * The stride count is a single byte value which rolls over after 255
 * strides.
 */
@property (nonatomic, assign) UCHAR strideCount;
/**
 * The time elapsed between the last speed and distance computation and the
 * current measurement.
 *
 * The resolution of this value is 1/32 second.
 */
@property (nonatomic, assign) UCHAR latency;
/**
 * The measure of strides accumulated in time (strides per minute).
 */
@property (nonatomic, assign) float cadence;
/**
 * The location of the sensor device.
 *
 * This value uses two bits of data.  The values are: 00 Laces, 01 Midsole,
 * 10 Chest, and 11 Other.
 */
@property (nonatomic, assign) UCHAR moduleLocation;
/**
 * The health status of the device.
 *
 * This value uses two bits of data.  The values are:  00 OK, 01 Error, and
 * 10 Warning.
 */
@property (nonatomic, assign) UCHAR unitHealth;
/**
 * The current use state of the device.
 *
 * This value uses two bits of data.  The values are: 00 Inactive and
 * 01 Active (the other two values are currently not specified).
 */
@property (nonatomic, assign) UCHAR useState;

@end

