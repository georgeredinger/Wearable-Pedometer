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
//  WeightHistoryViewController.h
//  WeightScale
//
//  Created by Michael Moore on 6/4/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFAntFS.h>


@class WFHardwareConnector;


@interface WeightHistoryViewController : UITableViewController <WFAntFileManagerDelegate>
{
	NSArray* fitRecords;
	double_t conversionFactor;

	UCHAR aucDevicePassword[WF_ANTFS_PASSWORD_MAX_LENGTH];
	UCHAR ucDevicePasswordLength;
	WFAntFSDeviceType_t deviceType;
	
	WFHardwareConnector* hardwareConnector;
	WFWeightScaleManager* wsFileManager;
	
	UIActivityIndicatorView* activityIndicator;
}


@property (nonatomic, retain) WFHardwareConnector* hardwareConnector;
@property (nonatomic, retain) NSArray* fitRecords;
@property (nonatomic, assign) double_t conversionFactor;


- (void)connectToDevice;
- (void)disconnectDevice;
- (void)loadPasskey;
- (void)updateDisplay;

@end
