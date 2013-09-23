//
//  WFHeartrateConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFHeartrateData;
@class WFHeartrateRawData;


/**
 * Represents a connection to an ANT+ Heart Rate Monitor sensor.
 */
@interface WFHeartrateConnection : WFSensorConnection
{
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFHeartrateData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFHeartrateData*)getHeartrateData;

/**
 * Returns the latest raw (unformatted) data available from the sensor.
 *
 * @see WFSensorConnection::getRawData
 *
 * @return A WFHeartrateRawData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFHeartrateRawData*)getHeartrateRawData;

@end
