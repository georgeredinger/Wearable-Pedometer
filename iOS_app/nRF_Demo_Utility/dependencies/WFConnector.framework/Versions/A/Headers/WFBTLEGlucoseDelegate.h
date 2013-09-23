//
//  WFBTLEGlucoseDelegate.h
//  WFConnector
//
//  Created by Michael Moore on 2/22/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/hardware_connector_types.h>
#import <WFConnector/wf_btle_types.h>


@class WFBTLEGlucoseConnection;
@class WFBTLEGlucoseData;


/**
 * Provides the interface for callback methods used by the WFBTLEGlucoseConnection.
 */
@protocol WFBTLEGlucoseDelegate <NSObject>

/**
 * Invoked when the WFBTLEGlucoseConnection receives glucose data record from the
 * device.
 *
 * @param glucoseConn The WFBTLEGlucoseConnection instance.
 *
 * @param record A WFBTLEGlucoseData representing the glucose data record.
 */
- (void)glucoseConnection:(WFBTLEGlucoseConnection*)glucoseConn didReceiveRecord:(WFBTLEGlucoseData*)record;

/**
 * Invoked when the WFBTLEGlucoseConnection receives a response to a command.
 *
 * @param glucoseConn The WFBTLEGlucoseConnection instance.
 
 * @param opCode The command to which the device is responding.
 * @param responseData Any data sent by the device with the command response.  This
 * data is variable length, and the contents are dependent on the command (<c>opCode</c>).
 */
- (void)glucoseConnection:(WFBTLEGlucoseConnection*)glucoseConn didReceiveCommandResponse:(WFBTLERecordOpCode_t)opCode responseData:(NSData*)responseData;


@end
