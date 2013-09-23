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
//  WFFitWatchManager.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 4/15/11.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFS.h>

@class WFHardwareConnector;
@class WFFitDeviceManager;

typedef enum
{
    WF_FIT_IMPORT_STATE_DOWNLOAD,
    WF_FIT_IMPORT_STATE_PARSE,
    WF_FIT_IMPORT_STATE_PROCESS,
    
} WFFitImportState_t;

@class WFFitWatchManager;
@protocol WFFitWatchManagerDelegate <NSObject>

- (void)fitWatch:(WFFitWatchManager*)fitWatch deviceConnected:(WFAntFSDeviceType_t)devType;
- (void)fitWatch:(WFFitWatchManager*)fitWatch didFailAuthentication:(BOOL)bFailed;
- (void)fitWatch:(WFFitWatchManager*)fitWatch didFinishImport:(BOOL)bSuccess;
- (void)fitWatch:(WFFitWatchManager*)fitWatch didFailToCreateInstance:(BOOL)bFailed;


@optional

- (void)fitWatch:(WFFitWatchManager*)fitWatch didReceiveDirectoryInfo:(NSArray*)directoryEntries;
- (void)fitWatch:(WFFitWatchManager*)fitWatch didUpdateProgress:(float)progress forState:(WFFitImportState_t)fitState;

@end


@interface WFFitWatchManager : NSObject <WFHardwareConnectorDelegate, WFAntFileManagerDelegate>
{
    id <WFFitWatchManagerDelegate> delegate;
    id <WFHardwareConnectorDelegate> hwConnDelegate;
	WFHardwareConnector* hardwareConnector;
	WFFitDeviceManager* afsFileManager;
	WFAntFSDeviceType_t connectedDeviceType;
    WFAntFSDeviceType_t importingFromDeviceType;
    BOOL bShouldBeConnected;
	
	UCHAR aucDevicePassword[WF_ANTFS_PASSWORD_MAX_LENGTH];
	UCHAR ucDevicePasswordLength;
    
    NSArray* directoryEntries;
    NSArray* filesToImport;
    int importIndex;
	ULONG ulFileSize;
    int remainingFileCount;
	NSMutableArray* importedSessions;
    
    NSTimer* progressTimer;
    volatile BOOL bCancel;
    volatile int processedRecordCount;
    int totalRecordCount;
    BOOL bDebugging;
}


@property (nonatomic, retain) id <WFFitWatchManagerDelegate> delegate;

- (BOOL)beginConnection;
- (BOOL)beginImport:(NSArray*)files;
//- (void)debugImport:(NSString*)fitName;
- (BOOL)endConnection;
- (BOOL)loadPasskey;

@end
