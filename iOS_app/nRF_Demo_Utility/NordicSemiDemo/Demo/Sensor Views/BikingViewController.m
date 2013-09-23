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
//  BikingViewController.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/9/11.
//

#import "BikingViewController.h"
#import "ConfigScrollerController.h"
#import "HelpViewController.h"

@interface BikingViewController (_PRIVATE_) 

@end

@implementation BikingViewController

@synthesize speedLabel, distanceLabel, cadenceLabel, powerTitle, powerUnit, powerLabel, computedHeartrateLabel, distanceUnit;
@synthesize ANTLogo, BTLogo, btSpeedCadBatt, hrmBatt, btSpeedCadBattTitle, btSCBattImg, hrmBattTitle, hrmBattImg, pwrBatt, pwrBattTitle, pwrBattImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forNetwork:(WFNetworkType_t)network
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        desiredNetwork = network;
        if (network == WF_NETWORKTYPE_ANTPLUS) {
            sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_CADENCE], [NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE], [NSNumber numberWithInt:WF_SENSORTYPE_BIKE_POWER], [NSNumber numberWithInt:WF_SENSORTYPE_BIKE_SPEED], [NSNumber numberWithInt:WF_SENSORTYPE_BIKE_SPEED_CADENCE], nil] retain];
            sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:5] retain];
        } else {
            sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_SPEED_CADENCE], [NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE], [NSNumber numberWithInt:WF_SENSORTYPE_BIKE_POWER], nil] retain]; 
          //  sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_SPEED_CADENCE], nil] retain];
            sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:3] retain];
        }
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
    [self resetDisplay];
    if (desiredNetwork == WF_NETWORKTYPE_ANTPLUS) {
        BTLogo.hidden = YES;
        ANTLogo.hidden = NO;
    } else {
        BTLogo.hidden = NO;
        ANTLogo.hidden = YES;
    }
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

