//
//  WFGlucoseData.h
//  WFConnector
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>
#import <WFConnector/wf_glucose_types.h>


@class WFCommonData;


/**
 * Represents the most commonly used data available from the ANT+ Glucose Monitor sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFHeartrateData combines the
 * most commonly used of this data into a single entity.  The data represents
 * the latest of each data type sent from the sensor.
 */
@interface WFGlucoseData : WFSensorData
{
	/** \cond InterfaceDocs */
	
    WFCommonData* commonData;

    WFGlucoseStatus_t status;
    NSDate* timestamp;
    USHORT usConcentration;
    WFGlucoseChangeRate_t rateOfChange;
    
    NSDate* currentDeviceTime;
    ULONG ulElapsedTime;
    
    WFGlucoseRateAlertLevel_t risingAlertLevel;
    WFGlucoseRateAlertLevel_t fallingAlertLevel;
    USHORT usHighAlertLevel;
    USHORT usLowAlertLevel;
	/** \endcond */
}


/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, readonly) WFCommonData* commonData;

/** Gets the glucose device status. */
@property (nonatomic, assign) WFGlucoseStatus_t status;
/** Gets the timestamp for the glucose data. */
@property (nonatomic, retain) NSDate* timestamp;
/** Gets the concentration, measured in mg/dL. */
@property (nonatomic, assign) USHORT usConcentration;
/** Gets the current rate of change in the glucose level. */
@property (nonatomic, assign) WFGlucoseChangeRate_t rateOfChange;

/**
 * Gets the current time, as reported by the glucose device.
 *
 * This value may be compared to the current system time and used to offset
 * any descrepencies in timestamp values.
 */
@property (nonatomic, retain) NSDate* currentDeviceTime;
/** Gets the number of seconds since the Sensor Term was started or initialized. */
@property (nonatomic, assign) ULONG ulElapsedTime;
/** Gets the rising level rate at which the device is currently set to alert. */
@property (nonatomic, assign) WFGlucoseRateAlertLevel_t risingAlertLevel;
/** Gets the falling level rate at which the device is currently set to alert. */
@property (nonatomic, assign) WFGlucoseRateAlertLevel_t fallingAlertLevel;
/** Gets the high glucose level at which the device is currently set to alert. */
@property (nonatomic, assign) USHORT usHighAlertLevel;
/** Gets the low glucose level at which the device is currently set to alert. */
@property (nonatomic, assign) USHORT usLowAlertLevel;

@end
