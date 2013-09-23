//
//  WFHardwareConnector+AntMode.h
//  WFConnector
//
//  Created by Michael Moore on 5/25/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFHardwareConnector.h>
#import <WFConnector/WFAntReceiverDelegate.h>


/**
 * A category on the WFHardwareConnector class which facilitates using the
 * Wahoo Fitness API in Advanced ANT mode.
 */
@interface WFHardwareConnector (AntMode)

/**
 * Sets the WFHardwareConnetor to Advanced ANT mode.
 *
 * In Advanced mode, no internal processing of ANT messages is performed.
 * ANT messages are sent via the sendAntMessage: method and
 * received using the WFAntReceiverDelegate::antMessageReceived: method.
 *
 * @note In Advanced mode all ANT channel configuration and message processing
 * are the responsibility of the application developer, <b>no internal
 * processing is performed</b>.
 *
 * @param rxDelegate_ A reference to the WFAntReceiverDelegate instance which
 * will handle the RX messages from ANT.  If this parameter is <c>nil</c>,
 * the Advanced mode will be disabled, and the API will return to standard
 * operation mode.
 *
 * @return <c>TRUE</c> if advanced mode was set successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)initializeAdvancedMode:(id <WFAntReceiverDelegate>)rxDelegate_;

/**
 * Sends the specified ANT message.
 *
 * @note  The WFHardwareConnector must be in Advanced mode for this method
 * to work properly (see WFHardwareConnector::initializeAdvancedMode:).
 *
 * @param pstMessage A pointer to the ANT message to be sent.
 *
 * @return <c>TRUE</c> if the message was sent successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)sendAntMessage:(WFAntMessage*)pstMessage;

@end
