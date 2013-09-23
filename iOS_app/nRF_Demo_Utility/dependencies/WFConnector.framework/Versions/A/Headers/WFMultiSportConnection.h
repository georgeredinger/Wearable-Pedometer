//
//  WFMultiSportConnection.h
//  WFConnector
//
//  Created by Michael Moore on 3/22/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFConnectionParams;


/**
 * Represents an ANT+ Multi-Sport Speed and Distance connection.
 *
 * The WFAudioControlConnection and WFMultiSportConnection are different from the
 * standard connection types, in that they establish the "Master" side of the
 * connection, to which other devices connect.  The WFMultiSportConnection will
 * open a channel (if a free channel is available), and begin broadcasting based
 * on the ANT+ Multi-Sport Speed and Distance profile.  Methods are provided in the
 * WFMultiSportConnection class to configure the values which are broadcast
 * (see WFMultiSportConnection::setDistance:,
 * WFMultiSportConnection::setLatitude:, etc).
 */
@interface WFMultiSportConnection : WFSensorConnection
{
    
}


/**
 * Sets the distance to be broadcast.
 *
 * This is the distance which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param meters The current distance, in meters.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setDistance:(float)meters;

/**
 * Sets the elevation to be broadcast.
 *
 * This is the elevation which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param elevMeters The current elevation, in meters.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setElevation:(float)elevMeters;

/**
 * Sets the fix type to be broadcast.
 *
 * This is the fix type which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param fixType The current GPS fix type.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setFixType:(WFGPSFixType_t)fixType;

/**
 * Sets the heading to be broadcast.
 *
 * This is the heading which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param headingDegrees The current heading, in degrees.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setHeading:(double)headingDegrees;

/**
 * Sets the latitude to be broadcast.
 *
 * This is the latitude which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param latDegrees The current latitude, in degrees.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setLatitude:(double)latDegrees;

/**
 * Sets the longitude to be broadcast.
 *
 * This is the longitude which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param lonDegrees The current longitude, in degrees.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setLongitude:(double)lonDegrees;

/**
 * Sets the speed to be broadcast.
 *
 * This is the speed which will be broadcasted to any connected devices.  This
 * value is continually broadcasted until it is updated with a new value.
 *
 * @param metersPerSecond The current speed, in meters per second.
 *
 * @return <c>TRUE</c> if the new value was set successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)setSpeed:(float)metersPerSecond;


/**
 * Returns the default connection params for the WFMultiSportConnection.
 *
 * @return A WFConnectionParams instance representing the default connection
 * parameters for the WFMultiSportConnection.
 */
+ (WFConnectionParams*)defaultConnectionParams;

@end
