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
//  RunningViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import "RunningViewController.h"
#import "ConfigScrollerController.h"
#import "HelpViewController.h"

@interface RunningViewController (_PRIVATE_) 

-(NSString *)calcPace:(float)speed;

@end

@implementation RunningViewController

@synthesize speedLabel, distanceLabel, cadenceLabel, paceLabel, computedHeartrateLabel, distanceUnit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE], [NSNumber numberWithInt:WF_SENSORTYPE_FOOTPOD], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
        desiredNetwork = WF_NETWORKTYPE_ANTPLUS;
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
    [self resetDisplay];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setHrmBatteryLabel:nil];
    [self setSpdBatteryLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [speedLabel release];
    [distanceUnit release];
    [distanceLabel release];
    [cadenceLabel release];
    [paceLabel release];
    [computedHeartrateLabel release];
    [_hrmBatteryLabel release];
    [_spdBatteryLabel release];
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    speedLabel.text = @"--";
    distanceLabel.text = @"--";
    cadenceLabel.text = @"--";
    paceLabel.text = @"--";
    computedHeartrateLabel.text = @"--";
    self.spdBatteryLabel.text = @"n/a";
    self.hrmBatteryLabel.text = @"n/a";
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}

//--------------------------------------------------------------------------------
- (void)updateData
{
  //  WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
 //   WFConnectorSettings* settings = hwConn.settings;
    
	WFFootpodData* fpData = [self.footpodConnection getFootpodData];
    
	WFFootpodRawData* fpRawData = [self.footpodConnection getFootpodRawData];
	if ( fpData != nil )
	{
		float signal = [self.footpodConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        
     //   BOOL metric = settings.useMetricUnits;
        
      /*   // pretty up distance data, walk around and test it... (Nike+ accuracy is plus or minus 20%, ANT+ is plus or minus 2%, really...)
         if (fpData.accumulatedDistance < 304)  // less than 1000ft, use ft, otherwise convert to miles
         {
         distanceLabel.text = [NSString stringWithFormat:@"%1.0f ft",fpData.accumulatedDistance / .3048];
         }
         else distanceLabel.text = [NSString stringWithFormat:@"%1.2f mi",fpData.accumulatedDistance / 1609.344];
        */ // english units
        
        if (fpData.accumulatedDistance < 100)  // less than 1000m, use m, otherwise convert to km
        {
            distanceLabel.text = [NSString stringWithFormat:@"%1.0f",fpData.accumulatedDistance];
            distanceUnit.text = @"m";
        } else {
            distanceLabel.text = [NSString stringWithFormat:@"%1.2f", fpData.accumulatedDistance / 1000];
            distanceUnit.text = @"km";
        }
         
         if (fpData.instantaneousSpeed < .01) // you are stopped min/mi should be infinity
         {
         speedLabel.text = [NSString stringWithFormat:@"n/a"];
         }
       //  else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 26.8224 / fpData.instantaneousSpeed]; // English
         else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 3.6 * fpData.instantaneousSpeed];   // metric conversion from m/s to km/hr
         
         cadenceLabel.text = [NSString stringWithFormat:@"%1.0f", fpRawData.cadence];
        
        
        paceLabel.text = [self calcPace:fpRawData.instantaneousSpeed];
        
        if (fpRawData.commonData) {
            self.spdBatteryLabel.text = [self percentForBattStatus:fpRawData.commonData.batteryStatus];
        } else {
            self.spdBatteryLabel.text = @"n/a";
        }

    }
    
    WFHeartrateData* hrData = [self.heartrateConnection getHeartrateData];
	if ( hrData != nil )
	{
        
        if (fpData == nil) {
            float signal = [self.heartrateConnection signalEfficiency];
            [sensorStrength setImage:[self sensorImageForStrength:signal]];
        }
        
        // update basic data.
        computedHeartrateLabel.text = [hrData formattedHeartrate:NO];
        
        WFHeartrateRawData *hrRawData = [self.heartrateConnection getHeartrateRawData];
        if ( hrRawData.btleCommonData )
        {
            if ( hrRawData.btleCommonData.batteryLevel == WF_BTLE_BATT_LEVEL_INVALID )
            {
                self.hrmBatteryLabel.text = @"n/a";
            }
            else
            {
                self.hrmBatteryLabel.text = [NSString stringWithFormat:@"%u%%", hrRawData.btleCommonData.batteryLevel];
            }
        } else if (hrRawData.commonData) {
            self.hrmBatteryLabel.text = [self percentForBattStatus:hrRawData.commonData.batteryStatus];
        }
    }
    
}


#pragma mark -
#pragma mark RunningViewController Implementation

/*
 *  helper function to caculate run pace. In a real app try generating a rolling average of speed first, e.g. of 5 seconds. 
 *  Using the instantaneous speed from the footpod generates a pace that changes wildly. 
 */

-(NSString *)calcPace:(float)speed {
	if (speed < .01) return @"--";
	float pacef;
    BOOL useMetric = YES; // get from settings in a real app.
	if (useMetric) {
		pacef =  60 / (speed  * 2.2369363 / 0.62);
	} else {
		pacef =  60 / (speed  * 2.2369363);
	}
	float minf = floorf(pacef);
	NSString *minute = [NSString stringWithFormat:@"%1.0f",minf];
	float minr = pacef - minf;
	if (minr <0) minr = 0.0;
	int secs = round(minr * 60);
	NSString *secsStr;
	if (secs<10) {
		secsStr = [NSString stringWithFormat:@"0%d",secs];
	} else {
		secsStr = [NSString stringWithFormat:@"%d",secs];
	}
	return [NSString stringWithFormat:@"%@%@%@",minute,@":",secsStr];
}
#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHeartrateConnection*)heartrateConnection
{
	return (WFHeartrateConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE]];
}

//--------------------------------------------------------------------------------
- (WFFootpodConnection*)footpodConnection
{
	return (WFFootpodConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_FOOTPOD]];
}

- (void)doConfig:(id)sender
{
    NSArray * cArr = [NSArray arrayWithObjects:@"HeartrateViewController", @"FootpodViewController", nil];
    ConfigScrollerController * csc = [[ConfigScrollerController alloc] initWithNibName:@"ConfigScrollerController" bundle:nil controllersArray:cArr];
    csc.configHelp = @"runningconfighelp";
    [self.navigationController pushViewController:csc animated:TRUE];
    [csc release];
}

- (void)doHelp:(id)sender
{
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"antsensorhelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}
@end
