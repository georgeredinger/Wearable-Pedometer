//
//  FitDeviceTypeViewController.h
//  FisicaUtility
//
//  Created by Michael Moore on 6/17/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/wf_antfs_types.h>


@interface FitDeviceTypeViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
	UIPickerView* pickerView;
	NSArray* deviceNames;
    BOOL shouldPopOnDisappear;
}


@property (nonatomic, retain) IBOutlet UIPickerView* pickerView;
@property (nonatomic, assign) BOOL shouldPopOnDisappear;


- (IBAction)selectClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;

- (WFAntFSDeviceType_t)deviceTypeFromString:(NSString*)deviceName;

@end
