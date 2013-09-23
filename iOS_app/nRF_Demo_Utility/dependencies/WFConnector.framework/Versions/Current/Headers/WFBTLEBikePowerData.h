//
//  WFBTLEBikePowerData.h
//  WFConnector
//
//  Created by Michael Moore on 6/7/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFBikePowerData.h>

@class WFBTLECommonData;


/**
 * Represents the data available from the BTLE Cycling Power Meter.
 */
@interface WFBTLEBikePowerData : WFBikePowerData
{
    WFBTLECommonData* btleCommonData;
}

/** Gets the metadata for the BTLE device. */
@property (nonatomic, retain) WFBTLECommonData* btleCommonData;


@end
