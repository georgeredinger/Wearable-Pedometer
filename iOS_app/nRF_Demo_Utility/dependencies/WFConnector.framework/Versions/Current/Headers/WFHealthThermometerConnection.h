//
//  WFHealthThermometerConnection.h
//  WFConnector
//
//  Created by Michael Moore on 12/22/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFHealthThermometerData;


/**
 * Represents a connection to a BTLE Health Thermometer sensor.
 */
@interface WFHealthThermometerConnection : WFSensorConnection
{
    
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFHealthThermometerData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFHealthThermometerData*)getHealthThermometerData;

@end
