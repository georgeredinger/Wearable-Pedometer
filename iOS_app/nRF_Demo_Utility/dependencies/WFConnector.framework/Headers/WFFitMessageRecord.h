//
//  WFFitMessageRecord.h  (previously WFRecordFitRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 6/16/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represent a single data record from a fitness device FIT file.
 */
@interface WFFitMessageRecord : WFFitMessageBase
{
	/** \cond InterfaceDocs */

	FIT_RECORD_MESG stFitRecord;

	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_RECORD_MESG</c> structure containing the data for
 * this record.
 */
@property (nonatomic, readonly) FIT_RECORD_MESG* pstFitRecord;
/** Gets the latitude. */
@property (nonatomic, readonly) double latitude;
/** Gets the longitude. */
@property (nonatomic, readonly) double longitude;
/** Gets the distance (in meters). */
@property (nonatomic, readonly) float distance;
/** Gets the altitude (in meters). */
@property (nonatomic, readonly) float altitude;
/** Gets the speed (in meters per second). */
@property (nonatomic, readonly) float speed;
/** Gets the grade (as a percentage). */
@property (nonatomic, readonly) float grade;
/** Gets the cycle length (in meters). */
@property (nonatomic, readonly) float cycleLength;

@end
