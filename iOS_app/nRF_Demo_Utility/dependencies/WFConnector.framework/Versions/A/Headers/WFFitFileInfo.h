//
//  WFFitFileInfo.h
//  WFConnector
//
//  Created by Michael Moore on 6/15/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/common_types.h>


/**
 * Represents file structure information for the FIT file system.
 */
@interface WFFitFileInfo : NSObject
{
	/** \cond InterfaceDocs */

	USHORT  usFileIndex;
	UCHAR   ucFileDataType;
	UCHAR   ucFileSubType;
	USHORT  usFileNumber;
	UCHAR   ucSpecificFlags;
	UCHAR   ucGeneralFlags;
	ULONG   ulFileSize;
	NSDate* timestamp;

	/** \endcond */
}


/**
 * Gets or sets the data file index.
 *
 * This is the value used when referencing files for download, upload, and
 * erase.
 */
@property (nonatomic, assign) USHORT  usFileIndex;

/**
 * Gets or sets the data type of the file.
 *
 * The File Data Type informs the host how the file may be interpreted.
 */
@property (nonatomic, assign) UCHAR   ucFileDataType;

/**
 * Gets or sets the data sub-type of the .FIT file.
 */
@property (nonatomic, assign) UCHAR   ucFileSubType;

/**
 * Gets or sets the number used to identify a specific instance of a file
 * sub-type.
 *
 * Can refer to user, session number, etc.
 */
@property (nonatomic, assign) USHORT  usFileNumber;

/**
 * Gets or sets the bit-mapped flags of the data type specific permissions.
 *
 * Only bit 0 is used at this time, all others are reserved for future use.
 * Bit 0 specifies whether the file is selected by the user.
 */
@property (nonatomic, assign) UCHAR   ucSpecificFlags;

/**
 * Gets or sets the bit-mapped flags of file permissions.
 * 
 * Bit 0-2:  Reserved.<br />
 * Bit 3:  Append (can append to file only).<br />
 * Bit 4:  Archive (has been downloaded).<br />
 * Bit 5:  Erase (can be erased).<br />
 * Bit 6:  Write (can upload).<br />
 * BIt 7:  Read (can download).
 */
@property (nonatomic, assign) UCHAR   ucGeneralFlags;

/**
 * Gets or sets the size of the file in bytes.
 *
 * If file size is zero, then the file has not been uploaded, but may be
 * available for upload.
 */
@property (nonatomic, assign) ULONG   ulFileSize;

/**
 * Gets or sets the time the file was created.
 */
@property (nonatomic, retain) NSDate* timestamp;


/**
 * Returns the timestamp as a string formatted in short date time
 * (MM/DD/YY 12:00 AM).
 *
 * @return The formatted date string (MM/DD/YY 12:00 AM).
 */
- (NSString*)stringFromTimestamp;

@end
