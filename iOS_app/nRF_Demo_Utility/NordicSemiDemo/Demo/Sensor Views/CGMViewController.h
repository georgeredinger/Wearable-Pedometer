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
//  CGMViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"
#import "CorePlot-CocoaTouch.h"
#import "GlucoseVC.h"
#import "GlucoseVCSettings.h"


@interface CGMViewController : NSSensorSimpleBaseVC <WFGlucoseDelegate, CPTPlotDataSource>
{
    uint8_t auc_tx_id[5];
    uint8_t auc_perm_key[4];

    UILabel* concentrationLabel;
    UILabel* battLevelLabel;
    UIImageView* trend;
    UIImageView* upperBounds;
    UIImageView* lowerBounds;
    UIImageView* graphBg;
    UIImageView* upperLine;
    UIImageView* lowerLine;
    int highValue;
    int lowValue;
    CPTGraphHostingView * graphView;
    CPTXYGraph * graph;
    CPTScatterPlot * linePlot;
    double testStamp;
    int testIncrement;
    GlucoseVC *glucoseVC;
    GlucoseVCSettings *gVCSettings;
    BOOL canPlaySound;
    BOOL soundHighAlert;
    BOOL soundLowAlert;
    BOOL soundRiseAlert;
    BOOL soundFallAlert;
    WFGlucoseRateAlertLevel_t riseAlertLevel;
    WFGlucoseRateAlertLevel_t fallAlertLevel;
    
}

@property (readonly, nonatomic) WFGlucoseConnection* glucoseConnection;
@property (retain, nonatomic) IBOutlet UILabel* concentrationLabel;
@property (retain, nonatomic) IBOutlet UILabel* battLevelLabel;
@property (retain, nonatomic) IBOutlet UIImageView* trend;
@property (retain, nonatomic) IBOutlet UIImageView* upperLine;
@property (retain, nonatomic) IBOutlet UIImageView* lowerLine;

@property (retain, nonatomic) IBOutlet CPTGraphHostingView * graphView;

-(void)soundAlert;

@end
