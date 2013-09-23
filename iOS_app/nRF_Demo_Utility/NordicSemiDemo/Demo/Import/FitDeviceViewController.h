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
//  FitDeviceViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/15/10.
//

#import <UIKit/UIKit.h>
#import "WFFitWatchManager.h"
#import "FitFileTableView.h"
#import <WFConnector/WFAntFS.h>
#import <MessageUI/MessageUI.h>


@class WFHardwareConnector;


@interface FitDeviceViewController : UIViewController <WFFitWatchManagerDelegate, MFMailComposeViewControllerDelegate>
{
	FitFileTableView* fileTableViewController;
    UILabel* statusLabel;
	UIActivityIndicatorView* connectingIndicator;
	UIButton* downloadButton;
    UIView* fileView;
    UIView* importView;
    UIView* authenticationView;
	UIView* searchView;
    UILabel* importStatusLabel;
    UIProgressView* importProgress;
    UILabel* devicesLabel;
    UILabel* searchingLabel;
    UILabel* pairDeviceLabel;
    UIImageView* pairInstructionsImage;
    
    WFFitWatchManager* fitWatchManager;
	WFAntFSDeviceType_t deviceType;
    BOOL bPasskeyLoaded;
}

@property WFAntFSDeviceType_t deviceType;
@property (retain, nonatomic) UIActivityIndicatorView* connectingIndicator;
@property (retain, nonatomic) IBOutlet UILabel* statusLabel;
@property (retain, nonatomic) IBOutlet FitFileTableView* fileTableViewController;
@property (retain, nonatomic) IBOutlet UIButton* downloadButton;
@property (retain, nonatomic) IBOutlet UIView* fileView;
@property (retain, nonatomic) IBOutlet UIView* authenticationView;
@property (retain, nonatomic) IBOutlet UIView* importView;
@property (retain, nonatomic) IBOutlet UIView* searchView;
@property (retain, nonatomic) IBOutlet UILabel* importStatusLabel;
@property (retain, nonatomic) IBOutlet UIProgressView* importProgress;
@property (retain, nonatomic) IBOutlet UILabel* devicesLabel;
@property (retain, nonatomic) IBOutlet UILabel* searchingLabel;
@property (retain, nonatomic) IBOutlet UILabel* pairDeviceLabel;
@property (retain, nonatomic) IBOutlet UIImageView* pairInstructionsImage;


- (IBAction)downloadClicked:(id)sender;
- (void)back:(id)sender;

- (NSString*)stringFromDeviceType:(WFAntFSDeviceType_t)devType;

@end
