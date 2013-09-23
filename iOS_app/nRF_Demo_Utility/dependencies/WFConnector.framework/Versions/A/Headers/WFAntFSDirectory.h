//
//  WFAntFSDirectory.h
//  WFConnector
//
//  Created by Michael Moore on 6/3/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/wf_antfs_types.h>

@class WFFitSettingsFileData;


/**
 * Represents an ANT FS Directory.
 */
@interface WFAntFSDirectory : NSObject
{
	/** \cond InterfaceDocs */
    
    NSData* dataBuffer;
    ULONG numberOfEntries;
    WFFitSettingsFileData* settingsFileData;
    BOOL settingsFileRequested;
    
	/** \endcond */
}


/** Gets a pointer to the directory header. */
@property (nonatomic, readonly) ANTFS_DIRECTORY_HEADER* pstHeader;
/** Gets the number of entries in the directory. */
@property (nonatomic, readonly) ULONG numberOfEntries;
/** Gets the settings file data. */
@property (nonatomic, retain) WFFitSettingsFileData* settingsFileData;

/** \cond InterfaceDocs */
/**
 * Gets a boolean value indicating whether the settings file has been requested.
 *
 * @note This property is for internal use.
 */
@property (nonatomic, assign) BOOL settingsFileRequested;
/** \endcond */


/**
 * Returns the directory entry at the specified index.
 *
 * @param ulIndex The index of the directory entry to retrieve.
 *
 * @return The ANTFSP_DIRECTORY at the specified index.
 */
- (ANTFSP_DIRECTORY*)entryAtIndex:(ULONG)ulIndex;

/**
 * Initializes this WFAntFSDirectory with the specified buffer.
 *
 * @param pBuffer The buffer containing the directory structure.
 *
 * @param ulLength The length of the buffer.
 *
 * @return This WFAntFSDirectory instance.
 */
- (id)initWithBuffer:(UCHAR*)pBuffer bufferLength:(ULONG)ulLength;

/**
 * Returns a collection of WFFitFileInfo instances representing the file system
 * information for FIT ACTIVITY files in the directory.
 *
 * @return An array containing the file information records.
 */
- (NSArray*)getActivityEntries;


@end
