//
//  WFFitMesgDeviceSettings.h
//  WFConnector
//
//  Created by Michael Moore on 6/3/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a device settings record from a fitness device FIT file.
 */
@interface WFFitMesgDeviceSettings : NSObject
{
	/** \cond InterfaceDocs */
    
	FIT_DEVICE_SETTINGS_MESG stDeviceSettings;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_DEVICE_SETTINGS_MESG</c> structure containing the
 * data for this record.
 */
@property (nonatomic, readonly) FIT_DEVICE_SETTINGS_MESG* pstDeviceSettings;


/**
 * Initializes the WFFitMesgDeviceSettings with the contents of the specified FIT record.
 *
 * @param pstRecord A pointer to the FIT record used to initialize this instance.
 *
 * @return This WFFitMesgDeviceSettings instance.
 */
- (id)initWithRecord:(void*)pstRecord;

@end
