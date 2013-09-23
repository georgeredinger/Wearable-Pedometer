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
//  FitDeviceViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/15/10.
//

#import "FitDeviceViewController.h"
#import "WFFitDirectoryEntry.h"

#import "NordicNavigationBar.h"
#import "ConfigAndHelpView.h"


#define KEY_GARMIN_WATCH                    @"Garmin Watch"
#define KEY_GARMIN_FR_60                    @"Garmin FR 60/70"
#define KEY_GARMIN_FR_60_PAIR_IMAGE         @"60pairfisica"
#define KEY_GARMIN_FR_310                   @"Garmin FR 310 XT"
#define KEY_GARMIN_FR_310_PAIR_IMAGE        @"310XTpairfisica"
#define KEY_GARMIN_FR_405                   @"Garmin FR 405"
#define KEY_GARMIN_FR_610                   @"Garmin FR 610"
#define KEY_GARMIN_FR_610_PAIR_IMAGE        @"610pairfisica"


#if DBG_FLAG_FIT_WATCH
//
#define DBG_FLAG_FW_STATUS      TRUE
#define DBG_FLAG_PUBLIC         TRUE
#define DBG_FLAG_PRIVATE        TRUE
#define DBG_FLAG_EVENT          TRUE
//
#else
//
#define DBG_FLAG_FW_STATUS      FALSE
#define DBG_FLAG_PUBLIC         FALSE
#define DBG_FLAG_PRIVATE        FALSE
#define DBG_FLAG_EVENT          FALSE
//
#endif


@interface FitDeviceViewController (_PRIVATE_)

- (void)loadAuthenticationView;

@end


@implementation FitDeviceViewController

@synthesize deviceType;
@synthesize fileTableViewController;
@synthesize statusLabel;
@synthesize connectingIndicator;
@synthesize downloadButton;
@synthesize fileView;
@synthesize authenticationView;
@synthesize importView;
@synthesize searchView;
@synthesize importStatusLabel;
@synthesize importProgress;
@synthesize devicesLabel;
@synthesize searchingLabel;
@synthesize pairDeviceLabel;
@synthesize pairInstructionsImage;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    fitWatchManager.delegate = nil;
    [fitWatchManager release];
	[fileTableViewController release];
    [statusLabel release];
	[connectingIndicator release];
	[downloadButton release];
    [fileView release];
    [authenticationView release];
    [importView release];
    [searchView release];
    [importStatusLabel release];
    [importProgress release];
    [devicesLabel release];
    [searchingLabel release];
	[pairDeviceLabel release];
    [pairInstructionsImage release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
	[super viewDidLoad];

    deviceType = WF_ANTFS_DEVTYPE_GARMIN_WATCH;
	self.navigationItem.title = [self stringFromDeviceType:deviceType];
	downloadButton.enabled = FALSE;
    
    devicesLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", KEY_GARMIN_FR_60, KEY_GARMIN_FR_310, KEY_GARMIN_FR_610];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];
	
    if (fitWatchManager == nil) {
        // create the watch manager.
        fitWatchManager = [[WFFitWatchManager alloc] init];
        fitWatchManager.delegate = self;
        
        /*
        // DEBUG:  FIT import.
        self.view = importView;
        NSString* fitName = @"2011-04-23-064511";
        [fitWatchManager debugImport:fitName];
        return;
        */

        
        // initiate the FIT watch connection..
        [fitWatchManager beginConnection];
        searchingLabel.text = @"Searching for device...";
        
        // create the activity indicator.
        connectingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [connectingIndicator startAnimating];
        UIBarButtonItem* activityItem = [[UIBarButtonItem alloc] initWithCustomView:connectingIndicator];
        self.navigationItem.rightBarButtonItem = activityItem;
        [activityItem release];
        
        statusLabel.text = @"Searching for device...";
        
        
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
      /*  
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
        ConfigAndHelpView *btns = [nib objectAtIndex:0];
        
        btns.configButton.hidden = YES;
        [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
        [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
        [twoButtons release];
       */ 
        UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease] animated:YES];
    }
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    
	[super viewWillDisappear:animated];
    
    // close the FIT connection and release the watch manager.
  //  [fitWatchManager endConnection];
  //  [fitWatchManager release];
  //  fitWatchManager = nil;
}


