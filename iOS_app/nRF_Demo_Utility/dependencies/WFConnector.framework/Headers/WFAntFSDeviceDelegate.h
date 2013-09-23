//
//  WFAntFSDeviceDelegate.h
//  WFConnector
//
//  Created by Michael Moore on 11/15/11.
//  Copyright (c) 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WFAntFSDevice;

/**
 * Defines the interface for callback methods used by the WFAntFSDevice and
 * its derived classes.
 *
 * This protocol defines the callback interface commonly used by all types of
 * ANT FS devices.  The WFAntFileManagerDelegate and WFClientDelegate extend this
 * protocol with the callback interface for host-mode or client-mode ANT FS
 * respectively.  It is not normally advisable to adopt the WFAntFSDeviceDelegate
 * protocol directly, but rather through the WFAntFileManagerDelegate or
 * WFAntFSClientDelegate, depending on the ANT FS mode.
 */
@protocol WFAntFSDeviceDelegate <NSObject>

@required

/**
 * Invoked when the WFAntFSDevice instance has been created.
 *
 * See the WFHardwareConnector::requestAntFSDevice:toDelegate: method for
 * documentation regarding instantiating a WFAntFSDevice.
 *
 * @note This method is REQUIRED for classes adopting the WFAntFSDeviceDelegate
 * protocol.
 *
 * @param fsDevice The WFAntFSDevice instance.  This instance is passed as the
 * base class WFAntFSDevice.  As this base class does not define functionallity
 * useful to the application, the reference should be cast to the specific type
 * appropriate for the ::WFAntFSDeviceType_t requested.  For example, if
 * ::WF_ANTFS_DEVTYPE_GARMIN_FR310 was specified in the
 * WFHardwareConnector::requestAntFSDevice:toDelegate: call, the specific type
 * of the instance returned is WFGarminFR310Manager.
 *
 * @param bSuccess <c>TRUE</c> if the instance was created, otherwise <c>FALSE</c>.
 */
- (void)antFSDevice:(WFAntFSDevice*)fsDevice instanceCreated:(BOOL)bSuccess;

@end
