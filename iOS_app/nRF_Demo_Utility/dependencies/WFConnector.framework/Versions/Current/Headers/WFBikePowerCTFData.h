//
//  WFBikePowerCTFData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the data available from the Crank Torque Frequency type ANT+ Bike Power sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikePowerCTFData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFBikePowerCTFData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	UCHAR  eventCount;                                  
	USHORT slope;
	USHORT timestamp; 
	USHORT torqueTickStamp;
	
	ULONG averageCadence;
	ULONG torqueFrequency;
	ULONG averageTorque;
	ULONG averagePower;
	ULONG accumulatedCrankTicks;
	float accumulatedTorque;
	USHORT calibrationOffset;
	
	/** \endcond */
}


/**
 * Rotation event counter increments with each completed pedal revolution.
 */
@property (nonatomic, assign) UCHAR  eventCount;                                  
/**
 * Slope defines the variation of the output frequency.
 */
@property (nonatomic, assign) USHORT slope;
/**
 * Time of most recent rotation event (1/2000s resolution).
 */
@property (nonatomic, assign) USHORT timestamp; 
/**
 * Count of most recent torque event.
 */
@property (nonatomic, assign) USHORT torqueTickStamp;

/**
 * The average cadence.
 */
@property (nonatomic, assign) ULONG averageCadence;
/**
 * The torque frequency.
 */
@property (nonatomic, assign) ULONG torqueFrequency;
/**
 * The average torque at the crank.
 */
@property (nonatomic, assign) ULONG averageTorque;
/**
 *  The average power, in watts.
 */
@property (nonatomic, assign) ULONG averagePower;
/**
 * The total number of crank revolutions measured since the sensor was
 * connected or reset.
 */
@property (nonatomic, assign) ULONG accumulatedCrankTicks;
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
 * The calibration offset value stored on the sensor.
 *
 * This value is determined by the device during calibration, and returned
 * in response to a calibration request.  This value should be stored at
 * the application level, and used when initializing the sensor.  This
 * is done via the WFHardwareConnector::setBikePowerCalibrationOffset: method.
 */
@property (nonatomic, assign) USHORT calibrationOffset;

@end
