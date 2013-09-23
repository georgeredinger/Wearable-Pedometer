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
//  CommandChooserController.h
//  FisicaPowerDemo
//
//  Created by Michael Moore on 4/7/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_COMMANDS  9


typedef struct
{
	NSString* commandName;
	uint8_t antChannel;
 	NSString* command;
	
} ANTCommand_t;


@interface CommandChooserController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
	UIPickerView* pickerView;
	UITextField* txMessageField;
	ANTCommand_t commands[MAX_COMMANDS];
	
	id targetForTx;
	SEL selectorForTx;
}


@property (nonatomic, retain) IBOutlet UIPickerView* pickerView;
@property (nonatomic, retain) UITextField* txMessageField;


- (IBAction)selectAndSendClicked:(id)sender;
- (IBAction)selectClicked:(id)sender;

- (void)sendTxTo:(id) target forSelector:(SEL) selector;

@end
