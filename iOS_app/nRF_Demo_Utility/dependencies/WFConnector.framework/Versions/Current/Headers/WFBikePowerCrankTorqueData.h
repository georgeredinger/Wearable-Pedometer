//
//  WFBikePowerCrankTorqueData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the data available from the Crank Torque type ANT+ Bike Power sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikePowerCrankTorqueData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFBikePowerCrankTorqueData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	UCHAR eventCount;                                  
	UCHAR crankTicks;
	UCHAR instantCadence;                                 
	ULONG accumulatedCrankPeriod; 
	float accumulatedTorque;
	ULONG accumulatedCrankTicks;
	ULONG averageCadence;
	ULONG angularVelocity;
	ULONG averageTorque;
	ULONG averagePower;
	
	/** \endcond */
}


/**
 * Event counter increments with each information update.
 */
@property (nonatomic, assign) UCHAR  eventCount;                                  
/**
 * Crank ticks increment with each crank revolution.
 */
@property (nonatomic, assign) UCHAR  crankTicks;
/**
 * Crank cadence (RPMs) – if available, Otherwise: 0xFF.
 */
@property (nonatomic, assign) UCHAR  instantCadence;                                 
/**
 * Accumulated crank period (updated each event).
 */
@property (nonatomic, assign) ULONG accumulatedCrankPeriod; 
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
 * The total number of crank revolutions measured since the sensor was
 * connected or reset.
 */
@property (nonatomic, assign) ULONG accumulatedCrankTicks;

/**
 * The average cadence, in RPMs.
 */
@property (nonatomic, assign) ULONG averageCadence;
/**
 * The angular velocity of the crank.
 */
@property (nonatomic, assign) ULONG angularVelocity;
/**
 * The average torque at the crank.
 */
@property (nonatomic, assign) ULONG averageTorque;
/**
 * The average power, in watts.
 */
@property (nonatomic, assign) ULONG averagePower;

@end
