//
//  WFWeightScaleData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


#define WF_WEIGHT_SCALE_INVALID      -1.0
#define WF_WEIGHT_SCALE_COMPUTING    -2.0


/**
 * Represents the data available from the ANT+ Weight Scale sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFWeightScaleData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFWeightScaleData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	USHORT userProfileId;
	float  bodyWeight;
	
	/** \endcond */
}


/** User profile ID number. */
@property (nonatomic, assign) USHORT userProfileId;

/**
 * Measured body weight (in kg).
 *
 * @note Two special values exist.  When the weight scale is computing the user's
 * weight, the value will be <c>WF_WEIGHT_SCALE_COMPUTING</c>.  If the weight
 * scale has not recorded a valid value, the value will be
 * <c>WF_WEIGHT_SCALE_INVALID</c>. Otherwise, the value is the weight in kilograms.
 */
@property (nonatomic, assign) float bodyWeight;

@end
