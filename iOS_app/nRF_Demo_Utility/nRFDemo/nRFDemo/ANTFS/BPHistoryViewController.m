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
//  BPHistoryViewController.m
//  FisicaUtility
//
//  Created by Chip on 6/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "BPHistoryViewController.h"
#import <WFConnector/WFAntFS.h>


@implementation BPHistoryViewController

@synthesize fitRecords;

#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[fitRecords release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = (UIColor*)[UIColor colorWithRed:0.5 green: 0.5 blue:0.5 alpha:1];
	self.tableView.backgroundColor = (UIColor*)[UIColor blackColor];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
#pragma mark UITableViewController Implementation

//--------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


//--------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}


//--------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//return 10;
	return [fitRecords count];
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UILabel *yearLabel, *dateLabel, *timeLabel, *bpLabel, *diaLabel, *hrLabel, *bpmLabel;
	UIImageView *blackBox;
	
	// uncomment to get real BP data!
	WFFitMessageBloodPressure* bpRec = (WFFitMessageBloodPressure*)[fitRecords objectAtIndex:indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = (UIColor*)[UIColor blackColor];
		
		//		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		blackBox = [[UIImageView alloc] initWithFrame:CGRectMake(110.0,5.0,120.0,80.0)];
		blackBox.tag = 7;
		blackBox.image = [UIImage imageNamed:@"smallBlackBox.png"]; 
		blackBox.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:blackBox];
		[blackBox release];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 100.0, 30.0)];
		dateLabel.tag = 1;
		dateLabel.font = [UIFont systemFontOfSize:20.0];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.textColor = (UIColor *)[UIColor whiteColor];
		dateLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 30.0, 100.0, 30.0)];
		yearLabel.tag = 5;
		yearLabel.font = [UIFont systemFontOfSize:20.0];
		yearLabel.textAlignment = UITextAlignmentCenter;
		yearLabel.textColor = (UIColor *)[UIColor whiteColor];
		yearLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		yearLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:yearLabel];
		[yearLabel release];
		
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 55.0, 100.0, 30.0)];
		timeLabel.tag = 4;
		timeLabel.font = [UIFont systemFontOfSize:20.0];
		timeLabel.textAlignment = UITextAlignmentCenter;
		timeLabel.textColor = (UIColor *)[UIColor whiteColor];
		timeLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		timeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:timeLabel];
		[timeLabel release];
		
		bpLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 10.0, 120.0, 35.0)];
		bpLabel.tag = 2;
		bpLabel.font = [UIFont boldSystemFontOfSize:32.0];
		
		if (bpRec.systolicPressure < 90) {
			bpLabel.textColor = (UIColor*)[UIColor blueColor];
		}
		else if (bpRec.systolicPressure < 121) {
			bpLabel.textColor = (UIColor*)[UIColor greenColor];
		}
		else if (bpRec.systolicPressure < 140) {
			bpLabel.textColor = (UIColor*)[UIColor yellowColor];
		}
		else if (bpRec.systolicPressure < 160) {
			bpLabel.textColor = (UIColor*)[UIColor orangeColor];
		}
		else {
			bpLabel.textColor = (UIColor*)[UIColor redColor];
		}
		
		bpLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		bpLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:bpLabel];
		[bpLabel release];
		
		diaLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 45.0, 120.0, 35.0)];
		diaLabel.tag = 6;
		diaLabel.font = [UIFont boldSystemFontOfSize:32.0];
		
		if (bpRec.diastolicPressure < 60) {
			diaLabel.textColor = (UIColor*)[UIColor blueColor];
		}
		else if (bpRec.diastolicPressure < 81) {
			diaLabel.textColor = (UIColor*)[UIColor greenColor];
		}
		else if (bpRec.diastolicPressure < 90) {
			diaLabel.textColor = (UIColor*)[UIColor yellowColor];
		}
		else if (bpRec.diastolicPressure < 100) {
			diaLabel.textColor = (UIColor*)[UIColor orangeColor];
		}
		else {
			diaLabel.textColor = (UIColor*)[UIColor redColor];
		}
		
		diaLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		diaLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:diaLabel];
		[diaLabel release];
		
		hrLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 5.0, 70.0, 45.0)];
		hrLabel.tag = 3;
		hrLabel.font = [UIFont systemFontOfSize:32.0];
		hrLabel.textColor = (UIColor *)[UIColor whiteColor];
		hrLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		hrLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:hrLabel];
		[hrLabel release];
		
		bpmLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 45.0, 70.0, 35.0)];
		bpmLabel.tag = 8;
		bpmLabel.font = [UIFont systemFontOfSize:24.0];
		bpmLabel.textColor = (UIColor *)[UIColor whiteColor];
		bpmLabel.backgroundColor = (UIColor *)[UIColor blackColor];
		bpmLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:bpmLabel];
		[bpmLabel release];
		
		
		//sample color for making text bold
		//cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
    }
	
	dateLabel = (UILabel *)[cell.contentView viewWithTag:1];
	bpLabel = (UILabel *)[cell.contentView viewWithTag:2];
	diaLabel = (UILabel *)[cell.contentView viewWithTag:6];
	hrLabel = (UILabel *)[cell.contentView viewWithTag:3];
	timeLabel = (UILabel *) [cell.contentView viewWithTag:4];
	yearLabel = (UILabel *) [cell.contentView viewWithTag:5];
	blackBox = (UIImageView *) [cell.contentView viewWithTag:7];
	bpmLabel = (UILabel *) [cell.contentView viewWithTag:8];
	
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@" h:mm a"];
	timeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:bpRec.timestamp]];
	[df setDateFormat:@" MMM  d"];
	dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:bpRec.timestamp]];
	[df setDateFormat:@"yyyy"];
	yearLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:bpRec.timestamp]];
	[df release];
	
	bpLabel.text = [NSString stringWithFormat:@"%d",bpRec.systolicPressure];
	diaLabel.text = [NSString stringWithFormat:@"%d",bpRec.diastolicPressure];
	
	hrLabel.text = [NSString stringWithFormat:@"%d", bpRec.heartRate];
	bpmLabel.text = @"bpm";
	
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
}

@end
