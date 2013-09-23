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
//  ANTFSSelectVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/14/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "ANTFSSelectVC.h"
#import "BloodPressureViewController.h"
#import "WeightHistoryViewController.h"


typedef enum
{
    DEMO_OPTION_BP,
    DEMO_OPTION_WEIGHT,
    DEMO_OPTION_ROW_COUNT,
    
} DemoOptionRows;


@implementation ANTFSSelectVC


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
    
    self.navigationItem.title = @"ANT FS";
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
        case DEMO_OPTION_BP:
            cell.textLabel.text = @"Blood Pressure";
            break;
        case DEMO_OPTION_WEIGHT:
            cell.textLabel.text = @"Weight Scale History";
            break;
    }
    
    return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ( indexPath.row )
    {
        case DEMO_OPTION_BP:
        {
            BloodPressureViewController* vc = [[BloodPressureViewController alloc] initWithNibName:@"BloodPressureViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:TRUE];
            [vc release];
            break;
        }
        case DEMO_OPTION_WEIGHT:
        {
            WeightHistoryViewController* vc = [[WeightHistoryViewController alloc] initWithNibName:@"WeightHistoryViewController" bundle:nil];
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
