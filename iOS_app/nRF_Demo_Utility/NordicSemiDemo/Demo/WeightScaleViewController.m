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
//  WFWeightScaleViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/12/10.
//

#import "WeightScaleViewController.h"
#import "WeightScaleConfController.h"
#import "HistoryManager.h"
#import "WeightHistoryViewController.h"
#import "HelpViewController.h"

/////////////////////////////////////////////////////////////////////////////
// Weight Scale Definitions.
/////////////////////////////////////////////////////////////////////////////

#define WS_WEIGHT_COMPUTING    0xFFFE
#define WS_WEIGHT_INVALID      0xFFFF


@interface WeightScaleViewController (_PRIVATE_)

- (void)sendUserProfile;

@end

/////////////////////////////////////////////////////////////////////////////
// WFWeightScaleViewController Implementation.
/////////////////////////////////////////////////////////////////////////////

@implementation WeightScaleViewController
{
    WFNetworkType_t networkType;
}

@synthesize bodyWeightLabel;
@synthesize hydrationPercentLabel;
@synthesize bodyFatPercentLabel;
@synthesize muscleMassLabel;
@synthesize boneMassLabel;
@synthesize sampledateLabel;
@synthesize sampletimeLabel;
@synthesize unitSwitch;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[bodyWeightLabel release];
	[hydrationPercentLabel release];
	[bodyFatPercentLabel release];
	[muscleMassLabel release];
	[boneMassLabel release];
	[sampledateLabel release];
	[sampletimeLabel release];
	[unitSwitch release];
	
    [_antPlusLogo release];
    [_bluetoothSmartLogo release];
    [_bodyFatTextLabel release];
    [_hydrationPercentTextLabel release];
    [_muscleMassTextLabel release];
    [_boneMassTextLabel release];
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forNetwork:(WFNetworkType_t) newNetworkType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_WEIGHT_SCALE], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
        
        networkType = newNetworkType;
    }
    return self;
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
	conversionFactor = 1.0;
	lastWeight = -1;
	
	[super viewDidLoad];
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{	
    [self resetDisplay];
    [super viewWillAppear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // disconnect the scale? 
  /*  if ( wsConnection.isValid )
    {
        wsConnection.delegate = nil;
        [wsConnection disconnect];
        [wsConnection release];
        wsConnection = nil;
    } */
}

#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (BOOL)isWildcardSearch
{
    // weight scale always wildcard.
    return TRUE;
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
    
    [self displayLastRecord];
    
    if (networkType == WF_NETWORKTYPE_ANTPLUS)
    {
        self.hydrationPercentTextLabel.hidden = NO;
        hydrationPercentLabel.hidden = NO;
        hydrationPercentLabel.text = @"n/a";
        self.bodyFatTextLabel.hidden = NO;
        bodyFatPercentLabel.hidden = NO;
        bodyFatPercentLabel.text = @"n/a";
        self.muscleMassTextLabel.hidden = NO;
        muscleMassLabel.hidden = NO;
        muscleMassLabel.text = @"n/a";
        self.boneMassTextLabel.hidden = NO;
        boneMassLabel.hidden = NO;
        boneMassLabel.text = @"n/a";
        self.antPlusLogo.hidden = NO;
        self.bluetoothSmartLogo.hidden = YES;
    }
    else
    {
        self.hydrationPercentTextLabel.hidden = YES;
        hydrationPercentLabel.hidden = YES;
        self.bodyFatTextLabel.hidden = YES;
        bodyFatPercentLabel.hidden = YES;
        self.muscleMassTextLabel.hidden = YES;
        muscleMassLabel.hidden = YES;
        self.boneMassTextLabel.hidden = YES;
        boneMassLabel.hidden = YES;
        
        self.bluetoothSmartLogo.hidden = NO;
        self.antPlusLogo.hidden = YES;
    }
    
    connectingIndicator.hidden = YES;
    [connectingIndicator stopAnimating];
}

//--------------------------------------------------------------------------------
- (void)updateData
{
	WFWeightScaleData* wsData = [self.wsConnection getWeightScaleData];
    WFANTWeightScaleData *wsANTData = nil;
    if ([wsData isKindOfClass:[WFANTWeightScaleData class]]) {
        wsANTData = (WFANTWeightScaleData *) wsData;
    }
	if ( wsData != nil )
	{
        
        // update the signal efficiency.
        float signal = [self.wsConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
		static BOOL bSaveToHistory = FALSE;
		
		if (wsData.bodyWeight == WS_WEIGHT_COMPUTING)
		{			
			// once data has been received, the scale will timeout.
			// when this happens, disconnect from the scale.
			if (bDataReceived)
			{
				// disconnect from the scale.
				[self.wsConnection disconnect];
				
				if (bSaveToHistory)
				{
					[self saveToHistory];
					bSaveToHistory = FALSE;
				}
			}
			else
			{
				bodyWeightLabel.text = @"---";
			}
		}
		else
		{
			bDataReceived = TRUE;
			bSaveToHistory = TRUE;
            lastWeight = (wsData.bodyWeight == -1 ? 0 : wsData.bodyWeight);
            [self displayLastRecord];
		}
        
        if ( wsANTData.hydrationPercent == WF_WEIGHT_SCALE_INVALID )
        {
            hydrationPercentLabel.text = @"n/a";
        }
        else if ( wsANTData.hydrationPercent == WF_WEIGHT_SCALE_COMPUTING )
        {
            hydrationPercentLabel.text = @"--";
        }
        else
        {
            hydrationPercentLabel.text = [NSString stringWithFormat:@"%1.2f %%", wsANTData.hydrationPercent ];
        }
        
        if ( wsANTData.bodyFatPercent == WF_WEIGHT_SCALE_INVALID )
        {
            bodyFatPercentLabel.text = @"n/a";
        }
        else if ( wsANTData.bodyFatPercent == WF_WEIGHT_SCALE_COMPUTING )
        {
            bodyFatPercentLabel.text = @"--";
        }
        else
        {
            bodyFatPercentLabel.text = [NSString stringWithFormat:@"%1.2f %%", wsANTData.bodyFatPercent ];
        }
       
        if ( wsANTData.muscleMass == WF_WEIGHT_SCALE_INVALID )
        {
            muscleMassLabel.text = @"n/a";
        }
        else if ( wsANTData.muscleMass == WF_WEIGHT_SCALE_COMPUTING )
        {
            muscleMassLabel.text = @"--";
        }
        else
        {
            NSString* units = (conversionFactor == 1.0) ? @"kg" : @"lbs";
            muscleMassLabel.text = [NSString stringWithFormat:@"%1.2f %@", wsANTData.muscleMass*conversionFactor, units];
        }
        
        if ( wsANTData.boneMass == WF_WEIGHT_SCALE_INVALID )
        {
            boneMassLabel.text = @"n/a";
        }
        else if ( wsANTData.boneMass == WF_WEIGHT_SCALE_COMPUTING )
        {
            boneMassLabel.text = @"--";
        }
        else
        {
            NSString* units = (conversionFactor == 1.0) ? @"kg" : @"lbs";
            boneMassLabel.text = [NSString stringWithFormat:@"%1.1f %@", wsANTData.boneMass*conversionFactor, units];
        }
	}
}

//--------------------------------------------------------------------------------
- (void)sensorConnected:(WFSensorConnection*)connectionInfo
{
    // update the signal efficiency.
    float signal = [self.wsConnection signalEfficiency];
    [sensorStrength setImage:[self sensorImageForStrength:signal]];
    
    bDataReceived = FALSE;
    lastWeight = -1;
    [self sendUserProfile];
}


#pragma mark -
#pragma mark WFWeightScaleViewController Implementation

#pragma mark Properties
//--------------------------------------------------------------------------------
- (WFWeightScaleConnection*)wsConnection
{
	return (WFWeightScaleConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_WEIGHT_SCALE]];
}

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)displayLastRecord
{
    if (lastWeight != -1 && [self.wsConnection isConnected])
    {
        bodyWeightLabel.text = [NSString stringWithFormat:@"%1.2f", (lastWeight*conversionFactor)];
    }
    else
    {
        bodyWeightLabel.text = @"n/a";
    }
}

