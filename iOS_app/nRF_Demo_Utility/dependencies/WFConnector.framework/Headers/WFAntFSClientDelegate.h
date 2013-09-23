//
//  WFAntFSClientDelegate.h
//  WFConnector
//
//  Created by Michael Moore on 12/14/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <WFConnector/wf_antfs_types.h>
#import <WFConnector/WFAntFSDeviceDelegate.h>


@class WFAntFSClientBase;


/**
 * Defines the interface for callback methods used by the WFAntFSClientBase.
 *
 * @note This protocol inherits methods of the WFAntFSDeviceDelegate protocol.
 */
@protocol WFAntFSClientDelegate <WFAntFSDeviceDelegate>

@optional

/**
 * Invoked when the ANT FS Client has connected to a host.
 *
 * @param fsClient The WFAntFSClientBase instance.
 * @param bAuthenticated <c>TRUE</c> if the host has authenticated, otherwise <c>FALSE</c>.
 */
- (void)antFSClient:(WFAntFSClientBase*)fsClient connectedDevice:(BOOL)bAuthenticated;

/**
 * Invoked when the ANT FS Client encounters an error.
 *
 * @param fsClient The WFAntFSClientBase instance.
 * @param error A ::WFAntFSClientError_t value indicating the type of error.
 */
- (void)antFSClient:(WFAntFSClientBase*)fsClient encounteredError:(WFAntFSClientError_t)error;

/**
 * Invoked when the ANT FS Client receives a response from the ANT device.
 *
 * @param fsClient The WFAntFSClient instance.
 * @param responseCode An ::ANTFS_RESPONSE value indicating the type of response.
 */
- (void)antFSClient:(WFAntFSClientBase*)fsClient receivedResponse:(ANTFS_RESPONSE)responseCode;

@end
