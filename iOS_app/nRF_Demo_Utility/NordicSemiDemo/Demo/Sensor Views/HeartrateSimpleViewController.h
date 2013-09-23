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
//  HeartrateSimpleViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "NSSensorSimpleBaseVC.h"

@interface HeartrateSimpleViewController : NSSensorSimpleBaseVC <CPTPlotDataSource>
{
    UILabel* computedHeartrateLabel;
    UILabel* battLevelLabel;
    UIImageView *ANTLogo;
    UIImageView *BTLogo;
    
    UIImageView* graphBg;
    CPTGraphHostingView * graphView;
    CPTXYGraph * graph;
    CPTScatterPlot * linePlot;
    double validTimestamp;
}

@property (readonly, nonatomic) WFHeartrateConnection* heartrateConnection;
@property (retain, nonatomic) IBOutlet UILabel* computedHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* battLevelLabel;
@property (retain, nonatomic) IBOutlet UIImageView *ANTLogo;
@property (retain, nonatomic) IBOutlet UIImageView *BTLogo;
@property (retain, nonatomic) IBOutlet CPTGraphHostingView * graphView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forNetwork:(WFNetworkType_t)network;

@end
