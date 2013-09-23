//
//  WFGlucoseDelegate.h
//  WFConnector
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>


@class WFGlucoseConnection;
@class WFGlucoseData;


/**
 * Provides the interface for callback methods used by the WFGlucoseConnection.
 */
@protocol WFGlucoseDelegate <NSObject>

/**
 * Invoked when the WFGlucoseConnection receives glucose data record from the
 * device.
 *
 * @param glucoseConn The WFGlucoseConnection instance.
 * 
 * @param record A WFGlucoseData representing the glucose data record.
 */
- (void)glucoseConnection:(WFGlucoseConnection*)glucoseConn didReceiveRecord:(WFGlucoseData*)record;

@end
