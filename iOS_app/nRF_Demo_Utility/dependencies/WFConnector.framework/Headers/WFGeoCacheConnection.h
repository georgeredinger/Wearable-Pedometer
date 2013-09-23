//
//  WFGeoCacheConnection.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorConnection.h>


@class WFGeoCacheData;
@class WFGeoCacheProgramData;


/**
 * Represents a connection to an ANT+ GeoCache sensor.
 */
@interface WFGeoCacheConnection : WFSensorConnection
{
}


/**
 * Returns the current data transfer percentage ( <c>[0, 1.0]</c> scale ).
 *
 * This value indicates the current progress of a data transfer.  After
 * connecting and requesting the PIN page, this value indicates the
 * progress of data transfer from the GeoCache device.  After initiating
 * a programming request, this value indicates the progress of the
 * tata transfer to the device.
 *
 * @return The data transfer progress on a scale from <c>0</c> to <c>1.0</c>,
 * where <c>0</c> indicates not started, and <c>1.0</c> indicates complete.
 */
- (float)dataTransferPercent;

/**
 * Returns the latest data available from the sensor.
 *
 * @see WFSensorConnection::getData
 *
 * @return A WFGeoCacheData instance containing data if available,
 * otherwise <c>nil</c>.
 */
- (WFGeoCacheData*)getGeoCacheData;

/**
 * Programs the GeoCache device with the specified parameters.
 *
 * @param data A WFGeoCacheProgramData instance representing the parameters
 * for programming the device.
 *
 * @return A ::WFGeoCacheProgramStatus_t value indicating the results of the
 * programming request.
 */
- (WFGeoCacheProgramStatus_t)programDevice:(WFGeoCacheProgramData*)data;

/**
 * Requests the PIN page from the GeoCache device.
 *
 * The GeoCache device broadcasts a beacon indicating its presence.  However,
 * no data is sent from the device until the PIN page is requested.
 *
 * @return <c>TRUE</c> if the PIN request was successful, otherwise <c>FALSE</c>.
 */
- (BOOL)requestPIN;

@end
