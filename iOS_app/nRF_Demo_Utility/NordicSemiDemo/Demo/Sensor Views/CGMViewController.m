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

#import "CGMViewController.h"
#import "HelpViewController.h"
#import "GlucoseVC.h"
#import "HistoryManager.h"
#import "NordicSemiAppDelegate.h"
#import "MultiConfigScrollerController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface CGMViewController (_PRIVATE_) 

-(NSString *)calcPace:(float)speed;

@end

@implementation CGMViewController

@synthesize concentrationLabel, battLevelLabel, trend, graphView, upperLine, lowerLine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_GLUCOSE], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
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
    NSLog(@"viewDidLoad");
    [self resetDisplay];
    [super viewDidLoad];
    canPlaySound = YES;
    glucoseVC = [[GlucoseVC alloc] initWithNibName:@"GlucoseVC" bundle:nil forSensor:WF_SENSORTYPE_GLUCOSE];
    gVCSettings = [[GlucoseVCSettings alloc] initWithNibName:@"GlucoseVCSettings" bundle:nil forSensor:WF_SENSORTYPE_GLUCOSE];
    
    CGRect bounds = graphView.bounds;
    graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    graphView.hostedGraph = graph;
    graph.paddingTop = graph.paddingRight = graph.paddingLeft = graph.paddingBottom = 0;
    
    graph.axisSet.axes = [NSArray arrayWithObjects:nil];
    // Setup scatter plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = NO;
    
    linePlot = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [[linePlot.dataLineStyle mutableCopy] autorelease];
	lineStyle.lineWidth				 = 1.0;
	lineStyle.lineColor				 = [CPTColor whiteColor];
	linePlot.dataLineStyle = lineStyle;
    linePlot.dataSource = self;
    [graph addPlot:linePlot];
    
    
	CPTMutablePlotRange *xRange = [[plotSpace.xRange mutableCopy] autorelease];
     CPTMutablePlotRange *yRange = [[plotSpace.yRange mutableCopy] autorelease];
     [xRange setLocation:[[NSNumber numberWithFloat:0] decimalValue]];
     [xRange setLength: [[NSNumber numberWithFloat:600] decimalValue]];
     [yRange setLocation:[[NSNumber numberWithFloat:0] decimalValue]];
     [yRange setLength:[[NSNumber numberWithFloat:450] decimalValue]];
	plotSpace.xRange = xRange;
	plotSpace.yRange = yRange; 
    
    upperLine.hidden = YES;
    lowerLine.hidden = YES;
    
    WFGlucoseConnection* glucoseConn = self.glucoseConnection;
    if ( glucoseConn )
    {
        // configure the glucose delegate.
        glucoseConn.glucoseDelegate = self;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(plotTest:) userInfo:nil repeats:YES];
    
    HistoryManager * hm = [[HistoryManager alloc] init];
    NSDictionary *info = [hm getCGMInfo];
    [hm release];
    riseAlertLevel = [[info objectForKey:@"riseAlertLevel"] intValue];
    fallAlertLevel = [[info objectForKey:@"fallAlertLevel"] intValue];
    soundLowAlert = [[info objectForKey:@"lowAlert"] boolValue];
    soundHighAlert = [[info objectForKey:@"highAlert"] boolValue];
    soundRiseAlert = [[info objectForKey:@"riseAlert"] boolValue];
    soundFallAlert = [[info objectForKey:@"fallAlert"] boolValue];
    
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
    [concentrationLabel release];
    [battLevelLabel release];
    [trend release];
    [graph release];
    [graphView release];
    [glucoseVC release];
    [gVCSettings release];
    [linePlot release];
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    concentrationLabel.text = @"--";
    battLevelLabel.text = @"n/a";
    trend.hidden = YES;
    [glucoseVC resetDisplay];
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    WFGlucoseData* glucData = [self.glucoseConnection getGlucoseData];
	if ( glucData != nil )
	{
		float signal = [self.glucoseConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
		if (glucData.commonData) {
            battLevelLabel.text = [self percentForBattStatus:glucData.commonData.batteryStatus];
        } 
	}
	else
	{
		[self resetDisplay];
	}
}


#pragma mark -
#pragma mark WFGlucoseDelegate Implementation

