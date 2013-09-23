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
//  DeviceDiscoveryVC.m
//  WahooDemo
//
//  Created by Michael Moore on 3/9/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "DeviceDiscoveryVC.h"
#import "WFSensorCommonViewController.h"

#import "BikeCadenceViewController.h"
#import "BikePowerViewController.h"
#import "BikeSpeedViewController.h"
#import "FootpodViewController.h"
#import "WeightScaleViewController.h"
#import "GlucoseVC.h"

#import "BikeSpeedCadenceViewController.h"
#import "HeartrateViewController.h"

#import "ProximityViewController.h"
#import "TemperatureViewController.h"
#import "BTBloodPressureVC.h"
#import "BTGlucoseVC.h"



#pragma mark -
#pragma mark Helper Classes

@implementation DeviceInfo

@synthesize sensorType;
@synthesize devParams;

- (void)dealloc
{
    [devParams release];
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (BOOL)isEqual:(id)object
{
    BOOL retVal = [super isEqual:object];
    
    DeviceInfo* other = [object isKindOfClass:[DeviceInfo class]] ? (DeviceInfo*)object : nil;
    if ( other )
    {
        retVal = (sensorType == other.sensorType && [devParams isEqual:other.devParams]);
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (NSUInteger)hash
{
    return [devParams hash];
}


@end




@interface DeviceDiscoveryVC (_PRIVATE_)

- (void)connectDevice:(DeviceInfo*)deviceInfo;
- (void)onBTLEEnabled;
- (void)onDeviceDiscovered:(NSArray*)userInfo;
- (BOOL)sensorTypeRequiresBonding:(WFSensorType_t)eSensorType;
- (void)startDiscovery;

@end


@implementation DeviceDiscoveryVC

@synthesize sensorType;

@synthesize sensorTypeLabel;
@synthesize networksLabel;
@synthesize discoveredTable;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [sensorTypeLabel release];
    [networksLabel release];
    [discoveredTable release];
    [selectedDevice release];
    
    [super dealloc];
}

//--------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        sensorType = WF_SENSORTYPE_NONE;
        discoveredSensors = [[NSMutableArray arrayWithCapacity:10] retain];
        ucDiscoveryCount = 0;
        state = DISCOVERY_VIEW_STATE_IDLE;
    }
    
    return self;
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
    
    self.navigationItem.title = @"Discovery";
    hardwareConnector = [WFHardwareConnector sharedConnector];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    sensorTypeLabel.text = (sensorType==WF_SENSORTYPE_NONE) ? @"Wildcard Discovery" : [WFSensorCommonViewController stringFromSensorType:sensorType];
    
    // register for HW connector notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceDiscovered:) name:WF_NOTIFICATION_DISCOVERED_SENSOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBTLEEnabled) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    
    // reset the discovered device table.
    [discoveredSensors removeAllObjects];
    [discoveredTable reloadData];

    // ensure that the BTLE controller is in normal mode.
    // (see note in the sensorTypeRequiresBonding: method).
    //
    if ( [hardwareConnector enableBTLE:TRUE inBondingMode:FALSE] )
    {
        state = DISCOVERY_VIEW_STATE_INIT;
    }
    {
        state = DISCOVERY_VIEW_STATE_IDLE;
        [self startDiscovery];
    }
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//--------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UITableViewDelegate Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    DeviceInfo* devInfo = (DeviceInfo*)[discoveredSensors objectAtIndex:indexPath.row];
    WFDeviceParams* devParams = devInfo.devParams;
    NSString* network = nil;
    if ( devParams.networkType == WF_NETWORKTYPE_BTLE )
    {
        cell.textLabel.text = [NSString stringWithFormat:@"ID:  %@", [WFSensorCommonViewController formatUUIDString:devParams.deviceUUIDString]];
        network = @"BTLE";
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"ID:  %u", devParams.deviceNumber];
        network = @"ANT+";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", network, [WFSensorCommonViewController stringFromSensorType:devInfo.sensorType]];
    
    return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the info for the selected device.
    [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
    DeviceInfo* devInfo = (DeviceInfo*)[discoveredSensors objectAtIndex:indexPath.row];

    // check whether the device type is one which requires bonding.
    BOOL bBonding = [self sensorTypeRequiresBonding:devInfo.sensorType];
    if ( bBonding )
    {
        // check whether the device has already been paired.
        WFConnectionParams* params = [hardwareConnector.settings connectionParamsForSensorType:devInfo.sensorType];
        bBonding = ![params hasDeviceUUID:devInfo.devParams.deviceUUIDString];
    }
    
    // if the device requires bonding, switch the API
    // BTLE controller to BONDING mode (see the note
    // in the sensorTypeRequiresBonding: method)
    if ( bBonding )
    {
        // cache the device info.
        [selectedDevice release];
        selectedDevice = [devInfo retain];

        // switch to bonding mode - the connection will be started
        // when the mode switch is complete (onBTLEEnabled).
        state = DISCOVERY_VIEW_STATE_CONNECT;
        [hardwareConnector enableBTLE:TRUE inBondingMode:TRUE];
    }
    else
    {
        state = DISCOVERY_VIEW_STATE_IDLE;
        [self connectDevice:devInfo];
    }
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [discoveredSensors count];
}


#pragma mark -
#pragma mark DeviceDiscoveryVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)connectDevice:(DeviceInfo*)deviceInfo
{
    // cancel any discovery in progress.
    //
    // cancel notifications for device discovery.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //
    // cancel discovery.
    [hardwareConnector cancelDiscoveryOnNetwork:WF_NETWORKTYPE_ANTPLUS];
    [hardwareConnector cancelDiscoveryOnNetwork:WF_NETWORKTYPE_BTLE];
    
    // determine the type of view to show.
    WFSensorCommonViewController* vc = nil;
    switch ( deviceInfo.sensorType )
    {
        case WF_SENSORTYPE_BIKE_CADENCE:
            vc = [[BikeCadenceViewController alloc] initWithNibName:@"BikeCadenceViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_BIKE_POWER:
            vc = [[BikePowerViewController alloc] initWithNibName:@"BikePowerViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_BIKE_SPEED:
            vc = [[BikeSpeedViewController alloc] initWithNibName:@"BikeSpeedViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_FOOTPOD:
            vc = [[FootpodViewController alloc] initWithNibName:@"FootpodViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_WEIGHT_SCALE:
            vc = [[WeightScaleViewController alloc] initWithNibName:@"WeightScaleViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_GLUCOSE:
            vc = [[GlucoseVC alloc] initWithNibName:@"GlucoseVC" bundle:nil];
            break;

        case WF_SENSORTYPE_BIKE_SPEED_CADENCE:
            vc = [[BikeSpeedCadenceViewController alloc] initWithNibName:@"BikeSpeedCadenceViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_HEARTRATE:
            vc = [[HeartrateViewController alloc] initWithNibName:@"HeartrateViewController" bundle:nil];
            break;

        case WF_SENSORTYPE_PROXIMITY:
            vc = [[ProximityViewController alloc] initWithNibName:@"ProximityViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_HEALTH_THERMOMETER:
            vc = [[TemperatureViewController alloc] initWithNibName:@"TemperatureViewController" bundle:nil];
            break;
        case WF_SENSORTYPE_BLOOD_PRESSURE:
            vc = [[BTBloodPressureVC alloc] initWithNibName:@"BTBloodPressureVC" bundle:nil];
            break;
        case WF_SENSORTYPE_BTLE_GLUCOSE:
            vc = [[BTGlucoseVC alloc] initWithNibName:@"BTGlucoseVC" bundle:nil];
            break;
    }
    
    // initiate the connection.
    if ( vc )
    {
        [vc requestConnectionToDevice:deviceInfo.devParams];
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    else
    {
        // alert the user that VC for the device is not available.
        NSString* msg = @"There is currently no view controller for the specified device.";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connect Device" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        alert = nil;
    }
}

//--------------------------------------------------------------------------------
- (void)onBTLEEnabled
{
    // determine whether BTLE is enabled.
    if ( [hardwareConnector currentState] & WF_HWCONN_STATE_BT40_ENABLED )
    {
        switch (state)
        {
            case DISCOVERY_VIEW_STATE_INIT:
                
                // if in INIT state, the view has just appeared - start discovery.
                [self startDiscovery];
                break;
                
            case DISCOVERY_VIEW_STATE_CONNECT:
                
                // if in CONNECT state, this was a device which required
                // bonding, and the mode has been switched - start connection.
                [self connectDevice:selectedDevice];
                [selectedDevice release];
                selectedDevice = nil;
                break;
        }
        state = DISCOVERY_VIEW_STATE_IDLE;
    }
}

//--------------------------------------------------------------------------------
- (void)onDeviceDiscovered:(NSNotification*)notification
{
    NSLog(@"Discovered Device");
    
    NSDictionary* info = notification.userInfo;
    if ( info && [info count] == 2 )
    {
        // parse the user info.
        NSSet* devices = (NSSet*)[info objectForKey:@"connectionParams"];
        BOOL bCompleted = [(NSNumber*)[info objectForKey:@"searchCompleted"] boolValue];
        
        // if the search is completed, reload the table.
        if ( bCompleted )
        {
            @synchronized (discoveredSensors)
            {
                // create a set with all discovered devices.
                NSMutableSet* allDevices = [NSMutableSet setWithCapacity:[discoveredSensors count]+[devices count]];
                //
                // add new discovered devices.
                for ( WFConnectionParams* connParams in devices )
                {
                    // create a device info instance and add to the set.
                    DeviceInfo* devInfo = [[DeviceInfo alloc] init];
                    devInfo.sensorType = connParams.sensorType;
                    devInfo.devParams = connParams.device1;
                    [allDevices addObject:devInfo];
                    [devInfo release];
                    devInfo = nil;
                }
                //
                // add already discovered devices.
                [allDevices addObjectsFromArray:discoveredSensors];
                
                // reload the array with the completed search.
                [discoveredSensors removeAllObjects];
                [discoveredSensors addObjectsFromArray:[allDevices allObjects]];
                [discoveredTable reloadData];
            }
        }
        
        // otherwise, add incrementally to the table view.
        else
        {
            for ( WFConnectionParams* connParams in devices )
            {
                // create a device infor instance and add to the array.
                DeviceInfo* devInfo = [[DeviceInfo alloc] init];
                devInfo.sensorType = connParams.sensorType;
                devInfo.devParams = connParams.device1;
                [discoveredSensors addObject:devInfo];
                [devInfo release];
                devInfo = nil;
            }
            
            // reload the display table.
            [discoveredTable reloadData];
        }
        
        // if the search is done, alert the user.
        if ( bCompleted && ucDiscoveryCount )
        {
            ucDiscoveryCount--;
        }
        if ( ucDiscoveryCount == 0 )
        {
            // alert the user.
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Device Discovery"
                                                            message:[NSString stringWithFormat:@"Device discovery finished.  %u devices found", [discoveredSensors count]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            alert = nil;
            
            // cancel notifications for device discovery.
            [[NSNotificationCenter defaultCenter] removeObserver:self name:WF_NOTIFICATION_DISCOVERED_SENSOR object:nil];
        }
    }
}

//--------------------------------------------------------------------------------
- (BOOL)sensorTypeRequiresBonding:(WFSensorType_t)eSensorType
{
    // as of iOS 5.1, there is a bug in CoreBluetooth affecting devices which
    // require bonding.  in normal operation, the Wahoo API will run CB on
    // an alternate dispatch queue.  this is the default state, and allows
    // simultaneous connections with multiple BTLE devices.  however, when
    // a device requires bonding, CB prompts the user with an alert initiated
    // on the alternate dispatch, rather than the main run loop.  this causes
    // the UI to freeze.  to work around this issue, the WF API allows the
    // developer to set the BTLE controller to "bonding" mode.  in this mode,
    // the bonding prompt is dispatched on the main run loop, so that the
    // UI performs as expected.  THIS MODE SHOULD ONLY BE USED WHEN IT IS
    // NECESSARY TO BOND A DEVICE WHICH HAS NOT YET BEEN BONDED.  using this
    // mode for normal operation may lead to unstable behavior.

    BOOL retVal = FALSE;
    
    // these devices are known to require bonding.
    //
    // bonding is optional on some profiles (such as heart rate).
    // add the sensor type to this switch if necessary.
    switch ( eSensorType )
    {
        case WF_SENSORTYPE_PROXIMITY:
        //case WF_SENSORTYPE_BLOOD_PRESSURE:
        case WF_SENSORTYPE_BTLE_GLUCOSE:
            retVal = TRUE;
            break;
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (void)startDiscovery
{
    // determine the search timeout period.
    NSTimeInterval timeout = hardwareConnector.settings.discoveryTimeout;
    
    // initiate the search.
    BOOL bBT = FALSE;
    BOOL bANT = FALSE;
    ucDiscoveryCount = 0;
    //
    // initiate ANT+ discovery.
    if ( [hardwareConnector discoverDevicesOfType:sensorType onNetwork:WF_NETWORKTYPE_ANTPLUS searchTimeout:timeout] )
    {
        ucDiscoveryCount++;
        bANT = TRUE;
    }
    //
    // initiate BTLE discovery.
    if ( [hardwareConnector discoverDevicesOfType:sensorType onNetwork:WF_NETWORKTYPE_BTLE searchTimeout:timeout] )
    {
        ucDiscoveryCount++;
        bBT = TRUE;
    }
    
    // update the networks searched label.
    if ( bANT && bBT )
    {
        networksLabel.text = @"ANT+ and BTLE";
    }
    else if ( bANT )
    {
        networksLabel.text = @"ANT+";
    }
    else if ( bBT )
    {
        networksLabel.text = @"BTLE";
    }
    else
    {
        // DISCOVERY INITIATION FAILED.
        //
        // this is usually because connections exist on the network.
        //
        networksLabel.text = @"DISCOVERY FAILED";
        //
        // alert the user.
        NSString* msg = @"Failed to initiate device discovery.  Please close any existing connections and try again.";
        //
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Device Discovery" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        alert = nil;
    }
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
