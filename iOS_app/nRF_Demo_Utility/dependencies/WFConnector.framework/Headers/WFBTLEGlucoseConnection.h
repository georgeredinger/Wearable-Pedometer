//
//  WFBTLEGlucoseConnection.h
//  WFConnector
//
//  Created by Michael Moore on 2/22/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>
#import <WFConnector/WFBTLEGlucoseDelegate.h>
#import <WFConnector/wf_btle_types.h>


@class WFBTLEGlucoseData;


/**
 * Represents a connection to a BTLE Glucose Monitor sensor.
 */
@interface WFBTLEGlucoseConnection : WFSensorConnection <WFBTLEGlucoseDelegate>
{
	/** \cond InterfaceDocs */
    
    id<WFBTLEGlucoseDelegate> glucoseDelegate;
    
	/** \endcond */
}


/**
 * Specifies the WFBTLEGlucoseDelegate instance which will handle callback
 * methods for this WFBTLEGlucoseConnection.
 */
@property (nonatomic, retain ) id<WFBTLEGlucoseDelegate> glucoseDelegate;


/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFBTLEGlucoseData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFBTLEGlucoseData*)getGlucoseData;

/**
 * Sends a command to the Glucose Monitor device.
 *
 * @param opCode The type of command to be sent.
 * @param op The operator for the command.
 * @param operands The operands for the command.  This value is variable length,
 * and the contents are dependent on the command (<c>opCode</c>).  For some
 * commands, this value may be <c>nil</c>.
 *
 * @return <c>TRUE</c> if the command was sent successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)sendRecordCommand:(WFBTLERecordOpCode_t)opCode withOperator:(WFBTLERecordOperator_t)op operands:(NSData*)operands;

@end
