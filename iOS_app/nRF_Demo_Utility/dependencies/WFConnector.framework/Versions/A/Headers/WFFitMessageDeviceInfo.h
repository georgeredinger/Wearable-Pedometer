//
//  WFFitMessageDeviceInfo.h  (previously WFFitDeviceInfoRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 4/11/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a device info record from a fitness device FIT file.
 */
@interface WFFitMessageDeviceInfo : WFFitMessageBase
{
	/** \cond InterfaceDocs */
    
	FIT_DEVICE_INFO_MESG stDeviceInfo;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_DEVICE_INFO_MESG</c> structure containing the data
 * for this record.
 */
@property (nonatomic, readonly) FIT_DEVICE_INFO_MESG* pstDeviceInfo;

@end
