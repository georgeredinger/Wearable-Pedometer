//
//  WFFitMessageActivity.h  (previously WFFitActivityRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 6/16/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a single activity record from a fitness device FIT file.
 */
@interface WFFitMessageActivity : WFFitMessageBase
{
	/** \cond InterfaceDocs */

	FIT_ACTIVITY_MESG stActivity;
	NSDate* localTimestamp;

	/** \endcond */
}


/**
 * Gets a pointer to the <c>FIT_ACTIVITY_MESG</c> structure containing the data
 * for this record.
 */
@property (nonatomic, readonly) FIT_ACTIVITY_MESG* pstActivity;

/**
 * Gets the localized timestamp for the record.
 *
 * @note This property is device specific, and may not contain a valid time.
 */
@property (nonatomic, readonly) NSDate* localTimestamp;


/**
 * Returns the localized timestamp as a string formatted in short date time
 * (MM/DD/YY 12:00 AM).
 *
 * @note This method is device specific, and may not return a valid time.
 *
 * @return The formatted date string (MM/DD/YY 12:00 AM).
 */
- (NSString*)stringFromLocalTimestamp;

@end