#pragma mark -
#pragma mark WFFitWatchManagerDelegate Implementation

//--------------------------------------------------------------------------------
- (void)fitWatch:(WFFitWatchManager*)fitWatch deviceConnected:(WFAntFSDeviceType_t)devType
{
    
    // set the device type and update the display.
	deviceType = devType;
	downloadButton.enabled = FALSE;
    NSString* deviceName = [self stringFromDeviceType:devType];
	self.navigationItem.title = deviceName;
    searchingLabel.text = [NSString stringWithFormat:@"Found %@...", deviceName];
    
	// initialize the device passkey.
    bPasskeyLoaded = [fitWatchManager loadPasskey];
    NSLog(@"fwDeviceConnected passkeyLoaded=%@", bPasskeyLoaded?@"TRUE":@"FALSE");
    if ( !bPasskeyLoaded)
    {
        [self loadAuthenticationView];
    }
	
    // clear the directory table.
    [fileTableViewController clearFileTable];
	[(UITableView*)fileTableViewController.view reloadData];
}

//--------------------------------------------------------------------------------
- (void)fitWatch:(WFFitWatchManager*)fitWatch didFailAuthentication:(BOOL)bFailed
{
    NSLog(@"fwDidFailAuthentication bFailed=%d", bFailed);
    
    // there are two ANT FS responses that trigger the didFailAuthentication.
    // the AUTHENTICATE_FAIL and AUTHENTICATE_REJECT.  if the authentication
    // is rejected, the bFail flag will be FALSE.  the cause for this is
    // typically an invalid passkey.
    if ( !bFailed )
    {
        [self loadAuthenticationView];
    }
}

//--------------------------------------------------------------------------------
- (void)fitWatch:(WFFitWatchManager*)fitWatch didFailToCreateInstance:(BOOL)bFailed
{
    NSLog(@"fwDidFailToCreateInstance bFailed=%d", bFailed);
}

//--------------------------------------------------------------------------------
- (void)fitWatch:(WFFitWatchManager*)fitWatch didFinishImport:(BOOL)bSuccess
{
    NSLog(@"fwDidFinishImport bSuccess=%d", bSuccess);
    
	if (bSuccess)
	{
        [fitWatch endConnection];
        [self.navigationController popViewControllerAnimated:TRUE];
	}
}

//--------------------------------------------------------------------------------
- (void)fitWatch:(WFFitWatchManager*)fitWatch didReceiveDirectoryInfo:(NSArray*)directoryEntries
{
    NSLog(@"fwDidReceiveDirectoryInfo");
    
    // stop the searching animation and set the status.
    [connectingIndicator stopAnimating];
    statusLabel.text = @"Ready to Download";
    
    // ensure the file view is shown.
    if ( self.view != fileView )
    {
        self.view = fileView;
    }

    // show the directory entries.
	fileTableViewController.fileRecords = [WFFitDirectoryEntry directoryEntriesFromFileArray:directoryEntries includeImported:FALSE];
    downloadButton.enabled = TRUE;
    [(UITableView*)fileTableViewController.view reloadData];
}

//--------------------------------------------------------------------------------
- (void)fitWatch:(WFFitWatchManager*)fitWatch didUpdateProgress:(float)progress forState:(WFFitImportState_t)fitState
{
    importProgress.progress = progress;
    
    switch (fitState)
    {
        case WF_FIT_IMPORT_STATE_DOWNLOAD:
            importStatusLabel.text = @"Downloading FIT...";
            break;
            
        case WF_FIT_IMPORT_STATE_PARSE:
            importStatusLabel.text = @"Parsing FIT...";
            break;
            
        case WF_FIT_IMPORT_STATE_PROCESS:
            importStatusLabel.text = @"Processing FIT...";
            break;
            
        default:
            importStatusLabel.text = @"";
            break;
    }
}


