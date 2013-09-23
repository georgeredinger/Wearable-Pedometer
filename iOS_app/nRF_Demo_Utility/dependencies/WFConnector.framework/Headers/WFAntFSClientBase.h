//
//  WFAntFSClientBase.h
//  WFConnector
//
//  Created by Michael Moore on 1/28/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFSDevice.h>
#import <WFConnector/wf_antfs_types.h>


/** Represents the base class for ANT FS Client implementations. */
@interface WFAntFSClientBase : WFAntFSDevice
{
}

/**
 * Closes the ANT FS Client beacon.
 *
 * @return <c>TRUE</c> if the beacon was closed, otherwise <c>FALSE</c>.
 */
- (BOOL)closeBeacon;

/**
 * Opens the ANT FS Client beacon.
 *
 * @return <c>TRUE</c> if the beacon was opened, otherwise <c>FALSE</c>.
 */
- (BOOL)openBeacon;

/**
 * Adds the specified FIT file to the directory which will be available from
 * the client for download.
 *
 * The ANT FS Client will expose a directory of files available for download.
 * The directory is populated via this method, or implicitly through the
 * WFAntFSClientBase::specifySettings: method.
 *
 * @param filePath The path to the FIT file to be added.
 *
 * @return <c>TRUE</c> if the file was added, otherwise <c>FALSE</c>.
 */
- (BOOL)addFITFile:(NSString*)filePath;

/**
 * Creates a FIT settings file based on the specified parameters.
 *
 * A SETTINGS type FIT file will be created and added to the directory of files
 * available for download from the ANT FS Client.
 *
 * @param pstSettings A pointer to a ::WFFitnessEquipmentSettings_t structure
 * containing the settings.
 *
 * @return <c>TRUE</c> if the settings file was created, otherwise <c>FALSE</c>.
 */
- (BOOL)specifySettings:(WFFitnessEquipmentSettings_t*)pstSettings;

/**
 * Starts the ANT FS Client.
 *
 * @return <c>TRUE</c> if the ANT FS Client was started, otherwise <c>FALSE</c>.
 */
- (BOOL)startAntFSClient;

@end
