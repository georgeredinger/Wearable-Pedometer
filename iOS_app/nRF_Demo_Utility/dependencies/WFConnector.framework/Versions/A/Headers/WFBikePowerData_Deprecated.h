//
//  WFBikePowerData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>
#include <AvailabilityMacros.h>

/**
 * Represents the most commonly used data available from the ANT+ Bike Power sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikePowerData combines the
 * most commonly used of this data into a single entity.  The data represents
 * the latest of each data type sent from the sensor.
 *
 * The methods in this class have been deprecated and replaced with new properties
 * that cover both ANT+ and BTLE power sensors. These properties will remain to 
 * work with ANT+ sensors but will not return any values for BTLE power sensors.
 */
@interface WFBikePowerData_Deprecated : WFSensorData
{
	/** \cond InterfaceDocs */
	
    
    /* DEPREACTED IVARS */
    WFBikePowerType_t sensorType;
	float fpAccumulatedTorque;
    float fpAccumulatedPower;
	ULONG ulAccumulatedTicks;
	float fpCalculatedCrankTicks;
	UCHAR ucInstCadence;
	ULONG ulAveragePower;
	UCHAR ucEventCount;
	NSTimeInterval timestamp;
	BOOL timestampOverflow;
	
	/** \endcond */
}


/**
 * Indicates the type of the power meter.
 *
 * @note After the sensor connects, or is reset, it will take several
 * messages from the device before the sensor type can be determined.
 *
 */
@property (nonatomic, assign) WFBikePowerType_t sensorType DEPRECATED_ATTRIBUTE;
/**
 * The total accumulated torque in Nm.
 *
 * Accumulated torque is the sum of the average torque for each update period.
 * For example, in wheel-based power sensors, it is the sum of the average
 * torque for each wheel revolution.
 *
 * @note The accumulator is initialized when the sensor is first connected, and
 * reset via the WFHardwareConnector::resetAllSensorData method.
 * 
 * DEPRECATED - Please use accumulatedTorque property.
 */
@property (nonatomic, assign) float fpAccumulatedTorque DEPRECATED_ATTRIBUTE;


/**
 * The total accumulated power in Watts
 *
 * Accumlated power is the sum of the average torgue for each update period.
 * This is ONLY used for Power Only sensors, all other power meter types
 * use fpAccumulatedTorque
 *
 * DEPRECATED - Please use accumulatedPower property.
 */
@property (nonatomic, assign) float fpAccumulatedPower DEPRECATED_ATTRIBUTE;

/**
 * The total accumulated revolutions measured by the sensor.
 *
 * This source of this value depends on the sensor type.  The value will be
 * wheel revolutions for wheel-based sensors, and crank revolutions for
 * crank based sensors.
 *
 * DEPRECATED - Please use accumulatedEventCount property.
 */
@property (nonatomic, assign) ULONG ulAccumulatedTicks DEPRECATED_ATTRIBUTE;
/**
 * The total calculated crank revolutions.
 *
 * This value is available only for certain types of wheel-based sensors.
 *
 * DEPRECATED - Please use crankRevolutions property.
 */
@property (nonatomic, assign) float fpCalculatedCrankTicks DEPRECATED_ATTRIBUTE;
/**
 * The instantaneous crank cadence, in RPM.
 *
 * DEPRECATED - Please use instantCadence property.
 */
@property (nonatomic, assign) UCHAR ucInstCadence DEPRECATED_ATTRIBUTE;
/**
 * The average power measured over the last revolution.
 *
 * The span of this value depends on the type of sensor (wheel revolution for
 * wheel-based sensors, and crank revolution for crank-based sensors).
 *
 * DEPRECATED - Please use instantPower property.
 */
@property (nonatomic, assign) ULONG ulAveragePower DEPRECATED_ATTRIBUTE;
/**
 * The event counter value.
 *
 * See the event counter value of the specific power meter type for more
 * about this value (WFBikePowerCTFData, WFBikePowerCrankTorqueData,
 * and WFBikePowerWheelTorqueData).
 */
@property (nonatomic, assign) UCHAR ucEventCount DEPRECATED_ATTRIBUTE;
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
 *
 * DEPRECATED - Please use accumulatedTimestamp property.
 */
@property (nonatomic, assign) NSTimeInterval timestamp DEPRECATED_ATTRIBUTE;
/**
 * Indicates that the time between data samples from the sensor has
 * exceeded the rollover time (64 seconds).
 *
 * DEPRECATED - Please use accumulatedTimestampOverflow property.
 */
@property (nonatomic, assign) BOOL timestampOverflow DEPRECATED_ATTRIBUTE;


@end
