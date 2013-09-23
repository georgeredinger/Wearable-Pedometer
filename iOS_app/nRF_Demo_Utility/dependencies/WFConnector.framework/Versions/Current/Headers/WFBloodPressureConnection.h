//
//  WFBloodPressureConnection.h
//  WFConnector
//
//  Created by Michael Moore on 2/17/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFBloodPressureData;


/**
 * Represents a connection to a BTLE Blood Pressure sensor.
 */
@interface WFBloodPressureConnection : WFSensorConnection
{
    
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFBloodPressureData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBloodPressureData*)getBloodPressureData;

@end
