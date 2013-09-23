//
//  WFHardwareConnector+AntFS.h
//  WFConnector
//
//  Created by Michael Moore on 6/23/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFHardwareConnector.h>
#import <WFConnector/WFAntFileManagerDelegate.h>
#import <WFConnector/WFAntFSClientDelegate.h>


@class WFAntFileManager;
@class WFAntFSClientBase;


/**
 * A category on the WFHardwareConnector class which facilitates communications
 * with devices which use ANT FS to transfer data.
 */
@interface WFHardwareConnector (AntFS)

/**
 * Releases resources used by the specified WFAntFSDevice.
 *
 * @note The WFAntFSDevice requires resources which are allocated
 * and maintained by the Wahoo Fitness API.  Instances should be
 * created via the WFHardwareConnector::requestAntFSDevice:toDelegate:
 * method, and released via this method.  Please do not invoke the
 * NSObject::release directly on the WFAntFSDevice instance.  Doing
 * so will not properly release all resources used by the API during the
 * life of the WFAntFSDevice instance.
 * <br /><br />
 * It is best not to retain the WFAntFSDevice instance, but rather to
 * use assignment when passing a reference.  If retain must be used, take care
 * to use a corresponding release to ensure that the retain count returns
 * to one, and not below before invoking this method.
 *
 * @param fsDevice  The WFAntFSDevice instance to be released.
 *
 * @return <c>TRUE</c> if resources were released successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)releaseAntFSDevice:(WFAntFSDevice*)fsDevice;

/**
 * Requests that a WFAntFSDevice instance be created and initialized.
 *
 * @note The ANT file manager requires resources which are allocated and
 * maintained by the Wahoo Fitness API.  Please be sure to invoke the
 * WFHardwareConnector::releaseAntFSDevice: method to release resources
 * when the instance is no longer needed.  Failing to do this will result in
 * a memory leak.
 *
 * @param deviceType The type of device for which the WFAntFSDevice is to
 * be created.  ANT FS profiles are different among device types, the specific
 * type of ANT FS Device created will be the type which is able to process
 * files for the specified device type.
 *
 * @param theDelegate The delegate which will be alerted when the ANT FS
 * Device instance is ready.  The ANT FS Device creation is an asynchronous
 * operation.  This method will return immediately, and the delegate method
 * will be invoked when the operation is complete (see the note on the
 * WFAntFSDevice::delegate property for more details).
 *
 * @return <c>TRUE</c> if the ANT FS Device creation operation is started
 * successfully, otherwise <c>FALSE</c>.
 */
- (BOOL)requestAntFSDevice:(WFAntFSDeviceType_t)deviceType toDelegate:(id<WFAntFSDeviceDelegate>)theDelegate;

@end
