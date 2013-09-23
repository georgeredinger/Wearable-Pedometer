//
//  WFBikePowerWheelTorqueData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the data available from the Wheel Torque type ANT+ Bike Power sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikePowerWheelTorqueData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFBikePowerWheelTorqueData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	UCHAR eventCount;                                  
	UCHAR wheelTicks;
	UCHAR instantCadence;                                 
	ULONG accumulatedWheelPeriod; 
	float accumulatedTorque;
	ULONG accumulatedWheelTicks;
	float calculatedCrankTicks;
	
	ULONG averageSpeed;
	ULONG distance;
	ULONG angularVelocity;
	ULONG averageTorque;
	ULONG averagePower;
	USHORT wheelRPM;
	
	/** \endcond */
}


/**
 * Event counter increments with each information update.
 */
@property (nonatomic, assign) UCHAR eventCount;                                  
/**
 * Wheel tick count increments with each wheel revolution.
 */
@property (nonatomic, assign) UCHAR wheelTicks;
/**
 * Wheel cadence (RPMs) – if available. Otherwise: 0xFF indicates invalid.
 */
@property (nonatomic, assign) UCHAR instantCadence;                                 
/**
 * Accumulated wheel period (updated each event).
 */
@property (nonatomic, assign) ULONG accumulatedWheelPeriod; 
/**
 * The total accumulated torque in Nm.
 *
 * Accumulated torque is the sum of the average torque for each update period.
 * For example, in wheel-based power sensors, it is the sum of the average
 * torque for each wheel revolution.
 *
 * @note The accumulator is initialized when the sensor is first connected, and
 * reset via the WFHardwareConnector::resetAllSensorData method.
 */
@property (nonatomic, assign) float accumulatedTorque;
/**
 * The total number of wheel revolutions measured since the sensor was
 * connected or reset.
 */
@property (nonatomic, assign) ULONG accumulatedWheelTicks;
/**
 * The total number of crank revolutions measured since the sensor was
 * connected or reset.
 *
 * @note This value is not availabe from all power meters.  The value
 * is not directly measured by the sensor, but calculated based on
 * the torque curve.
 */
@property (nonatomic, assign) float calculatedCrankTicks;

/**
 * The average speed, in meters per second.
 *
 * @note This value assumes a wheel circumference of 2 meters (200cm).
 */
@property (nonatomic, assign) ULONG averageSpeed;
/**
 * Total distance traveled, in meters.
 *
 * @note This value assumes a wheel circumference of 2 meters (200cm).
 */
@property (nonatomic, assign) ULONG distance;
/**
 * The angular velocity of the wheel.
 */
@property (nonatomic, assign) ULONG angularVelocity;
/**
 * The average torque at the wheel.
 */
@property (nonatomic, assign) ULONG averageTorque;
/**
 * The average power, in watts.
 */
@property (nonatomic, assign) ULONG averagePower;
/**
 * The instantaneous wheel RPM.
 */
@property (nonatomic, assign) USHORT wheelRPM;

@end
