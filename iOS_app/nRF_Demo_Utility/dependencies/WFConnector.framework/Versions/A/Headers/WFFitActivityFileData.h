//
//  WFFitActivityFileData.h  (previously WFFitFileData.h)
//  WFConnector
//
//  Created by Michael Moore on 6/16/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/WFFitMesgFileId.h>
#import <WFConnector/WFFitMessageSession.h>
#import <WFConnector/WFFitMessageLap.h>
#import <WFConnector/WFFitMessageRecord.h>
#import <WFConnector/WFFitMessageEvent.h>
#import <WFConnector/WFFitMessageDeviceInfo.h>
#import <WFConnector/WFFitMesgWorkout.h>
#import <WFConnector/WFFitMessageActivity.h>


/**
 * Represents the data contents of a fitness device FIT file.
 */
@interface WFFitActivityFileData : NSObject
{
	/** \cond InterfaceDocs */

    NSMutableArray* sessionRecords;
    NSMutableArray* lapRecords;
	NSMutableArray* dataRecords;
    NSMutableArray* eventRecords;
    NSMutableArray* workoutRecords;
	NSMutableArray* activityRecords;
    WFFitMesgFileId* fileId;
    WFFitMessageDeviceInfo* deviceInfo;

	/** \endcond */
}


/**
 * Gets the WFFitMesgFileId instance containing meta-data information
 * about the file.
 */
@property (nonatomic, retain) WFFitMesgFileId* fileId;

/**
 * Gets the device info for the device which created the FIT file.
 */
@property (nonatomic, retain) WFFitMessageDeviceInfo* deviceInfo;

/**
 * Gets a collection of WFFitSessionRecord instances for the file.
 */
@property (nonatomic, readonly) NSArray* sessionRecords;

/**
 * Gets a collection of WFFitLapRecord instances for the file.
 */
@property (nonatomic, readonly) NSArray* lapRecords;

/**
 * Gets a collection of WFFitDataRecord instances for the file.
 */
@property (nonatomic, readonly) NSArray* dataRecords;

/**
 * Gets a collection of WFFitEventRecord instances for the file.
 */
@property (nonatomic, readonly) NSArray* eventRecords;

/**
 * Gets a collection of WFFitWorkoutRecord instances for the file.
 */
@property (nonatomic, readonly) NSArray* workoutRecords;

/**
 * Gets a collection of WFFitActivityRecord instances for the file.
 */
@property (nonatomic, readonly) NSArray* activityRecords;


/**
 * Adds the specified WFFitSessionRecord instance to the session record
 * collection for the file.
 *
 * @param record The WFFitSessionRecord to be added.
 */
- (void)addSessionRecord:(WFFitMessageSession*)record;

/**
 * Adds the specified WFFitLapRecord instance to the lap record
 * collection for the file.
 *
 * @param record The WFFitLapRecord to be added.
 */
- (void)addLapRecord:(WFFitMessageLap*)record;

/**
 * Adds the specified WFFitDataRecord instance to the data record
 * collection for the file.
 *
 * @param record The WFFitDataRecord to be added.
 */
- (void)addDataRecord:(WFFitMessageRecord*)record;

/**
 * Adds the specified WFFitEventRecord instance to the event record
 * collection for the file.
 *
 * @param record The WFFitEventRecord to be added.
 */
- (void)addEventRecord:(WFFitMessageEvent*)record;

/**
 * Adds the specified WFFitWorkoutRecord instance to the workout record
 * collection for the file.
 *
 * @param record The WFFitWorkoutRecord to be added.
 */
- (void)addWorkoutRecord:(WFFitMesgWorkout*)record;

/**
 * Adds the specified WFFitActivityRecord instance to the activity record
 * collection for the file.
 *
 * @param record The WFFitActivityRecord to be added.
 */
- (void)addActivityRecord:(WFFitMessageActivity*)record;

/**
 * Decompresses the compressed speed and distance data.
 *
 * If the FIT file from which this WFFitActivityFileData was derived uses the
 * compressed speed and distance format, this method will decompress the speed
 * and distance values into the speed and distance fields for all data records.
 *
 * @return <c>TRUE</c> if decompression was performed, otherwise <c>FALSE</c>.
 */
- (BOOL)decompressSpeedDistance;

@end
