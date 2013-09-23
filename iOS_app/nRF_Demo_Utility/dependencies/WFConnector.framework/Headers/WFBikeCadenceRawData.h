//
//  WFBikeCadenceRawData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

@class WFCommonData;


/**
 * Represents the raw data available from the ANT+ Bike Cadence sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikeCadenceRawData combines the
 * more advanced (less commonly used) of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 */
@interface WFBikeCadenceRawData : WFSensorData
{
	/** \cond InterfaceDocs */

	WFCommonData* commonData;
	USHORT lastCadenceTime;
	USHORT totalCrankRevolutions;
	
	/** \endcond */
}


/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, readonly) WFCommonData* commonData;
/**
 * Represents the time of the last valid cadence event.
 *
 * The time units are 1/1024 seconds.  Since the values are stored in
 * two byte integers which have a maximum value of 65536, the value
 * will roll over at 64 seconds (65536 / 1024).  This should be taken
 * into consideration when determining the currency of the data.
 */
@property (nonatomic, assign) USHORT lastCadenceTime;
/**
 * Represents the total number of pedal revolutions.
 *
 * Since the value is stored in a two byte integer which has a maximum value of
 * 65536, the value will roll over at 65536 revolutions.  This should be taken
 * into consideration when making calculations.
 */
@property (nonatomic, assign) USHORT totalCrankRevolutions;

@end
