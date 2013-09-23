//
//  WFBTLEGlucoseData.h
//  WFConnector
//
//  Created by Michael Moore on 2/22/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>
#import <WFConnector/wf_btle_types.h>

@class WFBTLECommonData;


/**
 * Represents the data available from the BTLE Glucose Monitor sensor.
 *
 * BTLE sensors send data in multiple packets.  The WFBTLEGlucoseData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFBTLEGlucoseData : WFSensorData
{
	/** \cond InterfaceDocs */
	
    WFBTLECommonData* btleCommonData;
    WFBTLEGlucoseDeviceFeatures_t stDeviceFeatures;
    WFBTLEGlucoseMeasurementData_t stGlucoseMeasurement;
    WFBTLEGlucoseMeasurementContext_t stGlucoseMeasurementContext;
    
	/** \endcond */
}


/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;
/** Gets a pointer to a structure representing the device features. */
@property (nonatomic, readonly) WFBTLEGlucoseDeviceFeatures_t* pstDeviceFeatures;
/** Gets a pointer to a structure representing a glucose measurement record. */
@property (nonatomic, readonly) WFBTLEGlucoseMeasurementData_t* pstGlucoseMeasurement;
/** Gets a pointer to a structure representing the glucose measurement context. */
@property (nonatomic, readonly) WFBTLEGlucoseMeasurementContext_t* pstGlucoseMeasurementContext;

@end

