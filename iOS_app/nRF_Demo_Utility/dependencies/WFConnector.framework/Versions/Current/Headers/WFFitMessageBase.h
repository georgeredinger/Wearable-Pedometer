//
//  WFFitMessageBase.h  (previously WFFitRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 6/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/common_types.h>


/**
 * Represents a single record in a FIT file system.
 */
@interface WFFitMessageBase : NSObject
{
	/** \cond InterfaceDocs */

	NSDate* timestamp;

	/** \endcond */
}


/**
 * Gets or sets the timestamp of the record.
 */
@property (nonatomic, readonly) NSDate* timestamp;


/**
 * Initializes the WFFitMessageBase with the contents of the specified FIT record.
 *
 * @param pstRecord A pointer to the FIT record used to initialize this instance.
 *
 * @return This WFFitMessageBase instance.
 */
- (id)initWithRecord:(void*)pstRecord;

/**
 * Returns the timestamp as a string formatted in short date time
 * (MM/DD/YY 12:00 AM).
 *
 * @return A formatted date string (MM/DD/YY 12:00 AM).
 */
- (NSString*)stringFromTimestamp;

/**
 * Returns the specified time as a string formatted in short date time
 * (MM/DD/YY 12:00 AM).
 *
 * @param time The time value to be formatted.
 *
 * @return A formatted date string (MM/DD/YY 12:00 AM).
 */
- (NSString*)stringFromTime:(NSDate*)time;

@end
