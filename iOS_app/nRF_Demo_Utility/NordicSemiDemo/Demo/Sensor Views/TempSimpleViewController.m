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
//  HeartrateSimpleViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import "TempSimpleViewController.h"
#import "TemperatureViewController.h"
#import "HelpViewController.h"

@implementation TempSimpleViewController

@synthesize tempLabel, battLevel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_HEALTH_THERMOMETER], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
        desiredNetwork = WF_NETWORKTYPE_BTLE;
    }
    return self;
}

-(void) dealloc 
{
    [tempLabel release];
    [super dealloc];
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
    tempLabel.text = @"- ";
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


//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    tempLabel.text = @"- ";
    battLevel.text = @"n/a";
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}


//--------------------------------------------------------------------------------
- (void)updateData
{
	WFHealthThermometerData* htData = [self.healthThermometerConnection getHealthThermometerData];
	if ( htData != nil )
	{
        
		float signal = [self.healthThermometerConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        
        tempLabel.text = [NSString stringWithFormat:@"%1.2f", htData.temperature];
        
        battLevel.text = (htData.btleCommonData.batteryLevel==WF_BTLE_BATT_LEVEL_INVALID) ? @"n/a" : [NSString stringWithFormat:@"%u %%", htData.btleCommonData.batteryLevel];
	}
	else 
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark TempSimpleViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHealthThermometerConnection*)healthThermometerConnection
{
	return (WFHealthThermometerConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_HEALTH_THERMOMETER]];
}


- (void)doConfig:(id)sender
{
    TemperatureViewController* vc = [[TemperatureViewController alloc] initWithNibName:@"TemperatureViewController" bundle:nil forSensor:WF_SENSORTYPE_HEALTH_THERMOMETER];
    vc.applicableNetworks = WF_NETWORKTYPE_BTLE;
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"btlesensorhelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}
@end
