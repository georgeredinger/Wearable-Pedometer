///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012 Nordic Semiconductor. All Rights Reserved.
// Copyright (c) 2012 Wahoo Fitness. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA and Wahoo Fitness LLC.
// Terms and conditions of usage are described in detail in
// NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
///////////////////////////////////////////////////////////////////////////////
//
//  CommandChooserController.m
//  FisicaPowerDemo
//
//  Created by Michael Moore on 4/7/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "CommandChooserController.h"


@implementation CommandChooserController

@synthesize pickerView;
@synthesize txMessageField;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[pickerView release];
	[txMessageField release];
	
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
	// initialize the ANT commands.
	commands[0].commandName = @"Assign Channel";
	commands[0].command = @"0442XX0000";
	commands[0].antChannel = 0;
	
	commands[1].commandName = @"Enable EXT";
	commands[1].command = @"02660001";
	commands[1].antChannel = 0;
	
	commands[2].commandName = @"Set Channel ID";
	commands[2].command = @"0551XX000000";
	commands[2].antChannel = 0;
	
	commands[3].commandName = @"Radio Freq";
	commands[3].command = @"0245XX39";
	commands[3].antChannel = 0;
	
	commands[4].commandName = @"Channel Period";
	commands[4].command = @"0343XX861F";
	commands[4].antChannel = 0;
	
	commands[5].commandName = @"Open Channel";
	commands[5].command = @"014BXX";
	commands[5].antChannel = 0;
	
	commands[6].commandName = @"Open Scan Mode";
	commands[6].command = @"015B00";
	commands[6].antChannel = 0;
	
	commands[7].commandName = @"Close Channel";
	commands[7].command = @"014CXX";
	commands[7].antChannel = 0;
	
	commands[8].commandName = @"Unassign Channel";
	commands[8].command = @"0141XX";
	commands[8].antChannel = 0;
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark UIPickerViewDataSource Implementation

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
#pragma mark UIPickerViewDelegate Implementation

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
#pragma mark CommandChooserController Implementation

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)sendTxTo:(id) target forSelector:(SEL) selector
{
	targetForTx = target;
	selectorForTx = selector;
}


#pragma mark Event Handlers

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
