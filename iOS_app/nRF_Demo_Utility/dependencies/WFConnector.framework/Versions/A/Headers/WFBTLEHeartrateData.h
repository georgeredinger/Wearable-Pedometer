//
//  WFBTLEHeartrateData.h
//  WFConnector
//
//  Created by Michael Moore on 5/2/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFHeartrateData.h"


/**
 * Represents the data available from the BTLE Heart Rate sensor.
 *
 * BTLE sensors send data in multiple packets.  The WFBTLEHeartrateData
 * combines the most commonly used of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 */
@interface WFBTLEHeartrateData : WFHeartrateData
{
    NSArray* rrIntervals;
}


/**
 * Gets an array of R-R intervals reported by the sensor since the last time
 * data was read.
 *
 * When R-R intervals are not available, this property will be <c>nil</c>.
 *
 * When available, this property will contain one or more <b>NSNumber</b> instances,
 * each representing an R-R interval in seconds.  The array is in ascending order
 * (the oldest value is first).  Each <b>NSNumber</b> instance contains an
 * <b>NSTimeInterval</b> value.
 *
 * @note The R-R values represent those reported by the sensor since the last
 * time that WFHeartrateConnection::getHeartrateData was invoked.  The API will
 * cache the R-R intervals received between calls to
 * WFHeartrateConnection::getHeartrateData, and will empty the cache when that
 * method is called.
 */
@property (nonatomic, retain) NSArray* rrIntervals;

@end
