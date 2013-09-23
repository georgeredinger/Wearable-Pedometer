//
//  WFHealthThermometerData.h
//  WFConnector
//
//  Created by Michael Moore on 12/22/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


@class WFBTLECommonData;


/**
 * Represents the data available from the BTLE Health Thermometer sensor.
 *
 * BTLE sensors send data in multiple packets.  The WFHealthThermometerData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFHealthThermometerData : WFSensorData
{
	/** \cond InterfaceDocs */
	
    WFBTLECommonData* btleCommonData;
    
    float temperature;
    WFBTLETemperatureType_t temperatureType;
    
	/** \endcond */
}


/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;
/** Gets the temperature, measured in celcius. */
@property (nonatomic, assign) float temperature;
/** The type of the temperature measurement. */
@property (nonatomic, assign) WFBTLETemperatureType_t temperatureType;

@end
