//
//  _WFSensorConnection.h
//  WFConnector
//
//  Created by Michael Moore on 1/28/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>

/** \cond InterfaceDocs */

@class WFSensorData;


/** Describes an error encountered during an attempt to establish a connection. */
typedef enum
{
    /** No error has occured. */
    WF_SENSOR_CONN_ERROR_NONE  = 0,
    /** Failed to retrieve the specified paired sensor. */
    WF_SENSOR_CONN_ERROR_PAIRED_DEVICE_NOT_AVAILABLE,
    /**
     * Occurs when an attempt is made to initiate a proximity search while a
     * sensor of the specified type is currently connected to the phone.
     */
    WF_SENSOR_CONN_ERROR_PROXIMITY_SEARCH_WHILE_CONNECTED,
    /**
     * Occurs on a conditional connection when no new data is available from the
     * device.
     */
    WF_SENSOR_CONN_ERROR_NO_NEW_DATA,
    /**
     * Occurs when there has been no activity on the connection for the duration
     * of the connection activity timeout.
     *
     * @note The activity timeout is device-type-specific and is not used on devices
     * which require constant data updates.
     */
    WF_SENSOR_CONN_ERROR_ACTIVITY_TIMEOUT,
    
} WFSensorConnectionError_t;



@interface _WFSensorConnection : NSObject
{
}

@end

/** \endcond */
