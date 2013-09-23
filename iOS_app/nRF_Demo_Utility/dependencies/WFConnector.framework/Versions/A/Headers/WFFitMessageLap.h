//
//  WFFitMessageLap.h  (previously WFFitLapRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 4/11/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a lap record from a fitness device FIT file.
 */
@interface WFFitMessageLap : WFFitMessageBase
{
	/** \cond InterfaceDocs */
    
	FIT_LAP_MESG stLap;
    NSDate* startTime;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_LAP_MESG</c> structure containing the data for this
 * record.
 */
@property (nonatomic, readonly) FIT_LAP_MESG* pstLap;
/** Gets the start time for the lap (represented as an NSDate). */
@property (nonatomic, readonly) NSDate* startTime;
/** Gets the starting latitude for the lap. */
@property (nonatomic, readonly) double startLatitude;
/** Gets the starting longitude for the lap. */
@property (nonatomic, readonly) double startLongitude;
/** Gets the ending latitude for the lap. */
@property (nonatomic, readonly) double endLatitude;
/** Gets the ending longitude for the lap. */
@property (nonatomic, readonly) double endLongitude;
/** Gets the total elapsed time for the lap (in seconds). */
@property (nonatomic, readonly) double totalElapsedTime;
/** Gets the total running time for the lap (in seconds). */
@property (nonatomic, readonly) double totalRunningTime;
/** Gets the total distance for the lap (in meters). */
@property (nonatomic, readonly) float totalDistance;
/** Gets the average speed for the lap (in meters per second). */
@property (nonatomic, readonly) float avgSpeed;
/** Gets the max speed for the lap (in meters per second). */
@property (nonatomic, readonly) float maxSpeed;

@end
