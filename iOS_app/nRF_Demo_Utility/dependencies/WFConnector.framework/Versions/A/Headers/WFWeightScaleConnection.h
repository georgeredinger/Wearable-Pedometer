//
//  WFWeightScaleConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <WFConnector/_WFWeightScaleConnection.h>
#import <WFConnector/WFSensorConnection.h>
#import <WFConnector/WFWeightScaleDelegate.h>

#define WF_LAST_SYNC_KEY @"WFBTLEScaleLastSyncTime"

@class WFWeightScaleData;
@class WFBTLEWeightScaleUser;
@class WFConnectionParams;


/** Represents the units displayed on the scale LCD. */
typedef enum
{
    WFBTLE_WEIGHT_SCALE_UNITS_METRIC,
    WFBTLE_WEIGHT_SCALE_UNITS_ENGLISH
    
} WFBTLEWeightScaleUnitType_t;




/**
 * Represents a connection to an ANT+ or BTLE Weight Scale sensor.
 */
@interface WFWeightScaleConnection : _WFWeightScaleConnection <WFWeightScaleDelegate>
{
    id<WFWeightScaleDelegate> wsDelegate;
}


/**
 * Specifies the WFWeightScaleDelegate instance which will handle callback
 * methods for this WFWeightScaleConnection.
 */
@property (nonatomic, retain ) id<WFWeightScaleDelegate> wsDelegate;

/*---ANT+ WEIGHT SCALE SENSORS--*/

/**
 * Returns the latest data available from the sensor.
 * Note that this is for ANT+ weight scale sensors only.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFWeightScaleData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFWeightScaleData*)getWeightScaleData;

/**
 * Sends a user profile message to the Weight Scale sensor with the user
 * profile data specified in the ::WFWeightScaleUserProfile_t structure.
 * Note that this is for ANT+ weight scale sensors only.
 *
 * @param pstData A ::WFWeightScaleUserProfile_t structure containing the
 * user profile information to be sent to the sensor.
 *
 * @return <c>TRUE</c> if the user profile message was sent successfully,
 * otherwise <c>FALSE</c>.
 */
- (BOOL)setWeightScaleUserProfile:(WFWeightScaleUserProfile_t*)pstData;





/*---BTLE (WAHOO) WEIGHT SCALE SENSOR--*/

/**
 * Sets the units displayed on the scale LCD to Metric or Imperial .
 * Note that the units stored on the scale and transmitted through the API will
 * always be in Metric - this is for scale display purposes only.
 *
 * @param unitType A WFBTLEWeightScaleUnitType_t which can indicate imperial (english) or metric.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setDisplayUnitType:(WFBTLEWeightScaleUnitType_t)unitType;

/**
 * Requests all weight history from a BTLE weight scale sensor.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestAllHistory;

/**
 * Requests all weight history from a BTLE weight scale sensor since the last sync with device.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestHistorySinceLastSync;

/**
 * Requests all weight history from the BTLE sensor having a timestamp greater than or equal
 * to the timestamp parameter.
 *
 * @param timestamp NSTimeInterval since Apple reference date
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestHistorySinceTimestamp:(NSTimeInterval)timestamp;

/**
 * Instructs the sensor to clear its entire weight history
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)clearAllHistory;

/**
 * Deletes the latest history record from the scale which has a timestamp matching the
 * parameter <c>timestamp</c>
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 *
 * @param timestamp A NSTimeInterval matching the timestamp of the history record to
 * clear.  Timestamp is time since Apple reference date.
 *
 * sets scale to
 */
- (BOOL)clearHistoryRecordWithTimestamp:(NSTimeInterval)timestamp;


/**
 * Creates a user record of type WFBTLEWeightScaleUser and stores it on the weight scale.
 * Will send a WFBTLEWeightScaleUser object to the delegate once it has been created and
 * assigned a userId locally on the scale.  If the provided weight range overlaps with an 
 * existing user the delegate will be notified that there was a conflict.  
 *
 * @param userRecord The WFBTLEWeightScaleUser instance to store on the scale.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)storeUserRecord:(WFBTLEWeightScaleUser*)userRecord;

/**
 * Requests all user records from the sensor.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestAllUserRecords;

/**
 * Instructs the sensor to clear all user records from memory
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)clearAllUserRecords;

/**
 * Clears the user record with id matching the parameter userId from the scale
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 *
 * @param userId The unique user id of the record to be deleted
 */
- (BOOL)clearUserRecordWithId:(int)userId;

/**
 * Assigns the specified userId to the history record from the scale which has a
 * timestamp matching the parameter <c>timestamp</c>
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 *
 * @param userId The integer value to be written to the history record's user id field
 *
 * @param timestamp A NSTimeInterval matching the timestamp of the history record to
 * clear.  Timestamp is time since Apple referecne date.
 */
- (BOOL)assignUserId:(int)userId toHistoryRecordWithTimestamp:(NSTimeInterval)timestamp;

/**
 * Returns the date and time of this device's last known history download from the scale.
 *
 * @return NSTimeInterval seconds since Apple Reference Date of last sync time.
 */
- (NSTimeInterval)getLastSyncTime;


+ (BOOL)configureConditionalConnection:(WFConnectionParams*)params lastSyncDate:(NSDate*)syncDate;

@end
