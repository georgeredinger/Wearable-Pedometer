//
//  WFBikeCadenceData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the most commonly used data available from the ANT+ Bike Cadence sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikeCadenceData combines the
 * most commonly used of this data into a single entity.  The data represents
 * the latest of each data type sent from the sensor.
 */
@interface WFBikeCadenceData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	ULONG accumCrankRevolutions;
	float accumCadenceTime;
	UCHAR instantCrankRPM;
	NSTimeInterval timestamp;
	BOOL timestampOverflow;
	
	/** \endcond */
}


/**
 * The accumulated crank revolutions since the sensor was connected or reset.
 */
@property (nonatomic, assign) ULONG accumCrankRevolutions;
/**
 * The accumulated time (in seconds) since the sensor was connected or reset.
 */
@property (nonatomic, assign) float accumCadenceTime;
/**
 * The instantaneous crank RPM, based on the last two sensor measurements.
 */
@property (nonatomic, assign) UCHAR instantCrankRPM;
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
 * @return The formatted display string (cadence in RPMs).
 */
- (NSString*)formattedCadence:(BOOL)showUnits;

@end
