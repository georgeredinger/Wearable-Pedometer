//
//  WFProximityData.h
//  WFConnector
//
//  Created by Michael Moore on 12/19/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


@class WFBTLECommonData;


/**
 * Represents the data available from the BTLE Proximity sensor.
 *
 * BTLE sensors send data in multiple packets.  The WFProximityData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFProximityData : WFSensorData
{
	/** \cond InterfaceDocs */
	
    WFBTLECommonData* btleCommonData;
    
    WFBTLEChAlertLevel_t alertLevel;
    int txPowerLevel;
    
	/** \endcond */
}


/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;
/** The alert level specified by the device. */
@property (nonatomic, assign) WFBTLEChAlertLevel_t alertLevel;
/** The transmit power level reported by the device. */
@property (nonatomic, assign) int txPowerLevel;

@end
