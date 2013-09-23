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
//  BPHistoryViewController.m
//  NordicSemiDemo
//
//  Created by Chip on 6/9/10.
//

#import "BPHistoryViewController.h"
#import <WFConnector/WFAntFS.h>
#import "NordicNavigationBar.h"
#import "BTBPRecord.h"


@implementation BPHistoryViewController

@synthesize fitRecords, btRecords, networkType;

#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
	[fitRecords release];
    [btRecords release];
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
	self.tableView.backgroundColor = (UIColor*)[UIColor whiteColor];
	
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
#pragma UITableViewController Implementation

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
	if (networkType == WF_NETWORKTYPE_BTLE) {
        return [btRecords count];
    }
	return [fitRecords count];
}

//--------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UILabel *yearLabel, *dateLabel, *timeLabel, *bpLabel, *diaLabel, *hrLabel, *bpmLabel;
	//UIImageView *blackBox;
	
    int systolic = 0;
    int diastolic = 0;
    int hr = 0;
    NSDate* timestamp;
    
    if (networkType == WF_NETWORKTYPE_BTLE) {
        BTBPRecord * btbpRec = (BTBPRecord*)[btRecords objectAtIndex:indexPath.row];
        timestamp = btbpRec.timestamp;
        systolic = [[NSNumber numberWithFloat:btbpRec.systolic] intValue];
        diastolic = [[NSNumber numberWithFloat:btbpRec.diastolic] intValue];
        hr = [[NSNumber numberWithFloat:btbpRec.heartRate] intValue];
    } else  {
        WFFitMessageBloodPressure* bpRec = (WFFitMessageBloodPressure*)[fitRecords objectAtIndex:indexPath.row];
        timestamp = bpRec.timestamp;
        systolic = bpRec.systolicPressure;
        diastolic = bpRec.diastolicPressure;
        hr = bpRec.heartRate;
    } 
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = (UIColor*)[UIColor blackColor];
		
		//		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
	/*	blackBox = [[UIImageView alloc] initWithFrame:CGRectMake(110.0,5.0,120.0,80.0)];
		blackBox.tag = 7;
		blackBox.image = [UIImage imageNamed:@"smallBlackBox.png"]; 
		blackBox.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:blackBox];
		[blackBox release]; */
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 100.0, 30.0)];
		dateLabel.tag = 1;
		dateLabel.font = [UIFont systemFontOfSize:20.0];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 30.0, 100.0, 30.0)];
		yearLabel.tag = 5;
		yearLabel.font = [UIFont systemFontOfSize:20.0];
		yearLabel.textAlignment = UITextAlignmentCenter;
		yearLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:yearLabel];
		[yearLabel release];
		
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 55.0, 100.0, 30.0)];
		timeLabel.tag = 4;
		timeLabel.font = [UIFont systemFontOfSize:20.0];
		timeLabel.textAlignment = UITextAlignmentCenter;
		timeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:timeLabel];
		[timeLabel release];
		
		bpLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 10.0, 120.0, 35.0)];
		bpLabel.tag = 2;
		bpLabel.font = [UIFont boldSystemFontOfSize:32.0];
		
		if (systolic < 90) {
			bpLabel.textColor = (UIColor*)[UIColor blueColor];
		}
		else if (systolic < 121) {
			bpLabel.textColor = (UIColor*)[UIColor greenColor];
		}
		else if (systolic< 140) {
			bpLabel.textColor = (UIColor*)[UIColor yellowColor];
		}
		else if (systolic < 160) {
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
		
		if (diastolic< 60) {
			diaLabel.textColor = (UIColor*)[UIColor blueColor];
		}
		else if (diastolic < 81) {
			diaLabel.textColor = (UIColor*)[UIColor greenColor];
		}
		else if (diastolic < 90) {
			diaLabel.textColor = (UIColor*)[UIColor yellowColor];
		}
		else if (diastolic < 100) {
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
		hrLabel.textColor = (UIColor *)[UIColor blackColor];
		hrLabel.backgroundColor = (UIColor *)[UIColor whiteColor];
		hrLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:hrLabel];
		[hrLabel release];
		
		bpmLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 45.0, 70.0, 35.0)];
		bpmLabel.tag = 8;
		bpmLabel.font = [UIFont systemFontOfSize:24.0];
		bpmLabel.textColor = (UIColor *)[UIColor blackColor];
		bpmLabel.backgroundColor = (UIColor *)[UIColor whiteColor];
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
//	blackBox = (UIImageView *) [cell.contentView viewWithTag:7];
	bpmLabel = (UILabel *) [cell.contentView viewWithTag:8];
	
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@" h:mm a"];
	timeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:timestamp]];
	[df setDateFormat:@" MMM  d"];
	dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:timestamp]];
	[df setDateFormat:@"yyyy"];
	yearLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:timestamp]];
	[df release];
	
	bpLabel.text = [NSString stringWithFormat:@"%d",systolic];
	diaLabel.text = [NSString stringWithFormat:@"%d",diastolic];
	
	hrLabel.text = [NSString stringWithFormat:@"%d", hr];
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
