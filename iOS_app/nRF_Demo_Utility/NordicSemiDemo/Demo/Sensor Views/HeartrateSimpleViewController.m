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

#import "HeartrateSimpleViewController.h"
#import "HeartrateViewController.h"
#import "HelpViewController.h"
#import "NordicSemiAppDelegate.h"

@implementation HeartrateSimpleViewController

@synthesize computedHeartrateLabel, ANTLogo, BTLogo, battLevelLabel, graphView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forNetwork:(WFNetworkType_t)network
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sensorTypes = [[NSArray arrayWithObjects:[NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE], nil] retain];
        sensorConnections = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
        desiredNetwork = network;
    }
    return self;
}

-(void) dealloc 
{
    
    NSLog(@"HR dealloc");
    self.heartrateConnection.delegate = nil;
    [computedHeartrateLabel release];
    [ANTLogo release];
    [BTLogo release];
    [graph release];
    [graphView release];
    [linePlot release];
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
    NSLog(@"HR viewDidLoad");
    self.heartrateConnection.delegate = self;
    computedHeartrateLabel.text = @"- ";
    if (desiredNetwork == WF_NETWORKTYPE_ANTPLUS) {
        BTLogo.hidden = YES;
        ANTLogo.hidden = NO;
    } else {
        BTLogo.hidden = NO;
        ANTLogo.hidden = YES;
    }
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
    [yRange setLength:[[NSNumber numberWithFloat:220] decimalValue]];
	plotSpace.xRange = xRange;
	plotSpace.yRange = yRange; 
    
    validTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
    NSLog(@"samples are valid after %1.0f", validTimestamp);
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
    computedHeartrateLabel.text = @"- ";
    battLevelLabel.text = @"n/a";
    [sensorStrength setImage:[self sensorImageForStrength:-1]];
}

//--------------------------------------------------------------------------------
- (void)updateData
{
	WFHeartrateData* hrData = [self.heartrateConnection getHeartrateData];
	WFHeartrateRawData* hrRawData = [self.heartrateConnection getHeartrateRawData];
	if ( hrData != nil )
	{
               
        // update the signal efficiency.
		float signal = [self.heartrateConnection signalEfficiency];
        [sensorStrength setImage:[self sensorImageForStrength:signal]];
        // update basic data.
        computedHeartrateLabel.text = [hrData formattedHeartrate:NO];
        double timestamp = hrData.timestamp;
     //   NSLog(@"HR timestamp: %1.0f", timestamp);
        if (timestamp > validTimestamp) {
            NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
            id x = [NSNumber numberWithDouble:timestamp];
            id y = [NSNumber numberWithInt:hrData.computedHeartrate];
            NSDictionary *sample = [NSDictionary dictionaryWithObjectsAndKeys:x, @"timestamp", y, @"bpm", nil];
            [appDelegate storeHRMPlot:sample];
            [graph reloadData];
        }
        
        if ( hrRawData.btleCommonData )
        {
            if ( hrRawData.btleCommonData.batteryLevel == WF_BTLE_BATT_LEVEL_INVALID )
            {
                battLevelLabel.text = @"n/a";
            }
            else
            {
                battLevelLabel.text = [NSString stringWithFormat:@"%u%%", hrRawData.btleCommonData.batteryLevel];
            }
        } else if (hrRawData.commonData) {
            battLevelLabel.text = [self percentForBattStatus:hrRawData.commonData.batteryStatus];
        } 
    }
	else 
	{
		[self resetDisplay];
	}
}

#pragma mark -
#pragma mark HeartrateSimpleViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHeartrateConnection*)heartrateConnection
{
	return (WFHeartrateConnection*)[sensorConnections objectForKey:[NSNumber numberWithInt:WF_SENSORTYPE_HEARTRATE]];
}

- (void)doConfig:(id)sender
{
    HeartrateViewController *vc = [[HeartrateViewController alloc] initWithNibName:@"HeartrateViewController" bundle:nil forSensor:WF_SENSORTYPE_HEARTRATE];
    if (desiredNetwork == WF_NETWORKTYPE_BTLE) vc.applicableNetworks = desiredNetwork;
    [self.navigationController pushViewController:vc animated:TRUE];
    [vc release];
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

#pragma mark -
#pragma mark CPTPlotDataSource Protocol Implementation

//--------------------------------------------------------------------------------
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    return [[appDelegate hrmPlotData] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary * sample = [[appDelegate hrmPlotData] objectAtIndex:index];
    NSNumber * num = nil;
	if ( fieldEnum == CPTScatterPlotFieldX ) {
        double offset = [[appDelegate initialHRMTime] doubleValue];
        double timestamp = [[sample objectForKey:@"timestamp"] doubleValue];
		num = [NSNumber numberWithDouble:(offset - timestamp)];
	} else {
        num = [sample objectForKey:@"bpm"];
    }
	return num;
}
@end
