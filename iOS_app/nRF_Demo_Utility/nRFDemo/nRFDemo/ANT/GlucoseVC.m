///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012 Nordic Semiconductor. All Rights Reserved.
// Copyright (c) 2012 Wahoo Fitness. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA and Wahoo Fitness LLC.
// Terms and conditions of usage are described in detail in
// NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
///////////////////////////////////////////////////////////////////////////////
//
//  GlucoseVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "GlucoseVC.h"


@interface GlucoseVC (_PRIVATE_)

@end


@implementation GlucoseVC

@synthesize permissionKeyField;
@synthesize txIdField;

@synthesize concentrationLabel;
@synthesize changeRateLabel;
@synthesize timestampLabel;
@synthesize alertHighLabel;
@synthesize alertLowLabel;
@synthesize alertRisingLabel;
@synthesize alertFallingLabel;
@synthesize alertBelow55Label;

@synthesize deviceTimeLabel;
@synthesize elapsedTimeLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [permissionKeyField release];
    [txIdField release];
    
    [concentrationLabel release];
    [changeRateLabel release];
    [timestampLabel release];
    [alertHighLabel release];
    [alertLowLabel release];
    [alertRisingLabel release];
    [alertFallingLabel release];
    [alertBelow55Label release];
    
    [deviceTimeLabel release];
    [elapsedTimeLabel release];
	
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
    {
        sensorType = WF_SENSORTYPE_GLUCOSE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Glucose";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFGlucoseDelegate Implementation

//--------------------------------------------------------------------------------
- (void)glucoseConnection:(WFGlucoseConnection*)glucoseConn didReceiveRecord:(WFGlucoseData*)record
{
    NSLog(@"GLUCOSE RECORD RECEIVED");
    
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
    else concentrationLabel.text = [NSString stringWithFormat:@"%u", record.usConcentration];
    
    changeRateLabel.text = [NSString stringWithFormat:@"%u", record.rateOfChange];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    timestampLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:record.timestamp]];
    deviceTimeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:record.currentDeviceTime]];
    [df release];
    
    elapsedTimeLabel.text = [NSString stringWithFormat:@"%lu", record.ulElapsedTime];
    
    alertHighLabel.text = record.status.bHighAlert ? @"ON" : @"OFF";
    alertLowLabel.text = record.status.bLowAlert ? @"ON" : @"OFF";
    alertRisingLabel.text = record.status.bRisingAlert ? @"ON" : @"OFF";
    alertFallingLabel.text = record.status.bFallingAlert ? @"ON" : @"OFF";
    alertBelow55Label.text = record.status.bBelow55 ? @"ON" : @"OFF";
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

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
        
        // DEBUG:  set alert levels.
        [glucoseConn setAlertLevelsRising:WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN
                                  falling:WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN
                              highGlucose:300
                               lowGlucose:100];

        [glucoseConn setPermissionKey:permKey andTxId:txId];
    }
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
	[super resetDisplay];
    
	concentrationLabel.text = @"n/a";
	changeRateLabel.text = @"n/a";
	timestampLabel.text = @"n/a";
	alertHighLabel.text = @"n/a";
	alertLowLabel.text = @"n/a";
	alertRisingLabel.text = @"n/a";
	alertFallingLabel.text = @"n/a";
	alertBelow55Label.text = @"n/a";
    
	deviceTimeLabel.text = @"n/a";
	elapsedTimeLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFGlucoseData* glucData = [self.glucoseConnection getGlucoseData];
	if ( glucData != nil )
	{
        // data updated in glucoseConnection:didReceiveRecord: method.
	}
	else
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark GlucoseVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------


#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFGlucoseConnection*)glucoseConnection
{
	WFGlucoseConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFGlucoseConnection class]] )
	{
		retVal = (WFGlucoseConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)connectSensorClicked:(id)sender
{
	// get the current connection status.
	WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
	if ( sensorConnection != nil )
	{
		connState = sensorConnection.connectionStatus;
	}

    // the permission key and transmitter id are parsed on connect.
    if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // parse the TX ID and permission key.
        NSArray* tidValues = [txIdField.text componentsSeparatedByString:@"-"];
        NSArray* pkValues = [permissionKeyField.text componentsSeparatedByString:@"-"];
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

@end
