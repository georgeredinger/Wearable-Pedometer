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
//  BPHistoryViewController.h
//  NordicSemiDemo
//
//  Created by Chip on 6/9/10.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>


@interface BPHistoryViewController : UITableViewController
{
	NSArray* fitRecords;
    NSArray* btRecords;
    WFNetworkType_t networkType;
}


@property (nonatomic, retain) NSArray* fitRecords;
@property (nonatomic, retain) NSArray* btRecords;
@property WFNetworkType_t networkType;

@end
