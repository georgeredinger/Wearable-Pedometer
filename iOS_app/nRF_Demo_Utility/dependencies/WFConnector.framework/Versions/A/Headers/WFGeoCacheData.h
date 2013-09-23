//
//  WFGeoCacheData.h
//  WFConnector
//
//  Created by Michael Moore on 11/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <WFConnector/WFSensorData.h>

@class WFCommonData;


/**
 * Represents the data available from the ANT+ GeoCache sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFGeoCacheData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFGeoCacheData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	WFCommonData* commonData;
	NSString* geoCacheId;
	NSString* hint;
	double latitude;
	double longitude;
	NSDate* lastVisit;
	USHORT numberOfVisits;
	BOOL isAuthenticated;
	
	/** \endcond */
}


/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, retain) WFCommonData* commonData;

/**
 * The user-specified GeoCache ID stored on the device.
 */
@property (nonatomic, retain) NSString* geoCacheId;

/**
 * The user-specified hint stored on the device.
 */
@property (nonatomic, retain) NSString* hint;

/**
 * The latitude, in degrees.
 */
@property (nonatomic, assign) double latitude;

/**
 * The longitude, in degrees.
 */
@property (nonatomic, assign) double longitude;

/**
 * The date and time the device was last visited.
 */
@property (nonatomic, retain) NSDate* lastVisit;

/**
 * The number of visits since the device was programmed.
 */
@property (nonatomic, assign) USHORT numberOfVisits;

/**
 * <c>TRUE</c> if the device has been authenticated, otherwise <c>FALSE</c>.
 */
@property (nonatomic, assign) BOOL isAuthenticated;

@end
