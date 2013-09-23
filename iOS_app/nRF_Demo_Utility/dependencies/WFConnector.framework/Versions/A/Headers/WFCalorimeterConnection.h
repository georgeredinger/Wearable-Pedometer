//
//  WFCalorimeterConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFCalorieData;


/**
 * Represents a connection to an ANT+ Calorimeter sensor.
 */
@interface WFCalorimeterConnection : WFSensorConnection
{
}


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFCalorieData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFCalorieData*)getCalorieData;

@end
