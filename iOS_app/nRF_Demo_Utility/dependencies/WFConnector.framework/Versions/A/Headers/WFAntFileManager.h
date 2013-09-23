/*
 *  WFAntFileManager.h
 *  WFConnector
 *
 *  Created by Michael Moore on 8/4/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFSDevice.h>


/**
 * Provides a means of communicating with, and transferring data from an
 * ANT FS device.
 */
@interface WFAntFileManager : WFAntFSDevice
{
}


/**
 * Initiates a connection request to the ANT FS device.
 *
 * @param pucPasskey A pointer to a buffer where the passkey used to
 * authenticate with the device is stored.
 *
 * @param ucLength The length of the passkey, in bytes.
 * 
 * @return <c>TRUE</c> if the connection request was initiated successfully,
 * otherwise <c>FALSE</c>.
 */
- (BOOL)connectToDevice:(UCHAR*)pucPasskey passkeyLength:(UCHAR)ucLength;

/**
 * The client serial number (as specified in the ANT FS Beacon).
 *
 * @return The 32-bit client serial number.
 */
- (ULONG)clientSerialNumber;

/**
 * The type of device managed by this WFAntFileManager.
 * 
 * @return A ::WFAntFSDeviceType_t representing the device type.
 */
- (WFAntFSDeviceType_t)deviceType;

/**
 * Destroys the connection to the device.
 *
 * @return <c>TRUE</c> if the disconnect request was sent successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)disconnectDevice;

/**
 * Returns a collection of WFFitRecord instances representing the records in
 * the FIT file at the specified path.
 *
 * @param filePath The path to the FIT file.
 * @param pbCancel A pointer to a <c>BOOL</c> used to cancel the FIT parsing
 * operation.  Set this value to <c>NULL</c> if the ability to cancel is not
 * desired.  Setting the value of the underlying <c>BOOL</c> to <c>TRUE</c>
 * during the FIT parsing operation will cancel the operation in progress.
 *
 * @return An array containing the file records.
 */
- (NSArray*)getFitRecordsFromFile:(NSString*)filePath cancelPointer:(volatile BOOL*)pbCancel;

/**
 * Initiates a request for directory information from the device.
 *
 * @return <c>TRUE</c> if the request was sent successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)requestDirectoryInfo;

/**
 * Initiates a request to download the file a the specified index.
 *
 * @param usFileIndex The file system index of the requested file.
 *
 * @param ulFileSize The size of the requested file, in bytes.
 *
 * @return <c>TRUE</c> if the request was sent successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)requestFile:(USHORT)usFileIndex fileSize:(ULONG)ulFileSize;

/**
 * Updates the passkey used to authenticate the connection.
 *
 * @note This does not modify the passkey stored on the device.
 *
 * @param pucPasskey A pointer to a buffer where the passkey used to
 * authenticate with the device is stored.
 *
 * @param ucLength The length of the passkey, in bytes.
 * 
 * @return <c>TRUE</c> if the passkey was updated successfully,
 * otherwise <c>FALSE</c>.
 */
- (BOOL)setDevicePasskey:(UCHAR*)pucPasskey passkeyLength:(UCHAR)ucLength;

/**
 * Initiates a request to set the time on the device to the current system
 * time.
 *
 * @return <c>TRUE</c> if the request was sent successfully, otherwise
 * <c>FALSE</c>.
 */
- (BOOL)setDeviceTime;

@end
