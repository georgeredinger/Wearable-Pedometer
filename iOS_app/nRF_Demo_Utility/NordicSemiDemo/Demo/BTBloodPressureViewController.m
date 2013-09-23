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
//  BTBloodPressureViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 2/22/12.
//

#import "BTBloodPressureViewController.h"
#import "BTBloodPressureVC.h"
#import "HelpViewController.h"
#import "HistoryManager.h"
#import "BPHistoryViewController.h"
#import "BTBPRecord.h"

@implementation BTBloodPressureViewController

@synthesize inProgressLabel;
@synthesize pressureLabel;
@synthesize systolicLabel;
@synthesize diastolicLabel;
@synthesize pulserateLabel;
@synthesize meanAPLabel;
@synthesize battLevel;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [inProgressLabel release];
    [pressureLabel release];
	[systolicLabel release];
	[diastolicLabel release];
	[pulserateLabel release];
	[meanAPLabel release];
	
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_BLOOD_PRESSURE], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
        desiredNetwork = WF_NETWORKTYPE_BTLE;
    }
    return self;
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
    battLevel.text = @"n/a";
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    hardwareConnector.sampleRate = 0.5;
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    hardwareConnector.sampleRate = 0.5;
    inProgressLabel.hidden = TRUE;
    pressureLabel.text = @"Systolic:";
    systolicLabel.text = @"- ";
    diastolicLabel.text = @"- ";
    pulserateLabel.text = @"- ";
    meanAPLabel.text = @"- ";
    battLevel.text = @"n/a";
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}


//--------------------------------------------------------------------------------
- (void)updateData
{
	WFBloodPressureData* bpData = [self.bloodPressureConnection getBloodPressureData];
	if ( bpData != nil )
	{
        
		float signal = [self.bloodPressureConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        if ( bpData.isMeasurementInProgress )
        {
            // configure the in-progress labels.
            inProgressLabel.hidden = FALSE;
            pressureLabel.text = @"Pressure:";
            
            // configure the pressure label values.
            systolicLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.cuffPressure];
            diastolicLabel.text = @"n/a";
            meanAPLabel.text = @"n/a";
            pulserateLabel.text = @"n/a";
        } else {
            // configure the in-progress labels.
            inProgressLabel.hidden = TRUE;
            pressureLabel.text = @"Systolic:";

            systolicLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.systolic];
            diastolicLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.diastolic];
            meanAPLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.meanArterialPressure];
            pulserateLabel.text = [NSString stringWithFormat:@"%1.0f", bpData.heartRate];
            
            // save to history
            BTBPRecord * bpRec = [[BTBPRecord alloc] init];
            bpRec.timestamp = [NSDate dateWithTimeIntervalSinceReferenceDate:bpData.timestamp];
            bpRec.systolic = bpData.systolic;
            bpRec.diastolic = bpData.diastolic;
            bpRec.heartRate = bpData.heartRate;
            
            HistoryManager* history = [[HistoryManager alloc] init];
            [history saveBTBPRecord:bpRec];
            [bpRec release];
            [history release];
        }
        // the common data for BTLE sensors is still in beta state.  this data
        // will eventually be merged with the existing common data.  for current demo
        // purposes, the battery level is updated directly from this HR view controller.
        if ( bpData.btleCommonData.batteryLevel == WF_BTLE_BATT_LEVEL_INVALID )
        {
            battLevel.text = @"n/a";
        }
        else
        {
            battLevel.text = [NSString stringWithFormat:@"%u%%", bpData.btleCommonData.batteryLevel];
        }
	}
	else 
	{
	//	[self resetDisplay];
	}
}

-(void)onSensorConnected:(WFSensorConnection *)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    hardwareConnector.sampleRate = 0.02;
}

#pragma mark -
#pragma mark BTBloodPressureViewController Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)historyClicked:(id)sender
{
	bHistoryLoaded = TRUE;
	HistoryManager* history = [[HistoryManager alloc] init];
	NSArray* records = [history loadBTBPHistory];
	
	BPHistoryViewController *historyView = [[BPHistoryViewController alloc] initWithNibName:@"BPHistoryViewController" bundle:nil];
    historyView.networkType = WF_NETWORKTYPE_BTLE;
	historyView.btRecords = records;
	[self.navigationController pushViewController:historyView animated:TRUE];
	
	[history release];
	[historyView release];
}

//--------------------------------------------------------------------------------
- (WFBloodPressureConnection*)bloodPressureConnection
{
	return (WFBloodPressureConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_BLOOD_PRESSURE]];
}


- (void)doConfig:(id)sender
{
    BTBloodPressureVC* vc = [[BTBloodPressureVC alloc] initWithNibName:@"BTBloodPressureVC" bundle:nil forSensor:WF_SENSORTYPE_BLOOD_PRESSURE];
    vc.applicableNetworks = WF_NETWORKTYPE_BTLE;
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
}
//-------------------------------------------------------------------------------
- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"btlesensorhelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self   presentModalViewController:vc animated:YES];
    [vc release];
    
}

@end