//--------------------------------------------------------------------------------
- (void)glucoseConnection:(WFGlucoseConnection*)glucoseConn didReceiveRecord:(WFGlucoseData*)record
{
    NSLog(@"GLUCOSE RECORD RECEIVED");
    
    // read high and low values from sensor here
    
    highValue = record.usHighAlertLevel;
    lowValue = record.usLowAlertLevel;
    
    CGRect upperFrame = upperLine.frame;
    upperFrame.origin.y = (float)(450-highValue)*0.24 + 30;;
    upperLine.frame = upperFrame;
    CGRect lowerFrame = lowerLine.frame;
    lowerFrame.origin.y = (float)(450-lowValue)*0.24 + 30;;
    lowerLine.frame = lowerFrame;
    lowerLine.hidden = upperLine.hidden = NO;
    [lowerLine setNeedsDisplay];
    
    int concentration = -1;
    if ( record.usConcentration <= WF_GLUCOSE_VALUES_EQUILIBRIUM_100 )
    {
        switch (record.usConcentration)
        {
            case WF_GLUCOSE_VALUES_UNINITIALIZED:
                concentrationLabel.text = @"U/I";
                break;
            case WF_GLUCOSE_VALUES_UNAVAILABLE:
                concentrationLabel.text = @"U/A";
                break;
            case WF_GLUCOSE_VALUES_FILE_DATA_ONLY:
                concentrationLabel.text = @"FILE";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_25:
                concentrationLabel.text = @"EQ < 25";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_50:
                concentrationLabel.text = @"EQ < 50";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_75:
                concentrationLabel.text = @"EQ < 75";
                break;
            case WF_GLUCOSE_VALUES_EQUILIBRIUM_100:
                concentrationLabel.text = @"EQ < 100";
                break;
        }
    }
    else {
        NSLog(@"set concentration");
            
        concentration = record.usConcentration;
        concentrationLabel.text = [NSString stringWithFormat:@"%u", concentration];
        double timestamp = [record.timestamp timeIntervalSinceReferenceDate];
        NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
        id x = [NSNumber numberWithDouble:timestamp];
        id y = [NSNumber numberWithInt:record.usConcentration];
        NSDictionary *sample = [NSDictionary dictionaryWithObjectsAndKeys:x, @"timestamp", y, @"concentration", nil];
        [appDelegate storeGGMPlot:sample];
        [graph reloadData];
    }
   
    [glucoseVC glucoseConnection:glucoseConn didReceiveRecord:record];
    WFGlucoseChangeRate_t rateOfChange = record.rateOfChange;
    
    BOOL needsAlert = NO;
    
    trend.hidden = NO;
    switch (rateOfChange) {
        case WF_GLUCOSE_CHANGE_RATE_STEADY:
            [trend setImage:[UIImage imageNamed:@"constantArrowWhite.png"]];
            break;
        case WF_GLUCOSE_CHANGE_RATE_SLOWLY_DECREASING:
            [trend setImage:[UIImage imageNamed:@"downArrowWhite.png"]];
            break;
        case WF_GLUCOSE_CHANGE_RATE_SLOWLY_INCREASING:
            [trend setImage:[UIImage imageNamed:@"upArrowWhite.png"]];
            break;
        case WF_GLUCOSE_CHANGE_RATE_DECREASING:
            [trend setImage:[UIImage imageNamed:@"mediumDownArrowWhite.png"]];
      //      if (fallAlertLevel >= WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN && soundFallAlert) needsAlert = YES;
            break;
        case WF_GLUCOSE_CHANGE_RATE_INCREASING:
            [trend setImage:[UIImage imageNamed:@"mediumUpArrowWhite.png"]];
      //      if (riseAlertLevel >= WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN && soundRiseAlert) needsAlert = YES;
            break;
        case WF_GLUCOSE_CHANGE_RATE_RAPIDLY_DECREASING:
            [trend setImage:[UIImage imageNamed:@"rapidDownArrowWhite.png"]];
      //      if (fallAlertLevel >= WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN && soundFallAlert) needsAlert = YES;
            break;
        case WF_GLUCOSE_CHANGE_RATE_RAPIDLY_INCREASING:
            [trend setImage:[UIImage imageNamed:@"rapidUpArrowWhite.png"]];
       //     if (riseAlertLevel >= WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN && soundRiseAlert) needsAlert = YES;
            break;
        case WF_GLUCOSE_CHANGE_RATE_UNAVAILABLE:
            trend.hidden = YES;
            break;
            
        default:
            break;
    }
    
   // if ((concentration >= highValue && soundHighAlert) || (concentration <= lowValue && soundLowAlert)) needsAlert = YES;
    
    if (record.status.bBelow55 ) { //|| concentration < 55
        trend.hidden = NO;
        needsAlert = YES;
        [trend setImage:[UIImage imageNamed:@"below55.png"]];
    }
    if (needsAlert || (record.status.bHighAlert && soundHighAlert) || (record.status.bLowAlert && soundLowAlert)
        || (record.status.bRisingAlert && soundRiseAlert) || (record.status.bFallingAlert && soundFallAlert)) {
        [self soundAlert];
        canPlaySound = NO; // at least 5 second interval to next sound being played
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(enableSounds:) userInfo:nil repeats:NO];
    }
}

-(void)enableSounds:(NSTimer*)timer
{
    canPlaySound = YES;
}

