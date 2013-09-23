//
//  WFBTLEWeightScaleData.h
//  WFConnector
//
//  Created by Michael Moore on 6/26/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <WFConnector/WFWeightScaleData.h>

@class WFBTLECommonData;


/**
 * Represents the data available from the Wahoo Fitness BTLE Weight Scale.
 *
 */
@interface WFBTLEWeightScaleData : WFWeightScaleData
{
    WFBTLECommonData* btleCommonData;
    float bmi;
    BOOL isWeightStabilized;
    
    
}


/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;

/**
 * Timestamp of weight entry.
 */
@property (nonatomic, readonly) NSTimeInterval timeStamp;

/**
 * Body Mass Index (kg/m2).
 */
@property (nonatomic, assign) float bmi;

/**
 * Boolean indicating the weight returned from the scale is a stabilized weight.
 */
@property (nonatomic, assign) BOOL isWeightStabilized;

@end
