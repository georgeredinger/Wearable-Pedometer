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
//  SensorManagerViewController.m
//  FisicaDemo
//
//  Created by Michael Moore on 11/30/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "SensorManagerViewController.h"
#import "NordicSemiAppDelegate.h"
#import "NordicNavigationBar.h"
#import <WFConnector/WFConnector.h>
#import "WFSensorCommonViewController.h"


@interface SensorManagerViewController (_PRIVATE_)

@property (nonatomic, readonly) WFNetworkType_t networkType;


- (BOOL)connectSensor:(WFDeviceParams*)devParams;
- (void)onDeviceDiscovered:(NSArray*)userInfo;
- (void)startDiscovery;
- (void)stopDiscovery:(BOOL)bReloadTable;

@end


@implementation SensorManagerViewController

@synthesize delegate;
@synthesize pairedTable;
@synthesize networkSegment;
@synthesize sensorTypeLabel;
@synthesize discoveredTable;
@synthesize searchButton;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [pairedTable release];
    [networkSegment release];
    [sensorTypeLabel release];
    [discoveredTable release];
    [searchButton release];
    
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
        isSearching = FALSE;
        usAllowedNetworks = WF_NETWORKTYPE_ANTPLUS | WF_NETWORKTYPE_BTLE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the title view to the Instagram logo
    UIImage* titleImage = [UIImage imageNamed:@"NORDIC-LOGO.png"];
    UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [titleView addSubview:titleImageView];
    titleImageView.center = titleView.center;
    CGRect titleImageViewFrame = titleImageView.frame;
    // Offset the logo up a bit
    // titleImageViewFrame.origin.y = titleImageViewFrame.origin.y + 3.0;
    titleImageView.frame = titleImageViewFrame;
    self.navigationItem.titleView = titleView;
    [titleImageView release];
    [titleView release];
    
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"NordicNavbarWhite.png"]];
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"BACK.png"] highlight:[UIImage imageNamed:@"BACK-down.png"]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    // configure the network type segment control.
    [networkSegment setFrame:CGRectMake(112, 204, 99, 37)];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [networkSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidLoad];
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    sensorTypeLabel.text = [WFSensorCommonViewController stringFromSensorType:sensorType];
    
    // determine the network types to search.
    BOOL bAnt = (usAllowedNetworks & (WF_NETWORKTYPE_ANTPLUS | WF_NETWORKTYPE_SUUNTO)) ? TRUE : FALSE;
    BOOL bBtle = (usAllowedNetworks & WF_NETWORKTYPE_BTLE) ? TRUE : FALSE;
    //
    // allow both networks.
    if ( bAnt && bBtle )
    {
        networkSegment.selectedSegmentIndex = 0;
        networkSegment.enabled = TRUE;
    }
    // BTLE only.
    else if ( bBtle )
    {
        networkSegment.selectedSegmentIndex = 1;
        networkSegment.enabled = FALSE;
    }
    // ANT+ only.
    else
    {
        networkSegment.selectedSegmentIndex = 0;
        networkSegment.enabled = FALSE;
    }
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    delegate = nil;
}


#pragma mark -
#pragma mark UITableViewDelegate Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;   
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == pairedTable )
    {
        return [deviceParams count];
    }
    else
    {
        return [discoveredSensors count];
    }
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the default cell has not been created, create it now.
	static NSString* cellId = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId] autorelease];
    }
	
    // determine which table this cell is for.
    //
    // check for the paired device table.
    if ( tableView == pairedTable )
    {
        // configure the display cell.
        WFDeviceParams* devParams = (WFDeviceParams*)[deviceParams objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"ID: %@", (devParams.networkType==WF_NETWORKTYPE_BTLE)?[WFSensorCommonViewController formatUUID:devParams.deviceUUIDString] : devParams.deviceIDString];
        
        
        if(devParams.networkType==WF_NETWORKTYPE_BTLE)
        {
            cell.detailTextLabel.text = @"BTLE";
        } 
        else if(devParams.networkType==WF_NETWORKTYPE_SUUNTO)
        {
            cell.detailTextLabel.text = @"SUUNTO ANT";
        }
        else if (devParams.networkType==WF_NETWORKTYPE_ANTPLUS)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"ANT+ TransmissionType: %u", devParams.transmissionType];
        }
    }
    //
    // if not the paired device table, assume the discovered device table.
    else
    {
        // Configure the cell.
        WFDeviceParams* devParams = (WFDeviceParams*)[discoveredSensors objectAtIndex:indexPath.row];
        if ( devParams.networkType == WF_NETWORKTYPE_BTLE )
        {
            cell.textLabel.text = [WFSensorCommonViewController formatUUID:devParams.deviceUUIDString];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Device ID:  %u", devParams.deviceNumber];
        }
    }
	
    return cell;
}

