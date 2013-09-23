//
//  WFWeightScaleDelegate.h
//  WFConnector
//
//  Created by Benjamin Johnston on 2/07/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/_WFWeightScaleDelegate.h>


@class WFWeightScaleConnection;
@class WFBTLEWeightScaleUser;



/**
 * Provides the interface for callback methods used by the WFWeightScaleConnection.
 */
@protocol WFWeightScaleDelegate <_WFWeightScaleDelegate>

/**
 * Invoked when the WFWeightScaleConnection receives weight history from the
 * device.
 *
 * @param wsConn The WFWeightScaleConnection instance.
 *
 * @param history An NSArray of WFWeightScaleData objects.
 */
- (void)wsConnection:(WFWeightScaleConnection*)wsConn didReceiveWeightHistory:(NSArray*)history;

/**
 * Invoked when the WFWeightScaleConnection receives user records from the
 * device.
 *
 * @param wsConn The WFWeightScaleConnection instance.
 *
 * @param users An NSArray of WFWeightScaleUser objects.
 */
- (void)wsConnection:(WFWeightScaleConnection*)wsConn didReceiveUserRecords:(NSArray*)users;

/**
 * Invoked when a user profile which has been added contains overlapping weight ranges with 
 * and existing profile on the scale
 * @param wsConn The WFWeightScaleConnection instance.
 * @param rejectedProfile The profile sent by the user to be stored
 * @param overlappedProfile The existing profile with which it overlaps
 */
- (void)wsConnection:(WFWeightScaleConnection *)wsConn
 userProfileRejected:(WFBTLEWeightScaleUser*)rejectedProfile
  forOverlappingWith:(WFBTLEWeightScaleUser*)overlappedProfile;

/**
 * After a new user profile has been successfully added to the scale and assigned an ID,
 * this method will be called with the completed WFBTLEWeightScaleUser object as a parameter.
 *
 * @param wsConn The WFWeightScaleConnection instance.
 *
 * @param user Newly added WFWeightScaleUser object.
 */
- (void)wsConnection:(WFWeightScaleConnection*)wsConn didAddNewUserRecord:(WFBTLEWeightScaleUser*)user;

@optional

/**
 * Invoked when the WFWeightScaleConnection receives response from new user id 
 * request
 *
 * @param wsConn The WFWeightScaleConnection instance.
 *
 * @param userId integer representing the next available userId.
 */
- (void)wsConnection:(WFWeightScaleConnection*)wsConn didReceiveUserId:(int)userId;

@end
