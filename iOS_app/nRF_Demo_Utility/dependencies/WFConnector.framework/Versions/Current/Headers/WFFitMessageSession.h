//
//  WFFitMessageSession.h  (previously WFFitSessionRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 4/11/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a session record from a fitness device FIT file.
 */
@interface WFFitMessageSession : WFFitMessageBase
{
	/** \cond InterfaceDocs */
    
	FIT_SESSION_MESG stSession;
    NSDate* startTime;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_SESSION_MESG</c> structure containing the data for
 * this record.
 */
@property (nonatomic, readonly) FIT_SESSION_MESG* pstSession;
/** Gets the start time for the session (represented as an NSDate). */
@property (nonatomic, readonly) NSDate* startTime;
/** Gets the starting latitude for the session. */
@property (nonatomic, readonly) double startLatitude;
/** Gets the starting longitude for the session. */
@property (nonatomic, readonly) double startLongitude;
/** Gets the North-East-Corner latitude (bounding box). */
@property (nonatomic, readonly) double necLatitude;
/** Gets the North-East-Corner longitude (bounding box). */
@property (nonatomic, readonly) double necLongitude;
/** Gets the South-West-Corner latitude (bounding box). */
@property (nonatomic, readonly) double swcLatitude;
/** Gets the South-West-Corner longitude (bounding box). */
@property (nonatomic, readonly) double swcLongitude;
/** Gets the total elapsed time for the session (in seconds). */
@property (nonatomic, readonly) double totalElapsedTime;
/** Gets the total running time for the session (in seconds). */
@property (nonatomic, readonly) double totalRunningTime;
/** Gets the total distance for the session (in meters). */
@property (nonatomic, readonly) float totalDistance;
/** Gets the average speed for the session (in meters per second). */
@property (nonatomic, readonly) float avgSpeed;
/** Gets the max speed for the session (in meters per second). */
@property (nonatomic, readonly) float maxSpeed;

@end
