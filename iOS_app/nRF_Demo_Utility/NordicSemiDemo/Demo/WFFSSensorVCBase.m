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
//  WFFSSensorVCBase.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/11/10.
//

#import "WFFSSensorVCBase.h"
#import "WeightHistoryViewController.h"
#import "HistoryManager.h"
#import "NordicNavigationBar.h"
#import "ConfigAndHelpView.h"

@interface WFFSSensorVCBase  (_PRIVATE_)

- (void)buildCustomNavbar:(UIImage*)background;
- (void)doHelp:(id)sender;

@end

@implementation WFFSSensorVCBase

@synthesize refreshdateLabel;
@synthesize refreshtimeLabel;
@synthesize historyButton;
@synthesize refreshButton;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[self disconnectDevice];
	
	[refreshdateLabel release];
	[refreshtimeLabel release];
	[historyButton release];
	[refreshButton release];
    
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
	
	// connect the device.
	if ( hardwareConnector.isFisicaConnected && !bHistoryLoaded )
	{
		[self connectToDevice];
	}
	else
	{
		afsFileManager = nil;
	}
	bHistoryLoaded = FALSE;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
	[super viewDidLoad];
	hardwareConnector = [WFHardwareConnector sharedConnector];
    
    connectingIndicator.hidden = YES;
    [self buildCustomNavbar:[UIImage imageNamed:@"NordicNavbarWhite.png"]];
	// initialize the device passkey.
	[self loadPasskey];
	
	// update the refresh time.
	bHistoryLoaded = FALSE;
	HistoryManager* history = [[HistoryManager alloc] init];
	NSDate* lastRefresh = [history getLastRefresh:[history historyKeyForDeviceType:deviceType]];
	
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterNoStyle];	
	refreshdateLabel.text = [df stringFromDate:lastRefresh];
	
	[df setDateStyle:NSDateFormatterNoStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];
	refreshtimeLabel.text = [df stringFromDate:lastRefresh];
	
	[history release];	
	[self displayLastRecord];
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
	
	[refreshButton setTitle:@"Refresh Data" forState:UIControlStateNormal];
	[refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	refreshButton.enabled = hardwareConnector.isFisicaConnected;
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
	[self disconnectDevice];
	
	[super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)deviceConnected
{
	if (!afsFileManager) [self resetDisplayFS];
}

//--------------------------------------------------------------------------------
- (void)deviceDisconnected
{
	if (hardwareConnector.currentState != WF_HWCONN_STATE_RESET) [self resetDisplayFS];
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
	// this is invoked by the base class when the
	// dongle is connected, or the connections
	// are reset.  there is currently no need
	// to implement at this level.
}

//--------------------------------------------------------------------------------
- (void)updateData:(WFHardwareConnector *)hwConnector
{
}


#pragma mark -
#pragma mark WFAntFileManagerDelegate Implementation

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager downloadFinished:(BOOL)bSuccess filePath:(NSString*)filePath
{
	if (bSuccess)
	{
		// display the latest weight.
		NSArray* records = [[self getFitRecords:filePath] retain];
		[self updateDisplay:records];
		
		// save to the history file.
		HistoryManager* history = [[HistoryManager alloc] init];
		[history saveHistory:deviceType fitRecords:records];
		
		// attempt to set the time on the device.  if
		// this fails, go ahead and delete the ANT manager.
		if ( [afsFileManager setDeviceTime] )
		{
			[refreshButton setTitle:@"Setting Time..." forState:UIControlStateNormal];
		}
		else
		{

			// reset the display.
			[self resetDisplayFS];			
		}
		
		[history release];
		[records release];
	}
}

//--------------------------------------------------------------------------------
- (void)antFSDevice:(WFAntFSDevice*)fsDevice instanceCreated:(BOOL)bSuccess
{
	if (bSuccess)
	{
		afsFileManager = (WFAntFileManager*)fsDevice;
		afsFileManager.delegate = self;
		
		[afsFileManager connectToDevice:aucDevicePassword passkeyLength:ucDevicePasswordLength];
		[refreshButton setTitle:@"Searching..." forState:UIControlStateNormal];
		[refreshButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		refreshButton.enabled = FALSE;
	}
	else
	{
		[refreshButton setTitle:@"Refresh Data" forState:UIControlStateNormal];
		[refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		refreshButton.enabled = hardwareConnector.isFisicaConnected;
		[connectingIndicator stopAnimating];
        connectingIndicator.hidden = YES;
	}
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager receivedResponse:(ANTFS_RESPONSE)responseCode
{
	switch (responseCode)
	{
		case ANTFS_RESPONSE_OPEN_PASS:
			break;
			
		case ANTFS_RESPONSE_SERIAL_FAIL:
			[refreshButton setTitle:@"Connect Failed." forState:UIControlStateNormal];
			[self resetDisplayFS];
			break;
			
		case ANTFS_RESPONSE_CONNECT_PASS:
			[refreshButton setTitle:@"Authenticating..." forState:UIControlStateNormal];
			break;
			
		case ANTFS_RESPONSE_DISCONNECT_PASS:
		case ANTFS_RESPONSE_CONNECTION_LOST:
			[refreshButton setTitle:@"Disconnected." forState:UIControlStateNormal];
			[self resetDisplayFS];
			break;
			
		case ANTFS_RESPONSE_AUTHENTICATE_NA:
			break;
			
		case ANTFS_RESPONSE_AUTHENTICATE_PASS:
			[refreshButton setTitle:@"Reading..." forState:UIControlStateNormal];
			break;
			
		case ANTFS_RESPONSE_AUTHENTICATE_REJECT:
		case ANTFS_RESPONSE_AUTHENTICATE_FAIL:
		{
			[refreshButton setTitle:@"Authentication failed." forState:UIControlStateNormal];
			NSString* msg = @"Authentication failed.  Please place device in pairing mode, and press the \"Refresh\" button.  For information on pairing mode, please see manufacturer's instructions.";
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Authentication Failed"
																message:msg
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
			[alertView autorelease];
			break;
		}
			
		case ANTFS_RESPONSE_DOWNLOAD_PASS:
			[refreshButton setTitle:@"Downloading..." forState:UIControlStateNormal];
			break;
			
		case ANTFS_RESPONSE_DOWNLOAD_REJECT:
		case ANTFS_RESPONSE_DOWNLOAD_FAIL:
			[refreshButton setTitle:@"Download failed." forState:UIControlStateNormal];
			[self resetDisplayFS];
			break;
			
		case ANTFS_RESPONSE_UPLOAD_PASS:
		case ANTFS_RESPONSE_UPLOAD_REJECT:
		case ANTFS_RESPONSE_UPLOAD_FAIL:
			[self resetDisplayFS];
			break;
			
		case ANTFS_RESPONSE_ERASE_PASS:
			break;
			
		case ANTFS_RESPONSE_ERASE_FAIL:
			break;
			
		case ANTFS_RESPONSE_MANUAL_TRANSFER_PASS:
			break;
			
		case ANTFS_RESPONSE_MANUAL_TRANSFER_TRANSMIT_FAIL:
			break;
			
		case ANTFS_RESPONSE_MANUAL_TRANSFER_RESPONSE_FAIL:
			break;
			
		case ANTFS_RESPONSE_CANCEL_DONE:
			break;
			
			
		case ANTFS_RESPONSE_DOWNLOAD_INVALID_INDEX:
		case ANTFS_RESPONSE_DOWNLOAD_FILE_NOT_READABLE:
		case ANTFS_RESPONSE_DOWNLOAD_NOT_READY:
			[refreshButton setTitle:@"Download error." forState:UIControlStateNormal];
			[self resetDisplayFS];
			break;
		case ANTFS_RESPONSE_UPLOAD_INVALID_INDEX:
			break;
		case ANTFS_RESPONSE_UPLOAD_FILE_NOT_WRITEABLE:
			break;
		case ANTFS_RESPONSE_UPLOAD_INSUFFICIENT_SPACE:
			break;
			
		default:
			break;
	}
}

//--------------------------------------------------------------------------------
- (void)antFileManager:(WFAntFileManager*)antFileManager updatePasskey:(UCHAR*)pucPasskey length:(UCHAR)ucLength
{
	// copy the updated passkey.
	memset(aucDevicePassword, 0, WF_ANTFS_PASSWORD_MAX_LENGTH);
	memcpy(aucDevicePassword, pucPasskey, ucLength);
	ucDevicePasswordLength = ucLength;
	
	// convert the passkey to a string.
	NSString* passkey = @"";
	for (int i=0; i<(ucLength-1); i++)
	{
		// append the current byte to the passkey string.
		passkey = [passkey stringByAppendingFormat:@"%02X,", aucDevicePassword[i]];
	}
	// append the last byte.
	passkey = [passkey stringByAppendingFormat:@"%02X", aucDevicePassword[ucLength-1]];
	
	// save the passkey to the settings.
	HistoryManager* history = [[HistoryManager alloc] init];
	[history savePasskey:deviceType passkey:passkey];
	[history release];
}



#pragma mark -
#pragma mark WFFSSensorVCBase Implementation

//--------------------------------------------------------------------------------
- (void)connectToDevice
{
	if (afsFileManager) [hardwareConnector releaseAntFSDevice:afsFileManager];
	afsFileManager = nil;
	
	if ( [hardwareConnector requestAntFSDevice:deviceType toDelegate:self] )
	{
		[refreshButton setTitle:@"Connecting..." forState:UIControlStateNormal];
		[refreshButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		refreshButton.enabled = FALSE;
        connectingIndicator.hidden = NO;
		[connectingIndicator startAnimating];
	}
}

//--------------------------------------------------------------------------------
- (void)disconnectDevice
{
	if (afsFileManager) [hardwareConnector releaseAntFSDevice:afsFileManager];
	afsFileManager = nil;
}

//--------------------------------------------------------------------------------
- (void)displayLastRecord
{
	// NOT IMPLEMENTED IN BASE.
}

//--------------------------------------------------------------------------------
- (NSArray*)getFitRecords:(NSString*)filePath
{
	return nil;
}

//--------------------------------------------------------------------------------
- (void)loadPasskey
{
	// load the passkey string.
	HistoryManager* history = [[HistoryManager alloc] init];
	NSString* passkey = [history getPasskey:deviceType];
	
	// separate into bytes.
	NSArray* bytes = [passkey componentsSeparatedByString:@","];
	
	// parse bytes.
	memset(aucDevicePassword, 0, WF_ANTFS_PASSWORD_MAX_LENGTH);
	ucDevicePasswordLength = [bytes count];
	for (int i=0; i<ucDevicePasswordLength; i++)
	{
		uint scanInt;
		[[NSScanner scannerWithString:(NSString*)[bytes objectAtIndex:i]] scanHexInt:&scanInt];
		aucDevicePassword[i] = (UCHAR)scanInt;
	}
	
	// release resources.
	[history release];
}

//--------------------------------------------------------------------------------
- (void)resetDisplayFS
{
	[self disconnectDevice];
	[refreshButton setTitle:@"Refresh Data" forState:UIControlStateNormal];
	[refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	refreshButton.enabled = hardwareConnector.isFisicaConnected;
	[connectingIndicator stopAnimating];
    connectingIndicator.hidden = YES;
}

//--------------------------------------------------------------------------------
- (void)updateDisplay:(NSArray*)fitRecords
{
}


#pragma mark -
#pragma mark WFFSSensorVCBase private functions
//--------------------------------------------------------------------------------
- (void)buildCustomNavbar:(UIImage*)background
{
    UIImage* titleImage = [UIImage imageNamed:@"NORDIC-LOGO.png"];
    UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [titleView addSubview:titleImageView];
    titleImageView.center = titleView.center;
    CGRect titleImageViewFrame = titleImageView.frame;
    // Offset the logo up a bit
    // titleImageViewFrame.origin.y = titleImageViewFrame.origin.y + 3.0;
    titleImageView.frame = titleImageViewFrame;
    self.navigationItem.titleView = titleView;
    [titleImageView release];
    [titleView release];
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:background];
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfigAndHelpView" owner:self options:nil];
    ConfigAndHelpView *btns = [nib objectAtIndex:0];
    
    btns.configButton.hidden = YES;
    [btns.helpButton addTarget:self action:@selector(doHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:btns];
    [self.navigationItem setRightBarButtonItem:twoButtons animated:YES];
    [twoButtons release];
}


#pragma mark -
#pragma mark Event Handlers

//-------------------------------------------------------------------------------
- (IBAction)historyClicked:(id)sender
{
}

//-------------------------------------------------------------------------------
- (IBAction)refreshClicked:(id)sender
{
    NSLog(@"clicked refresh");
	[self connectToDevice];
}

//-------------------------------------------------------------------------------
- (void)doHelp:(id)sender
{
}

@end
