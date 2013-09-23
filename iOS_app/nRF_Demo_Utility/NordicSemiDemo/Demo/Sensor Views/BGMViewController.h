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
//  BGMViewController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import <UIKit/UIKit.h>
#import "NSSensorSimpleBaseVC.h"
#import "BTGlucoseVC.h"

@interface BGMViewController : NSSensorSimpleBaseVC <WFBTLEGlucoseDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UILabel *battLevel;
    NSMutableArray* records;
    UITableView* recordTable;
    BTGlucoseVC * glucoseVC;
}

@property (readonly, nonatomic) WFBTLEGlucoseConnection* glucoseConnection;
@property (retain, nonatomic) IBOutlet UILabel* battLevel;
@property (nonatomic, retain) IBOutlet UITableView* recordTable;


- (IBAction)retrieveFirstClicked:(id)sender;
- (IBAction)retrieveLastClicked:(id)sender;
- (IBAction)retrieveAllClicked:(id)sender;

@end
