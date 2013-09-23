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
//  WFWeightScaleViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/12/10.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"


@interface WeightScaleViewController : NSSensorSimpleBaseVC
{
	BOOL bDataReceived;
	double_t lastWeight;
	double_t conversionFactor;
	
	UILabel* bodyWeightLabel;
	UILabel* sampledateLabel;
	UILabel* sampletimeLabel;
    
	UILabel* hydrationPercentLabel;
	UILabel* muscleMassLabel;
	UILabel* boneMassLabel;
    UILabel* bodyFatPercentLabel;
    
    UISegmentedControl* unitSwitch;
}


@property (readonly, nonatomic) WFWeightScaleConnection* wsConnection;
@property (nonatomic, retain) IBOutlet UILabel* bodyWeightLabel;
@property (retain, nonatomic) IBOutlet UILabel* sampledateLabel;
@property (retain, nonatomic) IBOutlet UILabel* sampletimeLabel;
@property (nonatomic, retain) IBOutlet UILabel* hydrationPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel* bodyFatPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel* muscleMassLabel;
@property (nonatomic, retain) IBOutlet UILabel* boneMassLabel;
@property (retain, nonatomic) IBOutlet UILabel *bodyFatTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *hydrationPercentTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *muscleMassTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *boneMassTextLabel;

@property (retain, nonatomic) IBOutlet UIImageView *antPlusLogo;
@property (retain, nonatomic) IBOutlet UIImageView *bluetoothSmartLogo;
@property (retain, nonatomic) IBOutlet UISegmentedControl* unitSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forNetwork:(WFNetworkType_t) newNetworkType;

- (IBAction)historyClicked:(id)sender;
- (IBAction)unitChanged:(id)sender;
- (IBAction)profileClicked:(id)sender;

- (void)displayLastRecord;
- (void)saveToHistory;

@end
