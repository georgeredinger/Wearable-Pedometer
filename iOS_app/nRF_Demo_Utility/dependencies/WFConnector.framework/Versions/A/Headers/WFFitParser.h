//
//  WFFitParser.h
//  WFConnector
//
//  Created by Michael Moore on 5/6/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>


/** Identifies time format as real time. */
#define FIT_TIME_FORMAT_REALTIME_MASK              0xF0000000
/** Identifies time format as either system or real time. */
#define FIT_TIME_FORMAT_SYSTEM_OR_REALTIME         ((UCHAR) 0)
/** Identifies time format as system time. */
#define FIT_TIME_FORMAT_SYSTEM_ONLY                ((UCHAR) 1)
/** Identifies time format as a counter. */
#define FIT_TIME_FORMAT_COUNTER                    ((UCHAR) 2)



@class WFFitActivityFileData;
@class WFFitSettingsFileData;
@class WFFitParser;


/**
 * Declares the callback interface for the WFFitParser.
 */
@protocol WFFitParserDelegate

/**
 * Alerts the delegate of the FIT parsing progress.
 *
 * @param progress The current progress (from 0.0 to 1.0).
 */
- (void)fitParserProgress:(float)progress;

@end


/**
 * Provides methods for parsing a FIT file.
 */
@interface WFFitParser : NSObject
{
    
}

///////////////////////////////////////////////////////////////////////////////
//
// WFFitParser - Class Method Declarations.
//

/**
 * Returns an NSDate from an ANT FS Timestamp.
 *
 * @param ulTime The ANT FS Timestamp (the number of seconds elapsed since 00:00
 * in the morning of December 31, 1989).
 *
 * @return The NSDate representation of the ANT FS Timestamp.
 */
+ (NSDate*)getDateFromTimestamp:(ULONG)ulTime;

/**
 * Returns an ANT FS Timestamp for the given date.
 *
 * @param date The date to be converted to an ANT FS Timestamp.
 *
 * @return The ANT FS Timestamp representation of the specified date (the number
 * of seconds elapsed since 00:00 in the morning of December 31, 1989).
 */
+ (ULONG)getTimestampFromDate:(NSDate*)date;

/**
 * Parses a FIT file into an array of entities.
 *
 * @param filePath The path to the FIT file to be parsed.
 *
 * @param pbCancel A pointer to a <c>BOOL</c> value indicating whether the parsing
 * operation should be cancelled.  The parsing operation can take quite a while if
 * the FIT file is large.  Setting the underlying value at the pointer location to
 * <c>TRUE</c> while the parsing is in progress will cause the parsing to be
 * cancelled (this would need to be done from a thread other than the one on which
 * this method was invoked).  <b>This parameter may not be <c>NULL</c></b>.
 *
 * @param progressDelegate A reference to a WFFitParserDelegate which will receive
 * progress updates.  If progress updates are not desired, this parameter may be
 * set to <c>nil</c>.
 *
 * @return An array of entities representing the contents of the FIT file.  The
 * contents of this array will depend on the type of FIT file at the specified
 * path.  Entities are types such as WFFitMesgFileId, WFFitMessageBloodPressure,
 * WFFitMessageWeightScale, WFFitMesgUserProfile, etc.
 */
+ (NSArray*) parseFit:(NSString*)filePath cancelPointer:(volatile BOOL*)pbCancel sendProgressToDelegate:(id<WFFitParserDelegate>)progressDelegate;

/**
 * Parses a FIT file into a WFFitActivityFileData instance.
 *
 * This method will parse a FIT file downloaded from most fitness watch types
 * (Garmin FR60, FR310, etc).  The workout data contained in the FIT file will
 * be represented in the WFFitActivityFileData instance returned.
 *
 * @param filePath The path to the FIT file to be parsed.
 *
 * @param pbCancel A pointer to a <c>BOOL</c> value indicating whether the parsing
 * operation should be cancelled.  The parsing operation can take quite a while if
 * the FIT file is large.  Setting the underlying value at the pointer location to
 * <c>TRUE</c> while the parsing is in progress will cause the parsing to be
 * cancelled (this would need to be done from a thread other than the one on which
 * this method was invoked).  <b>This parameter may not be <c>NULL</c></b>.
 *
 * @param progressDelegate A reference to a WFFitParserDelegate which will receive
 * progress updates.  If progress updates are not desired, this parameter may be
 * set to <c>nil</c>.
 *
 * @return A WFFitActivityFileData representing the contents of the FIT file.
 */
+ (WFFitActivityFileData*)parseActivityFit:(NSString*)filePath cancelPointer:(volatile BOOL*)pbCancel sendProgressToDelegate:(id<WFFitParserDelegate>)progressDelegate;

/**
 * Parses a FIT settings file into a WFFitSettingsFileData instance.
 *
 * @param filePath The path to the FIT file to be parsed.
 *
 * @return A WFFitSettingsFileData representing the contents of the FIT file.
 */
+ (WFFitSettingsFileData*)parseSettingsFit:(NSString*)filePath;

@end
