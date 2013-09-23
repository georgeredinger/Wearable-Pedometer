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
//  AntViewController.h
//  NordicSemiDemo
//
//  Created by Michael Moore on 4/7/10.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFAdvancedANT.h>


@interface AntViewController : UIViewController <WFAntReceiverDelegate>
{
	WFHardwareConnector* hardwareConnector;

	UILabel* keyConnectedLabel;
	UITextField* txMessageField;
	UITextView* rxMessageView;
}


@property (nonatomic, retain) IBOutlet UILabel* keyConnectedLabel;
@property (nonatomic, retain) IBOutlet UITextField* txMessageField;
@property (nonatomic, retain) IBOutlet UITextView* rxMessageView;


- (IBAction)chooseClicked:(id)sender;
- (IBAction)clearClicked:(id)sender;
- (IBAction)sendClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
