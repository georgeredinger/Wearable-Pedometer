//
//  WFBikeSpeedConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFBikeSpeedData;
@class WFBikeSpeedRawData;


/**
 * Represents a connection to an ANT+ Bike Speed sensor.
 */
@interface WFBikeSpeedConnection : WFSensorConnection
{
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFBikeSpeedData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBikeSpeedData*)getBikeSpeedData;

/**
 * Returns the latest raw (unformatted) data available from the sensor.
 *
 * @see WFSensorConnection::getRawData
 *
 * @return A WFBikeSpeedRawData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBikeSpeedRawData*)getBikeSpeedRawData;

@end
