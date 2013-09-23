//
//  WFGeoCacheProgramData.h
//  WFConnector
//
//  Created by Michael Moore on 11/17/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/common_types.h>


/**
 * Represents the data used to program an ANT+ GeoCache device.
 */
@interface WFGeoCacheProgramData : NSObject
{
	/** \cond InterfaceDocs */
	
	NSString* geoCacheId;
	NSString* hint;
	ULONG devicePIN;
	double latitude;
	double longitude;
	
	/** \endcond */
}


/**
 * The GeoCache Identification for the device.
 *
 * Valid values for this property may contain up to nine characters.  The
 * characters may be any value from the standard ASCII table between
 * 0x20 and 0x5F.
 */
@property (nonatomic, retain) NSString* geoCacheId;

/**
 * The hint to be stored on the device.
 */
@property (nonatomic, retain) NSString* hint;

/**
 * The 32-bit PIN number for the device.
 *
 * If the device has been previously programmed, this value must be equal to
 * the PIN stored on the device.  Otherwise, the device PIN will be set to
 * this value.  The value must be non-zero.
 */
@property (nonatomic, assign) ULONG devicePIN;

/**
 * The latitude, in degrees.
 */
@property (nonatomic, assign) double latitude;

/**
 * The longitude, in degrees.
 */
@property (nonatomic, assign) double longitude;

@end
