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
//  ConfigScrollerController.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/10/11.
//

#import <UIKit/UIKit.h>
#import "NordicModalDelegate.h"
#import "DDPageControl.h"

@interface ConfigScrollerController : UIViewController <UIScrollViewDelegate>
{   
    UIScrollView *scrollView;
	DDPageControl *pageControl;
    NSMutableArray *viewControllers;
    NSArray *contentArray;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    int pageCount;
    id <NordicModalDelegate> _delegate;
    NSString *configHelp;
    uint applicableNetworks;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) DDPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *contentArray;
@property (nonatomic, retain) id<NordicModalDelegate> delegate;
@property (nonatomic, retain) NSString *configHelp;
@property uint applicableNetworks;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controllersArray:(NSArray*)cArr;
- (void)changePage:(id)sender;
@end
