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
//  BPHistoryViewController.h
//  FisicaUtility
//
//  Created by Chip on 6/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BPHistoryViewController : UITableViewController
{
	NSArray* fitRecords;
}


@property (nonatomic, retain) NSArray* fitRecords;

@end