#pragma mark -
#pragma mark NSSimpleBaseBC Implementation

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    [super onSensorConnected:connectionInfo];
    
    // set the glucose delegate parameters.
    WFGlucoseConnection* glucoseConn = self.glucoseConnection;
    if ( glucoseConn )
    {
        // configure the glucose delegate.
        glucoseConn.glucoseDelegate = self;
        
        /*
         // DEBUG:  permission key.
         // tx id:  41-36-45-38-36
         // perm key:  48-D1-EA-35
         // config key: E6-77-29-CA
         UCHAR auc_tx[] = { 0x41, 0x36, 0x45, 0x38, 0x36 };
         UCHAR auc_perm[] = { 0x48, 0xD1, 0xEA, 0x35 };
         UCHAR auc_config[] = { 0xE6, 0x77, 0x29, 0xCA };
         */
        
        NSData* permKey = [NSData dataWithBytes:auc_perm_key length:4];
        NSData* txId = [NSData dataWithBytes:auc_tx_id length:5];
        
        [glucoseConn setPermissionKey:permKey andTxId:txId];
       
       /* [self.glucoseConnection setAlertLevelsRising:riseAlertLevel
                                             falling:fallAlertLevel
                                         highGlucose:highValue
                                          lowGlucose:lowValue];
        */
    }
}

#pragma mark -
#pragma mark CGMViewController Implementation

-(void)soundAlert
{
    //create vibrate 
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //play sound
    SystemSoundID pmph;
    NSURL *burl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sounds-solemn" ofType:@"mp3"]];
    CFURLRef baseURL = (CFURLRef) burl;
    AudioServicesCreateSystemSoundID (baseURL, &pmph);
    AudioServicesPlaySystemSound(pmph); 
}


#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFGlucoseConnection*)glucoseConnection
{
	return (WFGlucoseConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_GLUCOSE]];
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)connectSensorClicked:(id)sender
{
	// get the current connection status.
	WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
	if ( self.glucoseConnection != nil )
	{
		connState = self.glucoseConnection.connectionStatus;
	}
    
    // the permission key and transmitter id are parsed on connect.
    if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // get the tid and pk vals from HistoryManager
        HistoryManager * hm = [[HistoryManager alloc] init];
        NSDictionary *info = [hm getCGMInfo];
        [hm release];
        NSString *txIdStr = [info objectForKey:@"txId"];
        NSString *permKeyStr = [info objectForKey:@"permissionKey"];
        NSLog(@"using txid %@, permKey %@", txIdStr, permKeyStr);
        
        
        // parse the TX ID and permission key.
        NSArray* tidValues = [txIdStr componentsSeparatedByString:@"-"];
        NSArray* pkValues = [permKeyStr componentsSeparatedByString:@"-"];
        if ( [tidValues count] == 5 && [pkValues count] == 4 )
        {
            // parse the TX ID.
            for ( int i=0; i<5; i++ )
            {
                // scan to convert HEX string into uint.
                uint scanInt;
                [[NSScanner scannerWithString:(NSString*)[tidValues objectAtIndex:i]] scanHexInt:&scanInt];
                
                // add to the buffer.
                auc_tx_id[i] = (uint8_t)scanInt;
            }
            
            // parse the permission key.
            for ( int i=0; i<4; i++ )
            {
                // scan to convert HEX string into uint.
                uint scanInt;
                [[NSScanner scannerWithString:(NSString*)[pkValues objectAtIndex:i]] scanHexInt:&scanInt];
                
                // add to the buffer.
                auc_perm_key[i] = (uint8_t)scanInt;
            }
            
            // connect the sensor.
            [super connectSensorClicked:sender];
        }
        else
        {
            // error message.
            NSString* msg = @"Please ensure the keys are in the following format:\nTID: 00-00-00-00-00\nPerm Key: 00-00-00-00";
            
            // alert the user that the keys are incorrect.
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Key Error"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
    // other states just use the base class.
    else
    {
        [super connectSensorClicked:sender];
    }
}

- (void)doConfig:(id)sender
{ 
  //  [gVCSettings configSettings];
    [gVCSettings resetDisplay];
    NSArray * cArr = [NSArray arrayWithObjects:gVCSettings, glucoseVC, nil];
    MultiConfigScrollerController * csc = [[MultiConfigScrollerController alloc] initWithNibName:@"MultiConfigScrollerController" bundle:nil controllersArray:cArr];
    csc.configHelp = @"cgmconfighelp";
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


#pragma mark -
#pragma mark CPTPlotDataSource Protocol Implementation

//--------------------------------------------------------------------------------
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    return [[appDelegate cgmPlotData] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary * sample = [[appDelegate cgmPlotData] objectAtIndex:index];
    NSNumber * num = nil;
	if ( fieldEnum == CPTScatterPlotFieldX ) {
        double offset = [[appDelegate initialCGMTime] doubleValue];
        double timestamp = [[sample objectForKey:@"timestamp"] doubleValue];
		num = [NSNumber numberWithDouble:(offset - timestamp)];
	} else {
        num = [sample objectForKey:@"concentration"];
    }
	return num;
}

@end
