//
//  WFAntFSDevice.h
//  WFConnector
//
//  Created by Michael Moore on 11/15/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFSDeviceDelegate.h>


/** Represents the base class for ANT FS device implementations. */
@interface WFAntFSDevice : NSObject
{
}


/**
 * Gets or sets the instance which will handle delegated methods for the
 * WFAntFSDevice.
 *
 * @note  The WFAntFSDeviceDelegate protocol defines common functionallity for
 * all types of ANT FS devices.  The WFAntFileManagerDelegate and WFAntFSClientDelegate
 * protocols extend this protocol for the specific FS mode.  The delegate property
 * should be set to a delegate of the appropriate specific protocol for the mode.
 * As of API v2.1.3, this would be WFAntFileManagerDelegate for ANT FS devices
 * using host mode, and WFAntFSClientDelegate for client mode devices.
 */
@property (nonatomic, retain) id<WFAntFSDeviceDelegate> delegate;

@end
