//
//  WFHeartrateRawData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

@class WFCommonData;
@class WFBTLECommonData;


/**
 * Represents the raw data available from the ANT+ Heart Rate Monitor sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFHeartrateRawData combines the
 * more advanced (less commonly used) of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 */
@interface WFHeartrateRawData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	WFCommonData* commonData;
    WFBTLECommonData* btleCommonData;
	USHORT beatTime;
	UCHAR beatCount;
	UCHAR computedHeartrate;
	USHORT previousBeatTime;
	
	/** \endcond */
}

/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, readonly) WFCommonData* commonData;
/**
 * Common sensor data for BTLE sensors, provides information about the sensor.
 *
 * @note This property is only available for BTLE sensors.  All other sensors
 * will have a <c>nil</c> value.
 */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;
/**
 * Instantaneous heart rate, in beats per minute.
 *
 * The valid values are 1-255, a value of 0 represents invalid data.
 */
@property (nonatomic, assign) UCHAR computedHeartrate;
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
 * A single byte value which increments with each heart beat event.
 *
 * This value will roll over every 255 counts.
 */
@property (nonatomic, assign) UCHAR beatCount;
/**
 * Represents the time of the previous valid heart beat event.
 * 
 * See the WFHeartrateData::beatTime documentation for explanation
 * of time values.
 */
@property (nonatomic, assign) USHORT previousBeatTime;

@end
