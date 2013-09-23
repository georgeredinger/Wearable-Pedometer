/*
 *  WFAntReceiverDelegate.h
 *  WFConnector
 *
 *  Created by Michael Moore on 5/24/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#include <WFConnector/wf_ant_types.h>


/**
 * The WFAntReceiverDelegate protocol declares the interface for an ANT
 * message receiver used when the WFHardwareConnector is in advanced mode.
 *
 * The WFAntReceiverDelegate protocol should be adopted by classes which
 * will receive ANT messages directly from the WFHardwareConnector.
 * A reference to such a delegate is passed to the WFHardwareConnector
 * via the WFHardwareConnector::initializeAdvancedMode: method.  The
 * WFHardwareConnector will then forward all ANT Messages it receives
 * to the delegate.
 */
@protocol WFAntReceiverDelegate

/**
 * This method is invoked by the WFHardwareConnector when an ANT message
 * has been received.
 *
 * @param antMessage The ANT message that was received.
 */
- (void)antMessageReceived:(WFAntMessage)antMessage;

@end