#pragma mark -
#pragma mark FitDeviceViewController Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)loadAuthenticationView
{
    NSLog(@"loadAuthenticationView");
    if ( self.view != authenticationView)
    {
        // load the pairing view.
        self.view = authenticationView;
    }
    
    // configure the pairing view.
    pairDeviceLabel.text = [NSString stringWithFormat:@"Found unpaired %@", [self stringFromDeviceType:deviceType]];
    
    // set the instruction image.
    UIImage* img = nil;
    NSLog(@"devType is %@", [self stringFromDeviceType:deviceType]);
    switch ( deviceType )
    {
        case WF_ANTFS_DEVTYPE_GARMIN_FR60:
            img = [UIImage imageNamed:KEY_GARMIN_FR_60_PAIR_IMAGE];
            break;
        case WF_ANTFS_DEVTYPE_GARMIN_FR310:
            img = [UIImage imageNamed:KEY_GARMIN_FR_310_PAIR_IMAGE];
            break;
        case WF_ANTFS_DEVTYPE_GARMIN_FR610:
            img = [UIImage imageNamed:KEY_GARMIN_FR_610_PAIR_IMAGE];
            break;
        default:
            img = [UIImage imageNamed:KEY_GARMIN_FR_60_PAIR_IMAGE];
            break;
    }
    //
    pairInstructionsImage.image = img;
}

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (NSString*)stringFromDeviceType:(WFAntFSDeviceType_t)devType
{
	NSString* retVal = @"FIT Device";
	switch (devType)
	{
        case WF_ANTFS_DEVTYPE_GARMIN_WATCH:
            retVal = KEY_GARMIN_WATCH;
            break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR60:
			retVal = KEY_GARMIN_FR_60;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR310:
			retVal = KEY_GARMIN_FR_310;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR405:
			retVal = KEY_GARMIN_FR_405;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR610:
			retVal = KEY_GARMIN_FR_610;
			break;
        default:
            break;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)downloadClicked:(id)sender
{
    // get the selected directory entries.
    NSMutableArray* filesToImport = [NSMutableArray arrayWithCapacity:1];
    NSLog(@"downloadClicked fileCount=%d", [filesToImport count]);
    for ( WFFitDirectoryEntry* dirEntry in fileTableViewController.fileRecords )
    {
        if ( dirEntry.isSelected )
        {
            // add the selected file to the import array.
            [filesToImport addObject:dirEntry];
        }
    }
    
    // start the import.
    if ( [filesToImport count] )
    {
        // start the import.
        [fitWatchManager beginImport:filesToImport];
        downloadButton.enabled = FALSE;
        
        // display the import status view.
        self.view = importView;
    }
}

//--------------------------------------------------------------------------------
- (void)doHelp:(id)sender
{
    NSString* msg = @"What do the colors mean?\nBlue - new workout\nBlack - previously downloaded (to another device, computer, etc).\n\nFiles already downloaded to the phone do not show in the list.";
	UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:@"Help" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[connectAlert show];
	[connectAlert release];	
    /*
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"nAN-24_Application_Note_v1.0" ofType:@"pdf"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
     */
}

- (void)back:(id)sender
{
    [fitWatchManager endConnection];
    [fitWatchManager release];
    fitWatchManager = nil;
}

#pragma mark MFMailComposeViewControllerDelegate delegate method

//--------------------------------------------------------------------------------
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"done mail");
    [self dismissModalViewControllerAnimated:YES];
    self.view = fileView;
    downloadButton.enabled = YES;
}

@end
