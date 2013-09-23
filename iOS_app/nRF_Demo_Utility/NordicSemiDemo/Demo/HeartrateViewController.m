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
//  HeartrateViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 2/20/10.
//

#import "HeartrateViewController.h"
#import "HelpViewController.h"
#import "NordicSemiAppDelegate.h"


@implementation HeartrateViewController

@synthesize computedHeartrateLabel;
@synthesize beatTimeLabel;
@synthesize beatCountLabel;
@synthesize previousBeatLabel;
@synthesize batLevelLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[computedHeartrateLabel release];
	[beatTimeLabel release];
	[beatCountLabel release];
	[previousBeatLabel release];
    [batLevelLabel release];
	
    [super dealloc];
}

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
    self.navigationItem.title = @"Heart Rate";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	signalEfficiencyLabel.text = @"n/a";
	deviceIdLabel.text = @"n/a";
	computedHeartrateLabel.text = @"n/a";
	beatTimeLabel.text = @"n/a";
	beatCountLabel.text = @"n/a";
	previousBeatLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
	WFHeartrateData* hrData = [self.heartrateConnection getHeartrateData];
	WFHeartrateRawData* hrRawData = [self.heartrateConnection getHeartrateRawData];
	if ( hrData != nil )
	{
        
       // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:hrData.computedHeartrate];
        
        // update the device id
        //use the deviceIDString property as this will return the ID for both ANT+
        //and BTLE devices
        NSString* deviceID = self.sensorConnection.deviceIDString;
        if (deviceID==nil) deviceID=@"n/a";
        else  if (self.sensorConnection.networkType == WF_NETWORKTYPE_BTLE) deviceID = [WFSensorCommonViewController formatUUID:deviceID];
		deviceIdLabel.text = [NSString stringWithFormat:@"%@", deviceID];

        // update the signal efficiency.
		float signal = [self.sensorConnection signalEfficiency];
        //
        // signal efficency is % for ANT connections, dBm for BTLE.
        NSString* units;
        if ( self.sensorConnection.isANTConnection )
        {
            signal *= 100;
            units = @"%";
        }
        else
        {
            units = @" dBm";
        }
		if (self.sensorConnection.isANTConnection && signal == -1) signalEfficiencyLabel.text = @"n/a";
		else signalEfficiencyLabel.text = [NSString stringWithFormat:@"%0.0f%@", signal, units];
        
        // unformatted value.
		// computedHeartrateLabel.text = [NSString stringWithFormat:@"%d", hrData.computedHeartrate];
        
        // update basic data.
        computedHeartrateLabel.text = [hrData formattedHeartrate:TRUE];
		beatTimeLabel.text = [NSString stringWithFormat:@"%d", hrData.beatTime];
		
        // update raw data.
		beatCountLabel.text = [NSString stringWithFormat:@"%d", hrRawData.beatCount];
		previousBeatLabel.text = [NSString stringWithFormat:@"%d", hrRawData.previousBeatTime];
        
        double timestamp = hrData.timestamp;
        if (timestamp > 0) {
            NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
            id x = [NSNumber numberWithDouble:timestamp];
            id y = [NSNumber numberWithInt:hrData.computedHeartrate];
            NSDictionary *sample = [NSDictionary dictionaryWithObjectsAndKeys:x, @"timestamp", y, @"bpm", nil];
            [appDelegate storeHRMPlot:sample];
        }
	}
	else 
	{
		[self resetDisplay];
	}
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"HRconfighelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

#pragma mark -
#pragma mark HeartrateViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHeartrateConnection*)heartrateConnection
{
	WFHeartrateConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFHeartrateConnection class]] )
	{
		retVal = (WFHeartrateConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
