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
//  FitFileTableView.m
//  NordicSemiDemo
//
//  Created by Michael Moore on 6/15/10.
//

#import "FitFileTableView.h"
#import "WFFitDirectoryEntry.h"
#import "FitDeviceViewController.h"


@implementation FitFileTableView

@synthesize fileRecords;
@synthesize fitViewController;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[fileRecords release];
	[fitViewController release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.fileRecords = [NSMutableArray arrayWithCapacity:1];
}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma UITableViewController Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [fileRecords count];
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
	
	// get the directory entry for the cell.
    WFFitDirectoryEntry* dirEntry = (WFFitDirectoryEntry*)[fileRecords objectAtIndex:indexPath.row];
	
    // create or de-queue the reusable cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = (UIColor*)[UIColor clearColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    }
	
    // set the checkmark for selected file.
    if ( dirEntry.isSelected )
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    // set the color based on file properties.
    if ( dirEntry.fileInfo.ucGeneralFlags & FIT_PERMISSIONS_ARCHIVE )
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else if ( dirEntry.fileInfo.ucGeneralFlags & FIT_PERMISSIONS_READ )
    {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor redColor];
    }
	
	float fileSize = (float)dirEntry.fileInfo.ulFileSize / 1024.0;
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (%1.1f KB)", [dirEntry.fileInfo stringFromTimestamp], fileSize];
	
	return cell;
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//--------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the directory entry for the selected cell.
    WFFitDirectoryEntry* dirEntry = (WFFitDirectoryEntry*)[fileRecords objectAtIndex:indexPath.row];
    
    // MMOORE:  in version 2.0.2, always select a file.
    // if the file is already selected, do not de-select.
    if ( !dirEntry.isSelected )
    {
        // MMOORE:  as of version 2.0.1, only one file may
        // be selected at a time.
        if ( !dirEntry.isSelected )
        {
            // if the currently selected file is not selected,
            // clear the selection on all other files.
            for ( WFFitDirectoryEntry* file in fileRecords )
            {
                file.isSelected = FALSE;
            }
        }
        
        // set the selected property.
        dirEntry.isSelected = TRUE;
    }
    
    // update the interface.
    [self.tableView reloadData];
}


#pragma mark -
#pragma FitFileTableView Implementation

//--------------------------------------------------------------------------------
- (void)clearFileTable
{
	self.fileRecords = [NSMutableArray arrayWithCapacity:1];
}

@end
