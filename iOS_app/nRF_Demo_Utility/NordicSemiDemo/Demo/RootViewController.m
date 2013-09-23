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
//  RootViewController.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 9/1/11.
//

#import "RootViewController.h"
#import "NordicSemiAppDelegate.h"
#import "AntSensorsViewController.h"
#import "BTLESensorsViewController.h"
#import "AntViewController.h"
#import "DTCustomColoredAccessory.h"
#import "NordicNavigationBar.h"


typedef enum
{
    DEMO_OPTION_ANT_SENSORS,
    DEMO_OPTION_BT_SENSORS,
    DEMO_OPTION_NORDIC_WEBSITE,
    DEMO_OPTION_NORDIC_EMAIL,
    DEMO_OPTION_ROW_COUNT
    
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
    // Get our custom nav bar
    NordicNavigationBar* customNavigationBar = (NordicNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"NordicNavbar.png"]];
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
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:0 green:141.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cell.textLabel.textColor];
        cell.accessoryView = accessory;
    }

    // Configure the cell.
    switch ( indexPath.row )
    {
        case DEMO_OPTION_ANT_SENSORS:
            cell.textLabel.text = @"ANT+";
            break;
        case DEMO_OPTION_BT_SENSORS:
            cell.textLabel.text = @"Bluetooth Smart";
            break;
        case DEMO_OPTION_NORDIC_WEBSITE:
            cell.textLabel.text = @"www.nordicsemi.com";
            break;
        case DEMO_OPTION_NORDIC_EMAIL:
            cell.textLabel.text = @"Contact us";
            break;
    }
    
    return cell;
}


//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFHardwareConnector* hardwareConnector = [WFHardwareConnector sharedConnector];
    NordicSemiAppDelegate * appDelegate = (NordicSemiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch ( indexPath.row )
    {
        case DEMO_OPTION_ANT_SENSORS:
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
        /*    OverviewViewController* vc = [[OverviewViewController alloc] initWithNibName:@"OverviewViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release]; */
            AntSensorsViewController* vc = [[AntSensorsViewController alloc] initWithNibName:@"AntSensorsViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            [appDelegate animateRootBg:YES];
            break;
        }
        case DEMO_OPTION_BT_SENSORS:
        {
            // reset the ANT chip and HW connector.
            [hardwareConnector resetConnections];
            
            // the AntViewController will initialize advanced mode
            // in the viewDidLoad method.
            //
            // display the Advanced ANT view.
            BTLESensorsViewController* vc = [[BTLESensorsViewController alloc] initWithNibName:@"BTLESensorsViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            [appDelegate animateRootBg:YES];
            break;
        }
        case DEMO_OPTION_NORDIC_WEBSITE:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.nordicsemi.com"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (![[UIApplication sharedApplication] openURL:url])
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            break;
        }
            
        case DEMO_OPTION_NORDIC_EMAIL:
        {
            NSURL *url = [NSURL URLWithString:@"mailto:info@nordicsemi.no?subject=nRF%20Demo"]; 
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (![[UIApplication sharedApplication] openURL:url])
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            
            break;
        }
    }
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DEMO_OPTION_ROW_COUNT;
}

//--------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 205.0;
}

@end
