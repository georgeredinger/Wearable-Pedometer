//
//  WFWahooCSCData.h
//  WFConnector
//
//  Created by Michael Moore on 3/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WFOdometerHistory;


/**
 * Represents the additional data available from the Wahoo Fitness BTLE Bike
 * Speed and Cadence sensor.
 *
 */
@interface WFWahooCSCData : NSObject
{
	/** \cond InterfaceDocs */
	
    float temperature;
    WFOdometerHistory* odometerHistory;
    
	/** \endcond */
}


/** Gets the ambient temperature, measured in celcius. */
@property (nonatomic, assign) float temperature;
/**
 * Gets a WFOdometerHistory instance representing the odometer history for
 * the Wahoo Fitness BlueSC device, when available.
 */
@property (nonatomic, retain) WFOdometerHistory* odometerHistory;

@end
