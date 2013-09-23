//
//  WFBikePower2Data.h
//  WFConnector
//
//  Created by Murray Hughes on 15/08/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>
#include <AvailabilityMacros.h>
#import <WFConnector/WFBikePowerData_Deprecated.h>

/**
 * Represents the most commonly used data available from the Bike Power sensor.
 *
 * The WFBikePowerData combines the most commonly used of this data into a single 
 * entity.  The data represents the latest of each data type sent from the sensor.
 *
 * @note As of 2.3.0 all the old properties for WFBikePowerData have been deprecated
 * in order to replaced them with new properties that apply to both ANT+ and BTLE
 * sensors. The old properties will remain to work with ANT+ sensors but will not
 * return any data when using a BTLE power sensor. It is recomend that you move
 * to the new properties.
 */
@interface WFBikePowerData : WFBikePowerData_Deprecated
{
    SSHORT instantPower;
    USHORT instantCadence;
	USHORT instantWheelRPM;
    
    double accumulatedTorque;
    double accumulatedPower;
    ULONG accumulatedEventCount;
    ULONG accumulatedEventTime;
	NSTimeInterval accumulatedTimestamp;
	BOOL accumulatedTimestampOverflow;
    
    BOOL crankRevolutionSupported;
	ULONG crankRevolutions;
	ULONG crankEventTime;
	NSTimeInterval crankTimestamp;
	BOOL crankTimestampOverflow;
    
    BOOL wheelRevolutionSupported;
	ULONG wheelRevolutions;
	ULONG wheelEventTime;
	NSTimeInterval wheelTimestamp;
	BOOL wheelTimestampOverflow;
    
    NSTimeInterval lastWheelDataTime;
    NSTimeInterval lastCadenceDataTime;
    
}


// -----------------------------------------------------------------------------
// -- Popular Data
// -----------------------------------------------------------------------------


/**
 * The instantaneous power
 */
@property (nonatomic, assign) SSHORT instantPower;  

/**
 * The instantaneous cadence (crank RPM), based on the last two sensor measurements.
 */
@property (nonatomic, assign) USHORT instantCadence;

/**
 * The instantaneous wheel RPM, based on the last two sensor measurements.
 */
@property (nonatomic, assign) USHORT instantWheelRPM;


/**
 * The total accumulated torque in Nm.
 *
 * Accumulated torque is the sum of the average torque for each event.
 * For example, in wheel-based power sensors, it is the sum of the average
 * torque for each wheel revolution.
 *
 * If the sensor does not use torque, this value will be calculated from
 * instant / average power.
 *
 * @note The accumulator is initialized when the sensor is first connected, and
 * reset via the WFHardwareConnector::resetAllSensorData method.
 */
@property (nonatomic, assign) double accumulatedTorque;


/**
 * The total accumulated power in Watts
 *
 * Accumulated power is the sum of the average power for each event.
 * For example, in wheel-based power sensors, it is the sum of the average
 * power for each wheel revolution
 *
 * If availible this will be calcualted using Torque, otherwise it will be
 * calculated using Instant/Average Power
 *
 * @note The accumulator is initialized when the sensor is first connected, and
 * reset via the WFHardwareConnector::resetAllSensorData method.

 */
@property (nonatomic, assign) double accumulatedPower;

/**
 * The total number of events accumated
 * 
 * For example, in wheel-based power sensor, it is the total number
 * of wheel revolutions.
 *
 * @note The accumulator is initialized when the sensor is first connected, and
 * reset via the WFHardwareConnector::resetAllSensorData method.
 */
@property (nonatomic, assign) ULONG accumulatedEventCount;

/**
 * The accumulated event time as of the latest wheel or crank revolution.
 *
 * The event time represents a relative time offset as reported by the sensor.
 * This value is not a realtime value, but is an offset analogous to a stopwatch.
 * The value is updated on each wheel or crank revolution (depending on sensor
 * type).  This value is useful for determining the time offset, or period between
 * successive revolutions.  The value is in 1/2048 second resolution.
 *
 * For a realtime timestamp, use WFBikePowerData::accumulatedTimestamp instead.
 */
@property (nonatomic, assign) ULONG accumulatedEventTime;

/**
 * The real-time timestamp for accumulated data from the sensor (as an offset
 * from the Cocoa reference date).
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
@property (nonatomic, assign) NSTimeInterval accumulatedTimestamp;

/**
 * Indicates that the time between samples from the sensor has
 * exceeded the rollover time (64 seconds).
 */
