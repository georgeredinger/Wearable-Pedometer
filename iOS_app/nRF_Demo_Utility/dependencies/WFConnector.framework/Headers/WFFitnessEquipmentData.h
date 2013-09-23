//
//  WFFitnessEquipmentData.h
//  WFConnector
//
//  Created by Michael Moore on 12/21/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the most commonly used data available from the ANT+ Fitness Equipment sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFFitnessEquipmentData combines the
 * most commonly used of this data into a single entity.  The data represents
 * the latest of each data type sent from the sensor.
 */
@interface WFFitnessEquipmentData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	// general FE data.
	WFFitnessEquipmentType_t equipmentType;
	WFFitnessEquipmentState_t equipmentState;
	float accumTime;
	ULONG accumDistance;
	float instSpeed;
	UCHAR heartrate;
    ULONG heartrateAccumBeatCount;
    NSTimeInterval heartrateTimestamp;
	UCHAR lapNumber;
    float lastLapAccumTime;
	
	// equipment specific: treadmill.
	UCHAR treadmillCadence;
	float treadmillAccumNegVertDist;
	float treadmillAccumPosVertDist;
	
	// equipment specific: elliptical.
	float  ellipticalAccumPosVertDist;
	ULONG  ellipticalAccumStrides;
	UCHAR  ellipticalCadence;
	USHORT ellipticalInstPower;
	
	// equipment specific: bike.
	UCHAR  bikeCadence;
    NSTimeInterval bikeCadenceTimestamp;
    ULONG bikeAccumCrankRevolutions;
	USHORT bikeInstPower;
    float bikeAccumTorque;
    NSTimeInterval bikeTimestamp;
	
	// equipment specific: rower.
	ULONG  rowerAccumStrokes;
	UCHAR  rowerCadence;
	USHORT rowerInstPower;

	UCHAR debugRawElapsedTime;
    UCHAR debugNewElapsedTime;
    UCHAR debugRawElapsedDistance;
    USHORT debugRawSpeed;

	/** \endcond */
}


// general FE data.


/**
 * The type of the connected Fitness Equipment device.
 */
@property (nonatomic, assign) WFFitnessEquipmentType_t equipmentType;
/**
 * The current state of the connected Fitness Equipment device.
 */
@property (nonatomic, assign) WFFitnessEquipmentState_t equipmentState;
/**
 * The accumulated time since the workout was started, in seconds.
 */
@property (nonatomic, assign) float accumTime;



/**
 * The accumulated distance, in meters, since the workout was started.
 */
@property (nonatomic, assign) ULONG accumDistance;
/**
 * The instantaneous speed, in meters per second.
 */
@property (nonatomic, assign) float instSpeed;
/**
 * The instantaneous heart rate, in BPM.
 */
@property (nonatomic, assign) UCHAR heartrate;
/**
 * The calcualted accumulated heart rate, in BPM. (estamated based on instant HR)
 */
@property (nonatomic, assign) ULONG heartrateAccumBeatCount;

/**
 * Timestamp of the last received bike cadence data
 */
@property (nonatomic, assign) NSTimeInterval heartrateTimestamp;

/**
 * The current lap number.
 */
@property (nonatomic, assign) UCHAR lapNumber;
/**
 * The total accumulated time at the last lap event
 */
@property (nonatomic, assign) float lastLapAccumTime;


// equipment specific: treadmill.

/**
 * The instantaneous cadence, in strides per minute.
 */
@property (nonatomic, assign) UCHAR treadmillCadence;
/**
 * The total negative vertial distance traveled, in meters.
 */
@property (nonatomic, assign) float treadmillAccumNegVertDist;
/**
 * The total positive vertical distance traveled, in meters.
 */
@property (nonatomic, assign) float treadmillAccumPosVertDist;

// equipment specific: elliptical.

/**
 * The total positive vertical distance traveled, in meters.
 */
@property (nonatomic, assign) float  ellipticalAccumPosVertDist;
/**
 * The total number of strides taken.
 */
@property (nonatomic, assign) ULONG  ellipticalAccumStrides;
/**
 * The instantaneous cadence, in strides per minute.
 */
@property (nonatomic, assign) UCHAR  ellipticalCadence;
/**
 * The instantaneous power, in watts.
 */
@property (nonatomic, assign) USHORT ellipticalInstPower;

// equipment specific: bike.

/**
 * The instantaneous cadence, in RPMs.
 */
@property (nonatomic, assign) UCHAR  bikeCadence;

/**
 * Timestamp of the last received bike cadence data
 */
@property (nonatomic, assign) NSTimeInterval bikeCadenceTimestamp;



/**
 * The accumulated crank revolutions since the sensor was connected or reset.
 */
@property (nonatomic, assign) ULONG bikeAccumCrankRevolutions;
/**
 * The instantaneous power, in watts.
 */
@property (nonatomic, assign) USHORT bikeInstPower;
/**
 * The estimated accumative torque (esimated based on inst power
*/
@property (nonatomic, assign) float bikeAccumTorque;
/**
 * Timestamp of the last received bike specific data
 */
@property (nonatomic, assign) NSTimeInterval bikeTimestamp;



// equipment specific: rower.

/**
 * The total stroke count.
 */
@property (nonatomic, assign) ULONG  rowerAccumStrokes;
/**
 * The instantaneous cadence, in strokes per minute.
 */
@property (nonatomic, assign) UCHAR  rowerCadence;
/**
 * The instantaneous power, in watts.
 */
@property (nonatomic, assign) USHORT rowerInstPower;


// Debug
@property (nonatomic, assign) UCHAR debugRawElapsedTime;
@property (nonatomic, assign) UCHAR debugNewElapsedTime;
@property (nonatomic, assign) UCHAR debugRawElapsedDistance;
@property (nonatomic, assign) USHORT debugRawSpeed;

@end