- (void)dealloc
{
    [speedLabel release];
    [distanceUnit release];
    [distanceLabel release];
    [cadenceLabel release];
    [powerLabel release];
    [powerTitle release];
    [powerUnit release];
    [computedHeartrateLabel release];
    [ANTLogo release];
    [BTLogo release];
    [pwrBattTitle release];
    [pwrBatt release];
    [hrmBatt release];
    [hrmBattImg release];
    [hrmBattTitle release];
    [btSpeedCadBatt release];
    [btSCBattImg release];
    [pwrBattImg release];
    [btSpeedCadBattTitle release];
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    speedLabel.text = @"--";
    distanceLabel.text = @"--";
    cadenceLabel.text = @"--";
    powerLabel.text = @"--";
    computedHeartrateLabel.text = @"--";
    hrmBatt.text = @"--";
    btSpeedCadBatt.text = @"--";
    powerLabel.text = @"--";
    hrmBattImg.hidden = hrmBatt.hidden = hrmBattTitle.hidden = YES;
    btSCBattImg.hidden = btSpeedCadBatt.hidden = btSpeedCadBattTitle.hidden = YES;
    pwrBattImg.hidden = pwrBattTitle.hidden = pwrBatt.hidden = YES;
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    WFHardwareConnector* hwConn = [WFHardwareConnector sharedConnector];
    WFConnectorSettings* settings = hwConn.settings;
    
   // BOOL metric = settings.useMetricUnits; // implement your own English units below
    
    int WOD = settings.bikeWheelCircumference * 1000; // your wheel outer diameter in millimeters
    BOOL hasSignal = NO; // all these sensors are sharing the signal strength indicator; lets only use one rather than set it several times
    WFBikeSpeedData* sData = [self.speedConnection getBikeSpeedData];
	if ( sData != nil )
	{
        hasSignal = YES;
        float signal = [self.speedConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        float spd = (float)sData.instantWheelRPM / 60 * (0.001*WOD);  // meters/sec
        if (spd < .01) // you are stopped min/mi should be infinity
        {
            speedLabel.text = [NSString stringWithFormat:@"n/a"];
        }
        //  else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 26.8224 / fpData.instantaneousSpeed]; // English
        else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 3.6 * spd];   // metric conversion from m/s to km/hr
        
        float accumMeters = (float)sData.accumWheelRevolutions * (0.001*WOD);
        
        if (accumMeters < 100)  // less than 1000m, use m, otherwise convert to km
        {
            distanceLabel.text = [NSString stringWithFormat:@"%1.0f",accumMeters];
            distanceUnit.text = @"m";
        } else {
            distanceLabel.text = [NSString stringWithFormat:@"%1.2f", accumMeters / 1000];
            distanceUnit.text = @"km";
        }
    }
    
    WFBikeSpeedCadenceData* scData = [self.speedCadenceConnection getBikeSpeedCadenceData];
	if ( scData != nil )
	{
        if (!hasSignal) {
            hasSignal = YES;
            float signal = [self.speedCadenceConnection signalEfficiency];
            [sensorStrength setImage:[self sensorImageForStrength:signal]];
        }
        float spd = (float)scData.instantWheelRPM / 60 * (0.001*WOD);  // meters/sec
        if (spd < .01) // you are stopped min/mi should be infinity
        {
            speedLabel.text = [NSString stringWithFormat:@"n/a"];
        }
        //  else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 26.8224 / fpData.instantaneousSpeed]; // English
        else { 
            speedLabel.text = [NSString stringWithFormat:@"%1.1f", 3.6 * spd];   // metric conversion from m/s to km/hr
        }
        float accumMeters = (float)scData.accumWheelRevolutions * (0.001*WOD);
        
        if (accumMeters < 100)  // less than 1000m, use m, otherwise convert to km
        {
            distanceLabel.text = [NSString stringWithFormat:@"%1.0f",accumMeters];
            distanceUnit.text = @"m";
        } else {
            distanceLabel.text = [NSString stringWithFormat:@"%1.2f", accumMeters / 1000];
            distanceUnit.text = @"km";
        }
        
        btSCBattImg.hidden = btSpeedCadBatt.hidden = btSpeedCadBattTitle.hidden = NO;
        cadenceLabel.text = [NSString stringWithFormat:@"%d", scData.instantCrankRPM];
        if (self.speedCadenceConnection.isBTLEConnection )
        {
            
            WFSensorData* data = [self.speedCadenceConnection getData];
            if ( ![data respondsToSelector:@selector(btleCommonData)] )
            {
                // check for BTLE common data in raw data instance.
                data = [self.speedCadenceConnection getRawData];
            }
            
            if ( [data respondsToSelector:@selector(btleCommonData)] ) {
            
                // get the BTLE common data and display the detail view.
                WFBTLECommonData* commonData = (WFBTLECommonData*)[data performSelector:@selector(btleCommonData)];
                if (commonData.batteryLevel==WF_BTLE_BATT_LEVEL_INVALID) {
                   btSpeedCadBatt.text = @"n/a";
                } else {
                    btSpeedCadBatt.text = [NSString stringWithFormat:@"%u %%", commonData.batteryLevel];
                }
            }
            
        } else {
            btSpeedCadBatt.text = @"n/a";
        }
    }
    
    
    WFBikePowerData* bpData = [self.powerConnection getBikePowerData];
	WFBikePowerRawData* bpRawData = [self.powerConnection getBikePowerRawData];
	if ( bpRawData != nil )
	{
        if (!hasSignal) {
            hasSignal = YES;
            float signal = [self.powerConnection signalEfficiency];
            [sensorStrength setImage:[self sensorImageForStrength:signal]];
        }
		powerLabel.text = [bpData formattedPower:NO];
        if (bpData.instantCadence > 0) cadenceLabel.text = [NSString stringWithFormat:@"%d",bpData.instantCadence];
        if (bpRawData.wheelTorqueData) { // wheelTorque powermeters (PowerTap) can give us speed, distance and cadence
            float spd = (float)bpRawData.wheelTorqueData.wheelRPM / 60 * (0.001*WOD);  // meters/sec
            if (spd < .01) // you are stopped min/mi should be infinity
            {
                speedLabel.text = [NSString stringWithFormat:@"n/a"];
            }
            //  else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 26.8224 / fpData.instantaneousSpeed]; // English
            else speedLabel.text = [NSString stringWithFormat:@"%1.1f", 3.6 * spd];   // metric conversion from m/s to km/hr
            
            float accumMeters = (float)bpRawData.wheelTorqueData.accumulatedWheelTicks * (0.001*WOD);
            
            if (accumMeters < 100)  // less than 1000m, use m, otherwise convert to km
            {
                distanceLabel.text = [NSString stringWithFormat:@"%1.0f",accumMeters];
                distanceUnit.text = @"m";
            } else {
                distanceLabel.text = [NSString stringWithFormat:@"%1.2f", accumMeters / 1000];
                distanceUnit.text = @"km";
            }
        }
            cadenceLabel.text = [NSString stringWithFormat:@"%d", bpRawData.wheelTorqueData.instantCadence];
        NSLog(@"haspower");
        pwrBattImg.hidden = pwrBatt.hidden = pwrBattTitle.hidden =  NO;
        if ( self.powerConnection.isANTConnection )
        {
            WFSensorData* data = [self.powerConnection getRawData];
           
            // check that the ANT+ common data is present.
            if ( [data respondsToSelector:@selector(commonData)] )
            {
                // get the ANT+ common data and display the detail view.
                WFCommonData* commonData = (WFCommonData*)[data performSelector:@selector(commonData)];
                if (commonData.batteryStatus==WF_BATTERY_STATUS_NOT_AVAILABLE) {
                } else {
                }
                pwrBatt.text = [self percentForBattStatus:commonData.batteryStatus];
            } 
        }
    }
    
    
    WFBikeCadenceData* cData = [self.cadenceConnection getBikeCadenceData];
	if ( cData != nil )
	{
        if (!hasSignal) {
            hasSignal = YES;
            float signal = [self.cadenceConnection signalEfficiency];
            [sensorStrength setImage:[self sensorImageForStrength:signal]];
        }
        
        cadenceLabel.text = [NSString stringWithFormat:@"%d", cData.instantCrankRPM];
    }
    
    
    WFHeartrateData* hrData = [self.heartrateConnection getHeartrateData];
	WFHeartrateRawData* hrRawData = [self.heartrateConnection getHeartrateRawData];
	if ( hrData != nil )
	{
        
        if (!hasSignal) {
            float signal = [self.heartrateConnection signalEfficiency];
            [sensorStrength setImage:[self sensorImageForStrength:signal]];
        }
        
        // update basic data.
        computedHeartrateLabel.text = [hrData formattedHeartrate:NO];
       
        if ( hrRawData.btleCommonData )
        {
            if ( hrRawData.btleCommonData.batteryLevel == WF_BTLE_BATT_LEVEL_INVALID )
            {
                hrmBattImg.hidden = hrmBatt.hidden = hrmBattTitle.hidden = NO;
                hrmBatt.text = @"n/a";
            }
            else
            {
                hrmBattImg.hidden = hrmBatt.hidden = hrmBattTitle.hidden = NO;
                hrmBatt.text = [NSString stringWithFormat:@"%u%%", hrRawData.btleCommonData.batteryLevel];
            }
        } else if (hrRawData.commonData) {
            hrmBattImg.hidden = hrmBatt.hidden = hrmBattTitle.hidden = NO;
            hrmBatt.text = [self percentForBattStatus:hrRawData.commonData.batteryStatus];
        } 
    }
    
}


