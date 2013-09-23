// Copyright (c) 2011 Nordic Semiconductor. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA.
// Terms and conditions of usage are described in detail in // NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
//
//  HistoryManager.h
//  FisicaUtility
//
//  Created by Michael Moore on 6/10/10.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFS.h>
#import "BTBPRecord.h"


@interface HistoryManager : NSObject
{
}


- (NSString*)getLastEmail;
- (NSDate*)getLastRefresh:(NSString*)key;
- (BOOL)duplicateBTBP:(NSDate*)date;
- (NSString*)getPasskey:(WFAntFSDeviceType_t)deviceType;
- (NSMutableDictionary*)getSensorInfo;
- (NSMutableDictionary*)getBTBPInfo;
- (NSMutableDictionary*)getCGMInfo;
- (void)savePasskey:(WFAntFSDeviceType_t)deviceType passkey:(NSString*)passkey;
- (void)saveCGMInfo:(NSDictionary*)infoDict;
- (NSMutableDictionary*)getSensorInfo;
- (NSString*)historyKeyForDeviceType:(WFAntFSDeviceType_t)deviceType;
- (NSArray*)loadHistory:(WFAntFSDeviceType_t)deviceType;
- (NSArray*)loadBTBPHistory;
- (void)saveLastEmail:(NSString*)emailAddress;
- (void)saveHistory:(WFAntFSDeviceType_t)deviceType fitRecords:(NSArray*)fitRecords;
- (void)saveBTBPRecord:(BTBPRecord *)record;

@end
