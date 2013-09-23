//
//  WFBikeCadenceConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>

@class WFBikeCadenceData;
@class WFBikeCadenceRawData;


/**
 * Represents a connection to an ANT+ Bike Cadence sensor.
 */
@interface WFBikeCadenceConnection : WFSensorConnection
{
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFBikeCadenceData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBikeCadenceData*)getBikeCadenceData;

/**
 * Returns the latest raw (unformatted) data available from the sensor.
 *
 * @see WFSensorConnection::getRawData
 *
 * @return A WFBikeCadenceRawData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBikeCadenceRawData*)getBikeCadenceRawData;

@end