//--------------------------------------------------------------------------------
- (void)saveToHistory
{
	// save the weight.
    FIT_WEIGHT_SCALE_MESG stMesg;
    memset( &stMesg, 0, sizeof(FIT_WEIGHT_SCALE_MESG) );
    stMesg.timestamp = [WFFitParser getTimestampFromDate:[NSDate date]];
    stMesg.weight = lastWeight;
    WFFitMessageWeightScale* wsRec = [[WFFitMessageWeightScale alloc] initWithRecord:&stMesg];
	NSMutableArray* records = [NSMutableArray arrayWithCapacity:1];
	[records addObject:wsRec];
	
	HistoryManager* hist = [[HistoryManager alloc] init];
	[hist saveHistory:WF_ANTFS_DEVTYPE_WEIGHT_SCALE fitRecords:records];
	[wsRec release];
	[hist release];
}


//--------------------------------------------------------------------------------
- (void)sendUserProfile
{
    // ensure a valid weight scale connection.
    if ( self.wsConnection )
    {
        // create and configure a weight scale profile structure.
        WFWeightScaleUserProfile_t profile;
        
        profile.userProfileId = 16;
        profile.gender = WF_WSS_GENDER_MALE;
        profile.age = 32;
        profile.height = 178;
        profile.athelete = FALSE;
        profile.activityLevel = 1;
        
        // send the weight scale profile through the connection.
        [self.wsConnection setWeightScaleUserProfile:&profile];
    }
}


