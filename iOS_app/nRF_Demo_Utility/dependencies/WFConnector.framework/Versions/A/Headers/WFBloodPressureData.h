//
//  WFBloodPressureData.h
//  WFConnector
//
//  Created by Michael Moore on 2/17/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>
#import <WFConnector/wf_btle_types.h>


@class WFBTLECommonData;


/**
 * Represents the data available from the BTLE Blood Pressure sensor.
 *
 * BTLE sensors send data in multiple packets.  The WFBloodPressureData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFBloodPressureData : WFSensorData
{
	/** \cond InterfaceDocs */
	
    WFBTLECommonData* btleCommonData;
    
    float systolic;
    float diastolic;
    float meanArterialPressure;
    float heartRate;
    NSTimeInterval timestamp;
    UCHAR userId;
    BOOL isStatusPresent;
    WFBTLEBPStatus_t stStatus;
    
    BOOL isMeasurementInProgress;
    float cuffPressure;
    
	/** \endcond */
}


/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;
/** Gets the systolic pressure, measured in mmHg. */
@property (nonatomic, assign) float systolic;
/** Gets the diastolic pressure, measured in mmHg. */
@property (nonatomic, assign) float diastolic;
/** Gets the mean arterial pressure, measured in mmHg. */
@property (nonatomic, assign) float meanArterialPressure;
/** Gets the pulse rate, measured in beats per minute. */
@property (nonatomic, assign) float heartRate;
/** Gets the timestamp of the measurement. */
@property (nonatomic, assign) NSTimeInterval timestamp;
/** Gets the user ID for which the measurement was taken. */
@property (nonatomic, assign) UCHAR userId;
/**
 * Gets a boolean value indicating whether the status value is present.
 *
 * @see WFBloodPressureData::pstStatus
 */
@property (nonatomic, readonly) BOOL isStatusPresent;
/**
 * Gets a pointer to a ::WFBTLEBPStatus_t structure representing the status
 * reported by the Blood Pressure Monitor.
 *
 * @note The status is not reported by all Blood Pressure Monitors.  When the
 * status is not present, the value of WFBloodPressureData::isStatusPresent will
 * be <c>FALSE</c>.  In this case, WFBloodPressureData::pstStatus will be <c>nil</c>.
 */
@property (nonatomic, readonly) WFBTLEBPStatus_t* pstStatus;

/**
 * Gets a boolean value indicating whether a measurement is currently in progress.
 * 
 * @see WFBloodPressureData::cuffPressure
 */
@property (nonatomic, assign) BOOL isMeasurementInProgress;
/**
 * Gets the current cuff pressure, measured in mmHg.
 *
 * @note This value is only valid when a measurement is currently in progress.
 * In this case, WFBloodPressureData::isMeasurementInProgress will be <c>TRUE</c>.
 */
@property (nonatomic, assign) float cuffPressure;


/** \cond InterfaceDocs */
/**
 * Initializes a new WFBloodPressureData instance with the specified parameters.
 *
 * @note This method is for internal use.
 *
 * @param dataTime The data timestamp.
 * @param bStatus A boolean value indicating whether the sensor status is available.
 *
 * @return The new WFBloodPressureData instance.
 */
- (id)initWithTime:(NSTimeInterval)dataTime hasStatus:(BOOL)bStatus;
/** \endcond */

@end