#pragma mark -
#pragma mark RunningViewController Implementation


#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHeartrateConnection*)heartrateConnection
{
	return (WFHeartrateConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE]];
}

//--------------------------------------------------------------------------------
- (WFBikePowerConnection*)powerConnection
{
	return (WFBikePowerConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_POWER]];
}

//--------------------------------------------------------------------------------
- (WFBikeSpeedConnection*)speedConnection
{
	return (WFBikeSpeedConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_SPEED]];
}

//--------------------------------------------------------------------------------
- (WFBikeSpeedCadenceConnection*)speedCadenceConnection
{
	return (WFBikeSpeedCadenceConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_SPEED_CADENCE]];
}

//--------------------------------------------------------------------------------
- (WFBikeCadenceConnection*)cadenceConnection
{
	return (WFBikeCadenceConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_BIKE_CADENCE]];
}

- (void)doConfig:(id)sender
{
    NSArray * cArr;
    NSString *configHelp;
    if (desiredNetwork == WF_NETWORKTYPE_BTLE) {
        cArr = [NSArray arrayWithObjects:@"HeartrateViewController", @"BikeSpeedCadenceViewController", @"BikePowerViewController", nil];
        configHelp = @"btlebikingconfighelp";
    } else {
        cArr = [NSArray arrayWithObjects:@"HeartrateViewController", @"BikePowerViewController", @"BikeSpeedViewController", @"BikeSpeedCadenceViewController", @"BikeCadenceViewController", nil];
        configHelp = @"bikingconfighelp";
    }
    ConfigScrollerController * csc = [[ConfigScrollerController alloc] initWithNibName:@"ConfigScrollerController" bundle:nil controllersArray:cArr];
    csc.configHelp = configHelp;
    csc.applicableNetworks = desiredNetwork;
    [self.navigationController pushViewController:csc animated:TRUE];
    [csc release];
}

- (void)doHelp:(id)sender
{
    NSString * help;
    if (desiredNetwork == WF_NETWORKTYPE_BTLE) {
        help = @"btlesensorhelp";
    } else {
        help = @"antsensorhelp";
    }
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:help ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}
@end
