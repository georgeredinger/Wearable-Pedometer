//
//  WFFitMesgWorkout.h  (previously WFFitWorkoutRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 4/11/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a workout record from a fitness device FIT file.
 */
@interface WFFitMesgWorkout : NSObject
{
	/** \cond InterfaceDocs */
    
	FIT_WORKOUT_MESG stWorkout;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_WORKOUT_MESG</c> structure containing the data for
 * this record.
 */
@property (nonatomic, readonly) FIT_WORKOUT_MESG* pstWorkout;


/**
 * Initializes the WFFitMesgWorkout with the contents of the specified FIT record.
 *
 * @param pstRecord A pointer to the FIT record used to initialize this instance.
 *
 * @return This WFFitMesgWorkout instance.
 */
- (id)initWithRecord:(void*)pstRecord;

@end
