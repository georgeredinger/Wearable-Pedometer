///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012 Nordic Semiconductor. All Rights Reserved.
// Copyright (c) 2012 Wahoo Fitness. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA and Wahoo Fitness LLC.
// Terms and conditions of usage are described in detail in
// NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
///////////////////////////////////////////////////////////////////////////////
//
//  HistoryManager.h
//  FisicaUtility
//
//  Created by Michael Moore on 6/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFS.h>


@interface HistoryManager : NSObject
{
}


- (NSString*)getLastEmail;
- (NSDate*)getLastRefresh:(WFAntFSDeviceType_t)deviceType;
- (NSString*)getPasskey:(WFAntFSDeviceType_t)deviceType;
- (void)savePasskey:(WFAntFSDeviceType_t)deviceType passkey:(NSString*)passkey;
- (NSMutableDictionary*)getSensorInfo;
- (NSString*)historyKeyForDeviceType:(WFAntFSDeviceType_t)deviceType;
- (NSArray*)loadHistory:(WFAntFSDeviceType_t)deviceType;
- (void)saveLastEmail:(NSString*)emailAddress;
- (void)saveHistory:(WFAntFSDeviceType_t)deviceType fitRecords:(NSArray*)fitRecords;

@end
