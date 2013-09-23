//
//  FitDeviceTypeViewController.m
//  FisicaUtility
//
//  Created by Michael Moore on 6/17/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "FitDeviceTypeViewController.h"
#import "FitDeviceViewController.h"


#define KEY_GARMIN_FR_60                    @"Garmin FR 60"
#define KEY_GARMIN_FR_310                   @"Garmin FR 310 XT"
#define KEY_GARMIN_FR_405                   @"Garmin FR 405"
#define KEY_GARMIN_FR_610                   @"Garmin FR 610"


@implementation FitDeviceTypeViewController

@synthesize shouldPopOnDisappear;
@synthesize pickerView;


#pragma mark -
#pragma NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[pickerView release];
	[deviceNames release];
	
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
	[super viewDidLoad];
    
    shouldPopOnDisappear = FALSE;
	[deviceNames release];
	deviceNames = [[NSArray arrayWithObjects:
					KEY_GARMIN_FR_60,
					KEY_GARMIN_FR_310,
                    KEY_GARMIN_FR_405,
					KEY_GARMIN_FR_610,
					//@"Generic FIT Device",
					nil] retain];
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
}

//--------------------------------------------------------------------------------
- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    if ( shouldPopOnDisappear )
    {
        // remove this view from the nav controller.
        NSMutableArray* navStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for ( int i=([navStack count]-1); i>=0; i-- )
        {
            // loop the view controllers in the nav stack - find this view.
            if ( [[navStack objectAtIndex:i] isEqual:self] )
            {
                // remove this view from the array.
                [navStack removeObjectAtIndex:i];
                break;
            }
        }
        //
        // set the nav stack and remove this view from the super.
        [self.navigationController setViewControllers:navStack animated:FALSE];
        [self.view removeFromSuperview];
    }
}

#pragma mark -
#pragma UIPickerViewDataSource Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

//--------------------------------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [deviceNames count];
}


#pragma mark -
#pragma UIPickerViewDelegate Implementation

//--------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

//--------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* retVal;
	retVal = (NSString*)[deviceNames objectAtIndex:row];
	
	return retVal;
}


#pragma mark -
#pragma FitDeviceTypeViewController Implementation

//--------------------------------------------------------------------------------
- (WFAntFSDeviceType_t)deviceTypeFromString:(NSString*)deviceName
{
	WFAntFSDeviceType_t retVal = WF_ANTFS_DEVTYPE_GENERIC_FIT;
	if ( [deviceName compare:KEY_GARMIN_FR_60] == NSOrderedSame )
	{
		retVal = WF_ANTFS_DEVTYPE_GARMIN_FR60;
	}
	else if ( [deviceName compare:KEY_GARMIN_FR_310] == NSOrderedSame )
	{
		retVal = WF_ANTFS_DEVTYPE_GARMIN_FR310;
	}
	else if ( [deviceName compare:KEY_GARMIN_FR_405] == NSOrderedSame )
	{
		retVal = WF_ANTFS_DEVTYPE_GARMIN_FR405;
	}
	else if ( [deviceName compare:KEY_GARMIN_FR_610] == NSOrderedSame )
	{
		retVal = WF_ANTFS_DEVTYPE_GARMIN_FR610;
	}
	
	return retVal;
}


#pragma mark -
#pragma Event Handler Implementation

//--------------------------------------------------------------------------------
-(IBAction)selectClicked:(id)sender
{
    // load the FIT import view.
    FitDeviceViewController* fitView = [[FitDeviceViewController alloc] initWithNibName:@"FitDeviceViewController" bundle:nil];
	NSString* selectedItem = (NSString*)[deviceNames objectAtIndex:[pickerView selectedRowInComponent:0]];
	[fitView setDeviceType:[self deviceTypeFromString:selectedItem]];
    
    shouldPopOnDisappear = TRUE;
    [self.navigationController pushViewController:fitView animated:TRUE];
    [fitView release];
}

//--------------------------------------------------------------------------------
-(IBAction)cancelClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:TRUE];
}

@end
