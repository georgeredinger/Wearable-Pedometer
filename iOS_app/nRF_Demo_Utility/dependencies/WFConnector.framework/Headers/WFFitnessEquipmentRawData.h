//
//  WFFitnessEquipmentRawData.h
//  WFConnector
//
//  Created by Michael Moore on 12/21/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

@class WFCommonData;


/**
 * Represents the raw data available from the ANT+ Fitness Equipment sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFFitnessEquipmentRawData combines the
 * more advanced (less commonly used) of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 */
@interface WFFitnessEquipmentRawData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	WFCommonData* commonData;
	WFFitnessEquipmentHRSource_t heartrateSource;
	
	/** \endcond */
}


/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, readonly) WFCommonData* commonData;
/**
 * Gets the source of the heart rate data for the FE machine.
 */
@property (nonatomic, assign) WFFitnessEquipmentHRSource_t heartrateSource;

@end
