//
//  WFFootpodConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFFootpodData;
@class WFFootpodRawData;


/**
 * Represents a connection to an ANT+ Stride sensor.
 */
@interface WFFootpodConnection : WFSensorConnection
{
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFFootpodData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFFootpodData*)getFootpodData;

/**
 * Returns the latest raw (unformatted) data available from the sensor.
 *
 * @see WFSensorConnection::getRawData
 *
 * @return A WFFootpodRawData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFFootpodRawData*)getFootpodRawData;

@end