#pragma mark Event Handlers

//-------------------------------------------------------------------------------
- (IBAction)historyClicked:(id)sender
{
	// if history is clicked while scale is connected,
	// if the scale is non-antfs, save last weight.
	WFWeightScaleData* wsData = [self.wsConnection getWeightScaleData];
    WFANTWeightScaleData *wsANTData = nil;
    if ([wsData isKindOfClass:[WFANTWeightScaleData class]]) {
        wsANTData = (WFANTWeightScaleData *) wsData;
    }
	
	if ( wsANTData != nil )
    {
		if ( !wsANTData.hasAntFS )
		{
			[self saveToHistory];
		}	
	}
	
	// load the history page.
	WeightHistoryViewController *historyView = [[WeightHistoryViewController alloc] initWithNibName:@"WeightHistoryViewController" bundle:nil];
	historyView.conversionFactor = conversionFactor;
	historyView.hardwareConnector = hardwareConnector;
	[self.navigationController pushViewController:historyView animated:TRUE];
}

//-------------------------------------------------------------------------------
- (IBAction)unitChanged:(id)sender
{
	if ([unitSwitch selectedSegmentIndex] == 0)
	{
		conversionFactor = 2.20462262;
	}
	else
	{
		conversionFactor = 1.0;
	}
	[self displayLastRecord];
}

//--------------------------------------------------------------------------------
- (IBAction)profileClicked:(id)sender
{
    [self sendUserProfile];
}

- (void)doConfig:(id)sender
{
    WeightScaleConfController *vc = [[WeightScaleConfController alloc] initWithNibName:@"WeightScaleConfController" bundle:nil forSensor:WF_SENSORTYPE_WEIGHT_SCALE];
    vc.applicableNetworks = desiredNetwork;
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
} 


- (void)doHelp:(id)sender
{
  // need help for Weight Scale
    HelpViewController* vc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    vc.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"antwshelp" ofType:@"html"]];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self   presentModalViewController:vc animated:YES];
    [vc release];
}

- (void)viewDidUnload {
    [self setAntPlusLogo:nil];
    [self setBluetoothSmartLogo:nil];
    [self setBodyFatTextLabel:nil];
    [self setHydrationPercentTextLabel:nil];
    [self setMuscleMassTextLabel:nil];
    [self setBoneMassTextLabel:nil];
    [super viewDidUnload];
}
@end
