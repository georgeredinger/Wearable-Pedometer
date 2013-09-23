//
//  WFFootpodData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

@class WFCommonData;


/**
 * Represents the most commonly used data available from the ANT+ Stride sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFFootpodData combines the
 * most commonly used of this data into a single entity.  The data represents
 * the latest of each data type sent from the sensor.
 */
@interface WFFootpodData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	float lastTime;
	float instantaneousSpeed;
	float cadence;
	float accumulatedDistance;
	ULONG accumulatedStride;
	NSTimeInterval timestamp;
	BOOL timestampOverflow;
	
	/** \endcond */
}


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
 * The instantaneous speed in meters per second.
 */
@property (nonatomic, assign) float instantaneousSpeed;
/**
 * The measure of strides accumulated in time (strides per minute).
 */
@property (nonatomic, assign) float cadence;
/**
 * The accumulated distance measurement.
 *
 * When available, this value is similar to the WFFootpodRawData::distance
 * value, but with a larger roll over value.
 */
@property (nonatomic, assign) float accumulatedDistance;
/**
 * The accumulated stride count.
 *
 * When available, this value is similar to the WFFootpodRawData::strideCount
 * value, but with a larger roll over value.
 */
@property (nonatomic, assign) ULONG accumulatedStride;
/**
 * The real-time timestamp for data from the sensor (as an offset from
 * the Cocoa reference date).
 *
 * Time values from the sensors are implemented as an offset in seconds
 * between the time when the sensor is turned on and the time when a
 * data sample is taken.  This value is typically a 16-bit unsigned
 * integer in units of 1/1024 second.  The rollover is then 64 seconds.
 *
 * A base real-time value is stored when the first sample from the
 * sensor is received.  The timestamp of each subsequent sample is the
 * base time value offset by the time value offset from the sensor.
 * If the time between samples is greater than the rollover time, the
 * base time value is set to the time the first sample after the delay
 * is received.
 */
@property (nonatomic, assign) NSTimeInterval timestamp;
/**
 * Indicates that the time between data samples from the sensor has
 * exceeded the rollover time (64 seconds).
 */
@property (nonatomic, assign) BOOL timestampOverflow;


/**
 * Returns the cadence as a string formatted for display.
 * 
 * @see WFConnectorSettings
 * 
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 * 
 * @return The formatted display string (cadence in s/m).
 */
- (NSString*)formattedCadence:(BOOL)showUnits;

/**
 * Returns the distance as a string formatted for display.
 * 
 * @see WFConnectorSettings
 * 
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 * 
 * @return The formatted display string (distance in km or miles).
 */
- (NSString*)formattedDistance:(BOOL)showUnits;

/**
 * Returns the pace as a string formatted for display.
 * 
 * @see WFConnectorSettings
 * 
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 * 
 * @return The formatted display string (pace in min/km or min/mile).
 */
- (NSString*)formattedPace:(BOOL)showUnits;

/**
 * Returns the speed as a string formatted for display.
 * 
 * @see WFConnectorSettings
 * 
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 * 
 * @return The formatted display string (speed in m/s or ft/s).
 */
- (NSString*)formattedSpeed:(BOOL)showUnits;

@end