@property (nonatomic, assign) BOOL accumulatedTimestampOverflow;


// -----------------------------------------------------------------------------
// -- Crank Revs
// -----------------------------------------------------------------------------

/**
 * Returns YES if the connected sensor supports Crank Revolutions (Cadence)
 */
@property (nonatomic, assign, getter = isCrankRevolutionSupported) BOOL crankRevolutionSupported;

/**
 * The accumulated crank revolutions since the sensor was connected or reset.
 */
@property (nonatomic, assign) ULONG crankRevolutions;

/**
 * The accumulated crank event time as of the latest crank revolution.
 *
 * The event time represents a relative time offset as reported by the sensor.
 * This value is not a realtime value, but is an offset analogous to a stopwatch.
 * The value is updated on each wheel or crank revolution (depending on sensor
 * type).  This value is useful for determining the time offset, or period between
 * successive revolutions.  The value is in 1/2048 second resolution.
 *
 * For a realtime timestamp, use WFBikePowerData::crankTimestamp instead.
 */
@property (nonatomic, assign) ULONG crankEventTime;

/**
 * The real-time timestamp for crank data from the sensor (as an offset
 * from the Cocoa reference date).
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
@property (nonatomic, assign) NSTimeInterval crankTimestamp;

/**
 * Indicates that the time between cadence data samples from the sensor has
 * exceeded the rollover time (64 seconds).
 */
@property (nonatomic, assign) BOOL crankTimestampOverflow;


// -----------------------------------------------------------------------------
// -- Wheel Revs
// -----------------------------------------------------------------------------

/**
 * Returns YES if the connected sensor supports Wheel Revolutions (Speed/Distance)
 */
@property (nonatomic, assign, getter = isWheelRevolutionSupported) BOOL wheelRevolutionSupported;

/**
 * The accumulated wheel revolutions since the sensor was connected or reset.
 */
@property (nonatomic, assign) ULONG wheelRevolutions;

/**
 * The accumulated crank event time as of the latest crank revolution.
 *
 * The event time represents a relative time offset as reported by the sensor.
 * This value is not a realtime value, but is an offset analogous to a stopwatch.
 * The value is updated on each wheel or crank revolution (depending on sensor
 * type).  This value is useful for determining the time offset, or period between
 * successive revolutions.  The value is in 1/2048 second resolution.
 *
 * For a realtime timestamp, use WFBikePowerData::wheelTimestamp instead.
 */
@property (nonatomic, assign) ULONG wheelEventTime;

/**
 * The real-time timestamp for speed data from the sensor (as an offset
 * from the Cocoa reference date).
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
@property (nonatomic, assign) NSTimeInterval wheelTimestamp;
/**
 * Indicates that the time between speed data samples from the sensor has
 * exceeded the rollover time (64 seconds).
 */
@property (nonatomic, assign) BOOL wheelTimestampOverflow;


// -----------------------------------------------------------------------------
// -- Interface
// -----------------------------------------------------------------------------


/** \cond InterfaceDocs */
/**
 * Initializes a new WFSensorData instance with the specified timestamps.
 *
 * @note This method is for internal use.
 *
 * @param dataTime The data timestamp.
 * @param wheelTime The speed data timestamp.
 * @param cadenceTime The cadence data timestamp.
 *
 * @return The new WFSensorData instance.
 */
- (id)initWithTime:(NSTimeInterval)dataTime wheelTime:(NSTimeInterval)wheelTime cadenceTime:(NSTimeInterval)cadenceTime;
/** \endcond */


// -----------------------------------------------------------------------------
// -- Formatted Values
// -----------------------------------------------------------------------------


/**
 * Returns the cadence as a string formatted for display.
 *
 * @see WFConnectorSettings
 *
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 *
 * @return The formatted display string (cadence in RPMs).
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
 * Returns the speed as a string formatted for display.
 *
 * @see WFConnectorSettings
 *
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 *
 * @return The formatted display string (speed in km/h or MPH).
 */
- (NSString*)formattedSpeed:(BOOL)showUnits;

/**
 * Returns the power as a string formatted for display.
 *
 * @see WFConnectorSettings
 *
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 *
 * @return The formatted display string (power in watts).
 */
- (NSString*)formattedPower:(BOOL)showUnits;


@end
