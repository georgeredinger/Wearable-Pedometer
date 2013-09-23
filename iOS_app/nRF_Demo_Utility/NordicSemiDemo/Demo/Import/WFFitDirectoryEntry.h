// Copyright (c) 2011 Nordic Semiconductor. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA.
// Terms and conditions of usage are described in detail in // NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
//
//
//  WFFitDirectoryEntry.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 4/18/11.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFS.h>


@interface WFFitDirectoryEntry : NSObject
{
    WFFitFileInfo* fileInfo;
    BOOL isSelected;
    BOOL hasBeenImported;
}


@property (nonatomic, readonly) WFFitFileInfo* fileInfo;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL hasBeenImported;


- (NSString*)filePath;
- (id)initWithFileInfo:(WFFitFileInfo*)info;


+ (NSArray*)directoryEntriesFromFileArray:(NSArray*)fileArray includeImported:(BOOL)bImported;

@end
