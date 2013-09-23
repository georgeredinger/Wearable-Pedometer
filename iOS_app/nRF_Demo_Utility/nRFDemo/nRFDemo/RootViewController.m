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
//  RootViewController.m
//  WahooDemo
//
//  Created by Michael Moore on 9/1/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import "RootViewController.h"
#import "ANTOverviewVC.h"
#import "ANTBTOverviewVC.h"
#import "BTOverviewVC.h"
#import "AntViewController.h"
#import "SettingsViewController.h"
#import "ANTFSSelectVC.h"


typedef enum
{
    DEMO_OPTION_SETTINGS,
    DEMO_OPTION_ANT,
    DEMO_OPTION_UNIVERSAL,
    DEMO_OPTION_BTSMART,
    DEMO_OPTION_ANTFS,
    DEMO_OPTION_ADVANCED,
    DEMO_OPTION_ROW_COUNT,
    
} DemoOptionRows;


@implementation RootViewController


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Implementation

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
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell.
    switch ( indexPath.row )
    {
        case DEMO_OPTION_SETTINGS:
            cell.textLabel.text = @"Settings";
            break;
        case DEMO_OPTION_ANT:
            cell.textLabel.text = @"ANT+ Demo";
            break;
        case DEMO_OPTION_UNIVERSAL:
            cell.textLabel.text = @"ANT+ or BT Smart Demo";
            break;
        case DEMO_OPTION_BTSMART:
            cell.textLabel.text = @"BT Smart Demo";
            break;
        case DEMO_OPTION_ANTFS:
            cell.textLabel.text = @"ANT FS Demo";
            break;
        case DEMO_OPTION_ADVANCED:
            cell.textLabel.text = @"Advanced Mode Demo";
            break;
    }
    
    return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFHardwareConnector* hardwareConnector = [WFHardwareConnector sharedConnector];
    
    switch ( indexPath.row )
    {
        case DEMO_OPTION_SETTINGS:
        {
            SettingsViewController* vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
        case DEMO_OPTION_ANT:
        {
            // disable the Advanced mode.
            //
            // in typical applications, this will not be necessary.  applications
            // will usually operate either in standard mode or Advanced mode
            // exclusively.  switching modes is used in this application to
            // demonstrate both modes of operation.
            //
            // to disable the Advanced mode, pass nil to initializeAdvancedMode.
            [hardwareConnector initializeAdvancedMode:nil];
            //
            // reset the ANT chip and HW connector.
            [hardwareConnector resetConnections];
            
            // display the sensor overview view.
            ANTOverviewVC* vc = [[ANTOverviewVC alloc] initWithNibName:@"ANTOverviewVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
        case DEMO_OPTION_UNIVERSAL:
        {
            // disable the Advanced mode.
            //
            // in typical applications, this will not be necessary.  applications
            // will usually operate either in standard mode or Advanced mode
            // exclusively.  switching modes is used in this application to
            // demonstrate both modes of operation.
            //
            // to disable the Advanced mode, pass nil to initializeAdvancedMode.
            [hardwareConnector initializeAdvancedMode:nil];
            //
            // reset the ANT chip and HW connector.
            [hardwareConnector resetConnections];
            
            // display the sensor overview view.
            ANTBTOverviewVC* vc = [[ANTBTOverviewVC alloc] initWithNibName:@"ANTBTOverviewVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
        case DEMO_OPTION_BTSMART:
        {
            // to disable the Advanced mode, pass nil to initializeAdvancedMode.
            [hardwareConnector initializeAdvancedMode:nil];
            //
            // reset the ANT chip and HW connector.
            [hardwareConnector resetConnections];
            
            // display the sensor overview view.
            BTOverviewVC* vc = [[BTOverviewVC alloc] initWithNibName:@"BTOverviewVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
        case DEMO_OPTION_ANTFS:
        {
            // disable the Advanced mode.
            //
            // in typical applications, this will not be necessary.  applications
            // will usually operate either in standard mode or Advanced mode
            // exclusively.  switching modes is used in this application to
            // demonstrate both modes of operation.
            //
            // to disable the Advanced mode, pass nil to initializeAdvancedMode.
            [hardwareConnector initializeAdvancedMode:nil];
            //
            // reset the ANT chip and HW connector.
            [hardwareConnector resetConnections];
            
            // display the sensor overview view.
            ANTFSSelectVC* vc = [[ANTFSSelectVC alloc] initWithNibName:@"ANTFSSelectVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
        case DEMO_OPTION_ADVANCED:
        {
            // reset the ANT chip and HW connector.
            [hardwareConnector resetConnections];
            
            // the AntViewController will initialize advanced mode
            // in the viewDidLoad method.
            //
            // display the Advanced ANT view.
            AntViewController* vc = [[AntViewController alloc] initWithNibName:@"AntViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
    }
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DEMO_OPTION_ROW_COUNT;
}

@end
