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
//  FitFileTableView.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/15/10.
//

#import <UIKit/UIKit.h>


@class FitDeviceViewController;


@interface FitFileTableView : UITableViewController
{
	NSArray* fileRecords;
	FitDeviceViewController* fitViewController;
}


@property (nonatomic, retain) NSArray* fileRecords;
@property (nonatomic, retain) IBOutlet FitDeviceViewController* fitViewController;


- (void)clearFileTable;

@end