//--------------------------------------------------------------------------------
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	
    // determine which table is to be configured.
    //
    // check for the paired device table.
    if ( tableView == pairedTable )
    {
        // if there are any stored device params, allow delete.
        if ([deviceParams count] > 0)
        {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    //
    // if not the paired device table, assume the discovered device table.
    else
	{
        // use default editing style.
    }
    
    return style;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // determine which table is to be configured.
    //
    // check for the paired device table.
    if ( tableView == pairedTable )
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            // get the device params for the selected cell.
            WFDeviceParams* dp = (WFDeviceParams*)[deviceParams objectAtIndex:indexPath.row];
            
            // delete the params from the settings.
            WFConnectorSettings* settings = [WFHardwareConnector sharedConnector].settings;
            if ( [settings removeDeviceParams:dp forSensorType:sensorType] )
            {
                // reload the dev params from the settings.
                [deviceParams release];
                deviceParams = [[settings deviceParamsForSensorType:sensorType] retain];
                
                // delete the display cell.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
            }
        }
        else
        {
            // deselect the row
            [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
        }
    }
    //
    // if not the paired device table, assume the discovered device table.
    else
	{
        // no editing in discovered table.
    }
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFDeviceParams* devParams = nil;
    
    // determine which table is to be configured.
    //
    // check for the paired device table.
    if ( tableView == pairedTable )
    {
        // get the device params for the selected cell.
        devParams = (WFDeviceParams*)[deviceParams objectAtIndex:indexPath.row];
    }
    //
    // if not the paired device table, assume the discovered device table.
    else
    {
        // get the selected device params.
        devParams = (WFDeviceParams*)[discoveredSensors objectAtIndex:indexPath.row];
    }
    
    // deselect the row.
    [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
    
    // if device params are valid, connect the device.
    if ( devParams )
    {
        // connect to the selected sensor.
        [self connectSensor:devParams];
    }
}


#pragma mark -
#pragma mark SensorManagerViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFNetworkType_t)networkType
{
    return (networkSegment.selectedSegmentIndex == 1) ? WF_NETWORKTYPE_BTLE : WF_NETWORKTYPE_ANTPLUS;
}

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (BOOL)connectSensor:(WFDeviceParams*)devParams
{
    BOOL retVal = FALSE;
    
    // cancel any discovery in progress.
    if ( isSearching )
    {
        [self stopDiscovery:FALSE];
    }
    
    // ensure valid delegate and params instances.
    if ( devParams && delegate )
    {
        // request connection via delegate.
        [delegate requestConnectionToDevice:devParams];
        
        // clear the delegate reference and close the view.
        delegate = nil;
        [self.navigationController popViewControllerAnimated:TRUE];
        retVal = TRUE;
    }
    
    return retVal;
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
        
        // ensure the correct sensor type.
        // if the search is completed, reload all devices to the table.
        if ( bCompleted )
        {
            // reload the array with the completed search.
            [discoveredSensors removeAllObjects];
        }
        
        // add discovered devices.
        for ( WFConnectionParams* connParams in devices )
        {
            if ( connParams.sensorType == sensorType )
            {
                [discoveredSensors addObject:connParams.device1];
            }
        }
        
        // reload the table.
        [discoveredTable reloadData];
        
        // if the search is done, alert the user.
        if ( bCompleted )
        {
            // reset the search state.
            [self resetSearchState];
            
            // alert the user.
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Device Discovery"
                                                            message:[NSString stringWithFormat:@"Device discovery finished.  %u devices found", [devices count]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            alert = nil;
        }
    }
}

//--------------------------------------------------------------------------------
- (void)resetSearchState
{
    // cancel notifications for device discovery.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // reset the search UI.
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    networkSegment.enabled = TRUE;
    isSearching = FALSE;
}

//--------------------------------------------------------------------------------
- (void)startDiscovery
{
    // initiate device discovery.
    //
    
    isSearching = TRUE;
    networkSegment.enabled = FALSE;
    
    // set the search button title.
    [searchButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    // remove existing search results.
    [discoveredSensors removeAllObjects];
    [discoveredTable reloadData];
    
    // determine the search timeout period.
    NSTimeInterval timeout = [WFHardwareConnector sharedConnector].settings.discoveryTimeout;
    
    // initiate the search.
    if ( [[WFHardwareConnector sharedConnector] discoverDevicesOfType:sensorType onNetwork:self.networkType searchTimeout:timeout] )
    {
        // register for HW connector notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceDiscovered:) name:WF_NOTIFICATION_DISCOVERED_SENSOR object:nil];
    }
    else
    {
        // DISCOVERY FAILED TO INITIALIZE.
        //
        // this typically happens because there are existing connections.
        //
        // reset search state.
        [self resetSearchState];
        
        // alert the user.
        NSString* netType = (self.networkType==WF_NETWORKTYPE_BTLE)?@"BTLE":@"ANT+";
        NSString* msg = [NSString stringWithFormat:@"Failed to initiate device discovery.  Please close any existing %@ connections and try again.", netType];
        //
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Device Discovery" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        alert = nil;
    }
}

//--------------------------------------------------------------------------------
- (void)stopDiscovery:(BOOL)bReloadTable
{
    // cancel the discovery in progress.
    //
    
    // reset the search state.
    [self resetSearchState];
    
    // cancel the discovery.
    NSSet* sensors = [[WFHardwareConnector sharedConnector] cancelDiscoveryOnNetwork:self.networkType];
    
    // reload the array with the completed search.
    if ( bReloadTable )
    {
        [discoveredSensors removeAllObjects];
        [discoveredSensors addObjectsFromArray:[sensors allObjects]];
        [discoveredTable reloadData];
    }
}

#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)configForSensorType:(WFSensorType_t)eSensorType onNetworks:(USHORT)usNetworks
{
	sensorType = eSensorType;
	[deviceParams release];
	deviceParams = [[[WFHardwareConnector sharedConnector].settings deviceParamsForSensorType:sensorType] retain];
    isSearching = FALSE;
    usAllowedNetworks = usNetworks;
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)searchClicked:(id)sender
{
    // check whether discovery is currently in progress.
    if ( isSearching )
    {
        // cancel the discovery in progress.
        [self stopDiscovery:TRUE];
    }
    
    else
    {
        // initiate device discovery.
        [self startDiscovery];
    }
}

@end

