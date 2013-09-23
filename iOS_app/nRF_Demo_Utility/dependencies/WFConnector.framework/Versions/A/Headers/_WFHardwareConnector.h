/*
 *  _WFHardwareConnector_stub.h
 *  WFConnector
 *
 *  Created by Michael Moore on 5/25/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <WFConnector/WFHardwareConnectorDelegate.h>


/** Represents the internal-use base class for the WFHardwareConnector. */
@interface _WFHardwareConnector : NSObject
{
}


/**
 * Gets or sets a boolean value indicating whether sensor connections are reset
 * automatically when the fisica hardware is disconnected.
 *
 * When the fisica hardware is disconnected (either by removing physically, or by
 * the application entering background mode in pre-iOS5 devices), the ANT radio
 * loses power, and the established connections are broken.  When the fisica is
 * re-connected, if <c>autoReset</c> is <c>TRUE</c>, any WFSensorConnection
 * instances established prior to the disconnect are reset, and the
 * WFHardwareConnector is in initialized state.  If <c>autoReset</c> is <c>FALSE</c>,
 * any WFSensorConnection instances will attempt to re-establish previous
 * connections.  In most cases, this should restore the connection and resume the
 * data flow.  However, there may be possible data synchronization issues in some
 * situations.  Therefore, it is recommended that the <c>autoReset</c> remain in
 * the default <c>TRUE</c> condition, and that the application re-estabish desired
 * connections in the same manner as when the WFHardwareConnector is originally
 * initialized.
 *
 * @note The default value is <c>TRUE</c>.
 */
@property (nonatomic, assign) BOOL autoReset;

/**
 * Gets or sets the WFHardwareConnectorDelegate which will handle delegated
 * methods from the WFHardwareConnector.
 */
@property (nonatomic, retain) id <WFHardwareConnectorDelegate> delegate;

@end
