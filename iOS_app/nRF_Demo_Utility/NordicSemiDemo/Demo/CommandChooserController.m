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
//  CommandChooserController.m
//  FisicaPowerDemo
//
//  Created by Michael Moore on 4/7/10.
//

#import "CommandChooserController.h"


@implementation CommandChooserController

@synthesize pickerView;
@synthesize txMessageField;


#pragma mark -
#pragma NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[pickerView release];
	[txMessageField release];
	
    [super dealloc];
}


#pragma mark -
#pragma UIViewController Implementation

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
	// initialize the ANT commands.
	commands[0].commandName = @"Assign Channel";
	commands[0].command = @"0442XX0000";
	commands[0].antChannel = 0;
	
	commands[1].commandName = @"Set Channel ID";
	commands[1].command = @"0551XX000000";
	commands[1].antChannel = 0;
	
	commands[2].commandName = @"Radio Freq";
	commands[2].command = @"0245XX39";
	commands[2].antChannel = 0;
	
	commands[3].commandName = @"Channel Period";
	commands[3].command = @"0343XX861F";
	commands[3].antChannel = 0;
	
	commands[4].commandName = @"Open Channel";
	commands[4].command = @"014BXX";
	commands[4].antChannel = 0;
	
	commands[5].commandName = @"Close Channel";
	commands[5].command = @"014CXX";
	commands[5].antChannel = 0;
	
	commands[6].commandName = @"Unassign Channel";
	commands[6].command = @"0141XX";
	commands[6].antChannel = 0;
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma UIPickerViewDataSource Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

//--------------------------------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger retVal;
	
	if (component == 0) retVal = MAX_COMMANDS;
	else retVal = 4;
	
	return retVal;
}


#pragma mark -
#pragma UIPickerViewDelegate Implementation

//--------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

/*
//--------------------------------------------------------------------------------
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 10;
}
*/

//--------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* retVal;
	
	if (component == 0) retVal = commands[row].commandName;
	else retVal = [NSString stringWithFormat:@"%d", row];
	
	return retVal;
}

/*
//--------------------------------------------------------------------------------
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
}
*/

//--------------------------------------------------------------------------------
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat retVal = 45;
	if (component == 0) retVal = 245;
	
	return retVal;
}


#pragma mark -
#pragma Event Handler Implementation

//--------------------------------------------------------------------------------
- (void)sendTxTo:(id) target forSelector:(SEL) selector
{
	targetForTx = target;
	selectorForTx = selector;
}


#pragma mark -
#pragma Event Handler Implementation

//--------------------------------------------------------------------------------
-(IBAction)selectClicked:(id)sender
{
	uint8_t channel = (uint8_t)[pickerView selectedRowInComponent:1];
	NSString* cmd = commands[ [pickerView selectedRowInComponent:0] ].command;
	cmd = [cmd stringByReplacingOccurrencesOfString:@"XX" withString:[NSString stringWithFormat:@"%02X", channel]];
	txMessageField.text = cmd;
	
	[self.navigationController popViewControllerAnimated:TRUE];
}

//--------------------------------------------------------------------------------
-(IBAction)selectAndSendClicked:(id)sender
{
	uint8_t channel = (uint8_t)[pickerView selectedRowInComponent:1];
	NSString* cmd = commands[ [pickerView selectedRowInComponent:0] ].command;
	cmd = [cmd stringByReplacingOccurrencesOfString:@"XX" withString:[NSString stringWithFormat:@"%02X", channel]];
	txMessageField.text = cmd;
	
	if(targetForTx) [targetForTx performSelector:selectorForTx];
	
	[self.navigationController popViewControllerAnimated:TRUE];
}

@end
