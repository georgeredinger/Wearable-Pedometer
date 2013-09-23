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
//  ConfigScrollerController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/10/11.
//

#import "ConfigScrollerController.h"
#import "HeartrateViewController.h"
#import "BikeCadenceViewController.h"
#import "BikePowerViewController.h"
#import "BikeSpeedViewController.h"
#import "BikeSpeedCadenceViewController.h"
#import "FootpodViewController.h"
#import "NordicNavigationBar.h"
#import "WFSensorCommonViewController.h"
#import "ConfigAndHelpView.h"
#import "HelpViewController.h"

@interface ConfigScrollerController(PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (WFSensorCommonViewController*)allocSensorController:(NSString*)nibName;
- (void)back:(id)sender;
@end

@implementation ConfigScrollerController

@synthesize scrollView, pageControl, viewControllers, contentArray, configHelp, applicableNetworks;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controllersArray:(NSArray*)cArr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization with cArr
        pageCount = [cArr count];
        [self setContentArray:cArr];
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < pageCount; i++)
        {
            [controllers addObject:[NSNull null]];
        }
        self.viewControllers = controllers;
        [controllers release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* titleImage = [UIImage imageNamed:@"NORDIC-LOGO.png"];
    UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [titleView addSubview:titleImageView];
    titleImageView.center = titleView.center;
    CGRect titleImageViewFrame = titleImageView.frame;
    titleImageView.frame = titleImageViewFrame;
    self.navigationItem.titleView = titleView;
    [titleImageView release];
    [titleView release];
    
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"NordicNavbar.png"]];
    // Create a custom back button
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
    ConfigAndHelpView *btns = [nib objectAtIndex:0];
    
    btns.configButton.hidden = YES;
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
    
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease] animated:YES];
    // Do any additional setup after loading the view from its nib.
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageCount, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl = [[DDPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-10.0f)] ;
	[pageControl setNumberOfPages: pageCount] ;
	[pageControl setCurrentPage: 0] ;
	[pageControl addTarget: self action: @selector(changePage:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor blackColor]] ;
	[pageControl setOffColor: [UIColor blackColor]] ;
	[pageControl setIndicatorDiameter: 8.0f] ;
	[pageControl setIndicatorSpace: 10.0f] ;
	[self.view addSubview: pageControl] ;
	[pageControl release] ;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [viewControllers release];
    [scrollView release];
    [contentArray release];
    [super dealloc];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= pageCount)
        return;
    
    // replace the placeholder if necessary
    WFSensorCommonViewController * controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        NSString *nibName = [contentArray objectAtIndex:page];
        controller = [self allocSensorController:nibName];
        controller.applicableNetworks = applicableNetworks;
        controller.parentNavController = self.navigationController;
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    } 
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.bounds.size.width ;
    float fractionalPage = scrollView.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (scrollView.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
    //  load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:nearestNumber - 1];
    [self loadScrollViewWithPage:nearestNumber];
    [self loadScrollViewWithPage:nearestNumber + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}


- (void)changePage:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
    int page = thePageControl.currentPage;
	NSLog(@"wants page %d", page );
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	
	// we need to scroll to the new index
	[scrollView setContentOffset: CGPointMake(scrollView.bounds.size.width * page, scrollView.contentOffset.y) animated: YES] ;
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.configHelp ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

- (void)back:(id)sender
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
}


- (WFSensorCommonViewController*)allocSensorController:(NSString*)nibName
{
    if ([nibName isEqualToString:@"HeartrateViewController"]) {
        HeartrateViewController* vc = [[HeartrateViewController alloc] initWithNibName:@"HeartrateViewController" 
                                                                                bundle:nil forSensor:WF_SENSORTYPE_HEARTRATE];
        return vc;
    } else if ([nibName isEqualToString:@"BikeCadenceViewController"]) {
        BikeCadenceViewController* vc = [[BikeCadenceViewController alloc] initWithNibName:@"BikeCadenceViewController" 
                                                                                    bundle:nil forSensor:WF_SENSORTYPE_BIKE_CADENCE];
        return vc;
    } else if ([nibName isEqualToString:@"BikePowerViewController"]) {
        BikePowerViewController* vc = [[BikePowerViewController alloc] initWithNibName:@"BikePowerViewController" 
                                                                                bundle:nil forSensor:WF_SENSORTYPE_BIKE_POWER];
        return vc;
    } else if ([nibName isEqualToString:@"BikeSpeedViewController"]) {
        BikeSpeedViewController* vc = [[BikeSpeedViewController alloc] initWithNibName:@"BikeSpeedViewController" 
                                                                                bundle:nil  forSensor:WF_SENSORTYPE_BIKE_SPEED];
        return vc;
    } else if ([nibName isEqualToString:@"BikeSpeedCadenceViewController"]) {
        BikeSpeedCadenceViewController* vc = [[BikeSpeedCadenceViewController alloc] initWithNibName:@"BikeSpeedCadenceViewController" 
                                                                                              bundle:nil forSensor:WF_SENSORTYPE_BIKE_SPEED_CADENCE];
        return vc;
    } else if ([nibName isEqualToString:@"FootpodViewController"]) {
        FootpodViewController* vc = [[FootpodViewController alloc] initWithNibName:@"FootpodViewController" 
                                                                            bundle:nil forSensor:WF_SENSORTYPE_FOOTPOD];
        return vc;
    } else {
        return nil;
    }
}

@end
