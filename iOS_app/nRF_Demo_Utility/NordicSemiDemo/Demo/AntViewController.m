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
//  AntViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 4/7/10.
//

#import "AntViewController.h"
#import "CommandChooserController.h"


@interface AntViewController (_PRIVATE_)

- (void)updateDeviceConnection;
- (void)sendMessage;

@end



@implementation AntViewController

@synthesize keyConnectedLabel;
@synthesize txMessageField;
@synthesize rxMessageView;


#pragma mark -
#pragma NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[keyConnectedLabel release];
	[txMessageField release];
	[rxMessageView release];
	
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Advanced ANT";
	[rxMessageView setFont:[UIFont fontWithName:@"Courier" size: 10.0]];
	rxMessageView.text = @"";
	
	// default the assign channel message in the message send box.
	txMessageField.text = @"0442000000";
    
    // initialize the HW connector.
    hardwareConnector = [WFHardwareConnector sharedConnector];
    [hardwareConnector initializeAdvancedMode:self];

    // register for HW connector notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceConnection) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceConnection) name:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
	[self updateDeviceConnection];
}


#pragma mark -
#pragma mark WFAntReceiverDelegate Implementation

//--------------------------------------------------------------------------------
- (void)antMessageReceived:(WFAntMessage)antMessage
{
	// parse the ANT message into a formatted string.
	NSString* msg = [NSString stringWithFormat:@"%02X %02X %02X [%02X %02X %02X %02X %02X %02X %02X %02X]\n",
					 antMessage.messageSize,
					 antMessage.messageId,
					 antMessage.data1,  // channel number.
					 antMessage.data2,  // start of message.
					 antMessage.data3,
					 antMessage.data4,
					 antMessage.data5,
					 antMessage.data6,
					 antMessage.data7,
					 antMessage.data8,
					 antMessage.data9];
	
	// add the message string to the display and scroll.
	rxMessageView.text  = [rxMessageView.text stringByAppendingString:msg];
	[rxMessageView scrollRangeToVisible:NSMakeRange([rxMessageView.text length], 0)];
}


#pragma mark -
#pragma mark AntViewController Implementation

#pragma mark Private Methods
//--------------------------------------------------------------------------------
- (void)updateDeviceConnection
{
	keyConnectedLabel.text = hardwareConnector.isFisicaConnected ? @"Yes" : @"No";
}

//--------------------------------------------------------------------------------
- (void)sendMessage
{
	// parse the transmit string in 2-character segments.
	WFAntMessage txMessage;
	memset( &txMessage, 0, sizeof(WFAntMessage) );
	NSRange byteRange;
	byteRange.length = 2;
	NSString* txString = txMessageField.text;
	uint8_t* pMsgByte = (uint8_t*)&txMessage;
	
	for (byteRange.location = 0; byteRange.location < [txString length]; byteRange.location += 2, pMsgByte++ )
	{
		// get the string value of the byte at the current offset.
		NSString* txByte = [txString substringWithRange:byteRange];
		
		// scan to convert HEX string into uint.
		uint scanInt;
		[[NSScanner scannerWithString:txByte] scanHexInt:&scanInt];
		
		// copy the byte into the current offset of the TX message.
		*pMsgByte = (uint8_t)scanInt;
	}
	
	// transmit the message on the ANT channel.
	[hardwareConnector sendAntMessage:&txMessage];
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)chooseClicked:(id)sender
{
    // Navigation logic may go here. Create and push another view controller.
	CommandChooserController* commandChooser = [[CommandChooserController alloc] initWithNibName:@"CommandChooserController" bundle:nil];
	commandChooser.txMessageField = txMessageField;
	[commandChooser sendTxTo:self forSelector:@selector(sendMessage)];
	[self.navigationController pushViewController:commandChooser animated:TRUE];
	
	[commandChooser release];
}

//--------------------------------------------------------------------------------
- (IBAction)clearClicked:(id)sender
{
	rxMessageView.text = @"";
}

//--------------------------------------------------------------------------------
- (IBAction)sendClicked:(id)sender
{
	[self sendMessage];
}

//--------------------------------------------------------------------------------
- (IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

@end
