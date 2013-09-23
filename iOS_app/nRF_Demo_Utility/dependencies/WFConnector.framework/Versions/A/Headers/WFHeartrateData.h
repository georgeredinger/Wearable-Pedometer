//
//  WFHeartrateData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the most commonly used data available from the ANT+ Heart Rate Monitor sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFHeartrateData combines the
 * most commonly used of this data into a single entity.  The data represents
 * the latest of each data type sent from the sensor.
 */
@interface WFHeartrateData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	USHORT beatTime;
	UCHAR computedHeartrate;
	ULONG accumBeatCount;
	NSTimeInterval timestamp;
	BOOL timestampOverflow;
	
	/** \endcond */
}

/**
 * Represents the time of the last valid heart beat event.
 *
 * The time units are 1/1024 seconds.  Since the values are stored in
 * two byte integers which have a maximum value of 65536, the value
 * will roll over at 64 seconds (65536 / 1024).  This should be taken
 * into consideration when determining the currency of the data.
 */
@property (nonatomic, assign) USHORT beatTime;
/**
 * Instantaneous heart rate, in beats per minute.
 *
 * The valid values are 1-255, a value of 0 represents invalid data.
 */
@property (nonatomic, assign) UCHAR computedHeartrate;
/**
 * A 32-bit integer value which increments with each heart beat event.
 *
 * This value represents the same data as WFHeartrateRawData::beatCount,
 * but stores values larger than 255.
 */
@property (nonatomic, assign) ULONG accumBeatCount;
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
 * Returns the heart rate as a string formatted for display.
 * 
 * @see WFConnectorSettings
 * 
 * @param showUnits If <c>TRUE</c> the units will be included in the string
 * returned.  Otherwise, the units are not included.
 * 
 * @return The formatted display string (heart rate in BPM).
 */
- (NSString*)formattedHeartrate:(BOOL)showUnits;

@end
