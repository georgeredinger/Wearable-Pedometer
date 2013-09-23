/*
 *  WFAntFileManagerDelegate.h
 *  WFConnector
 *
 *  Created by Michael Moore on 6/4/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#import <WFConnector/wf_antfs_types.h>
#import <WFConnector/WFAntFSDeviceDelegate.h>

@class WFAntFileManager;
@class WFAntFSDirectory;



/**
 * The WFAntFileManagerDelegate protocol declares the interface that
 * WFAntFileManager delegates must implement.
 *
 * The WFAntFileManagerDelegate protocol should be adopted in classes where
 * ANT FS data is processed.  It is common to adopt this protocol in the same
 * class where the WFAntFileManager instance is created, but this is not
 * strictly necessary.  Status updates and request responses will be delivered
 * to the delegate.
 *
 * @note This protocol inherits methods of the WFAntFSDeviceDelegate protocol.
 */
@protocol WFAntFileManagerDelegate <WFAntFSDeviceDelegate>

@required

/**
 * Alerts the delegate that the WFAntFileManager has finished a download.
 *
 * @param antFileManager The delegating WFAntFileManager instance.
 *
 * @param bSuccess <c>TRUE</c> if the download was successful, otherwise
 * <c>FALSE</c>.
 *
 * @param filePath The path to the downloaded FIT file.
 */
- (void)antFileManager:(WFAntFileManager*)antFileManager downloadFinished:(BOOL)bSuccess filePath:(NSString*)filePath;

/**
 * Alerts the delegate that the device passkey has been updated.
 *
 * This method gives the delegate an opportunity to store the device passkey
 * after a pairing operation.  The passkey should be stored and used in
 * future authentication requests.  This avoids the need to pair every time
 * the device is connected.
 *
 * @param antFileManager The delegating WFAntFileManager instance.
 *
 * @param pucPasskey A pointer to the buffer where the updated passkey is
 * located.
 *
 * @param ucLength The length of the passkey, in bytes.
 */
- (void)antFileManager:(WFAntFileManager*)antFileManager updatePasskey:(UCHAR*)pucPasskey length:(UCHAR)ucLength;


@optional

/**
 * Alerts the delegate that the WFAntFileManager instance received a response
 * to a request for directory information.
 *
 * @param antFileManager The delegating WFAntFileManager instance.
 *
 * @param directoryInfo A WFAntFSDirectory instance containing the directory
 * information for the device.
 */
- (void)antFileManager:(WFAntFileManager*)antFileManager receivedDirectoryInfo:(WFAntFSDirectory*)directoryInfo;

/**
 * Alerts the delegate that the WFAntFileManager instance received a response
 * from the device.
 *
 * @param antFileManager The delegating WFAntFileManager instance.
 *
 * @param responseCode The ::ANTFS_RESPONSE response code sent from the device.
 */
- (void)antFileManager:(WFAntFileManager*)antFileManager receivedResponse:(ANTFS_RESPONSE)responseCode;

/**
 * Alerts the delegate of file download progress.
 *
 * @param antFileManager The delegating WFAntFileManager instance.
 *
 * @param bytesReceived The total number of bytes that have been received.
 */
- (void)antFileManager:(WFAntFileManager*)antFileManager downloadProgress:(ULONG)bytesReceived;

/**
 * Alerts the delegate of progress status while parsing a FIT file.
 *
 * @param antFileManager The delegating WFAntFileManager instance.
 *
 * @param progress The current progress represented by a floating-point value between 0.0
 * and 1.0, inclusive, where 1.0 indicates the completion of the task.
 */
- (void)antFileManager:(WFAntFileManager*)antFileManager parseFITProgress:(float)progress;

@end