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
//  BTDeviceInfoVC.m
//  WahooDemo
//
//  Created by Michael Moore on 2/28/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import "BTDeviceInfoVC.h"


@interface BTDeviceInfoVC (_PRIVATE_)

- (NSString*)stringFromBattPresent:(WFBTLEBattStatePresent_t)battState;
- (NSString*)stringFromBattDischarging:(WFBTLEBattStateDischarging_t)battState;
- (NSString*)stringFromBattCharging:(WFBTLEBattStateCharging_t)battState;
- (NSString*)stringFromBattCritical:(WFBTLEBattStateCritical_t)battState;

@end



@implementation BTDeviceInfoVC

@synthesize commonData;
@synthesize sensorConnection;

@synthesize deviceNameLabel;
@synthesize manufacturerNameLabel;
@synthesize modelNumberLabel;
@synthesize serialNumberLabel;
@synthesize hardwareRevLabel;
@synthesize firmwareRevLabel;
@synthesize softwareRevLabel;
@synthesize systemIdLabel;
@synthesize battLevelLabel;
@synthesize battPresentLabel;
@synthesize battDischargeLabel;
@synthesize battChargeLabel;
@synthesize battCriticalLabel;


#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [commonData release];
    [sensorConnection release];
    
    [deviceNameLabel release];
    [manufacturerNameLabel release];
    [modelNumberLabel release];
    [serialNumberLabel release];
    [hardwareRevLabel release];
    [firmwareRevLabel release];
    [softwareRevLabel release];
    [systemIdLabel release];
    [battLevelLabel release];
    [battPresentLabel release];
    [battDischargeLabel release];
    [battChargeLabel release];
    [battCriticalLabel release];
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Device Info";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//--------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // update the display data.
    [self updateDisplay];
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
    self.sensorConnection = nil;
}

//--------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark BTDeviceInfoVC Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (NSString*)stringFromBattPresent:(WFBTLEBattStatePresent_t)battState
{
    NSString* retVal = @"N/A";
    switch ( battState )
    {
        case WF_BTLE_BATT_STATE_PRESENT_UNKNOWN:
            retVal = @"Unknown";
            break;
        case WF_BTLE_BATT_STATE_PRESENT_NOT_SUPPORTED:
            retVal = @"Not Supported";
            break;
        case WF_BTLE_BATT_STATE_PRESENT_NOT_PRESENT:
            retVal = @"Not Present";
            break;
        case WF_BTLE_BATT_STATE_PRESENT_PRESENT:
            retVal = @"Present";
            break;
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)stringFromBattDischarging:(WFBTLEBattStateDischarging_t)battState
{
    NSString* retVal = @"N/A";
    switch ( battState )
    {
        case WF_BTLE_BATT_STATE_DISCHARGING_UNKNOWN:
            retVal = @"Unknown";
            break;
        case WF_BTLE_BATT_STATE_DISCHARGING_NOT_SUPPORTED:
            retVal = @"Not Supported";
            break;
        case WF_BTLE_BATT_STATE_DISCHARGING_NOT_DISCHARGING:
            retVal = @"Not Discharging";
            break;
        case WF_BTLE_BATT_STATE_DISCHARGING_DISCHARGING:
            retVal = @"Discharging";
            break;
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)stringFromBattCharging:(WFBTLEBattStateCharging_t)battState
{
    NSString* retVal = @"N/A";
    switch ( battState )
    {
        case WF_BTLE_BATT_STATE_CHARGING_UNKNOWN:
            retVal = @"Unknown";
            break;
        case WF_BTLE_BATT_STATE_CHARGING_NOT_CHARGEABLE:
            retVal = @"Not Chargeable";
            break;
        case WF_BTLE_BATT_STATE_CHARGING_NOT_CHARGING:
            retVal = @"Not Charging";
            break;
        case WF_BTLE_BATT_STATE_CHARGING_CHARGING:
            retVal = @"Charging";
            break;
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)stringFromBattCritical:(WFBTLEBattStateCritical_t)battState
{
    NSString* retVal = @"N/A";
    switch ( battState )
    {
        case WF_BTLE_BATT_STATE_CRITICAL_UNKNOWN:
            retVal = @"Unknown";
            break;
        case WF_BTLE_BATT_STATE_CRITICAL_NOT_SUPPORTED:
            retVal = @"Not Supported";
            break;
        case WF_BTLE_BATT_STATE_CRITICAL_GOOD_LEVEL:
            retVal = @"Good Level";
            break;
        case WF_BTLE_BATT_STATE_CRITICAL_CRITICALLY_LOW_LEVEL:
            retVal = @"Critically Low";
            break;
    }
    
    return retVal;
}


#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)updateDisplay
{
    // update the display data.
    deviceNameLabel.text = (commonData.deviceName) ? commonData.deviceName : @"n/a";
    manufacturerNameLabel.text = (commonData.manufacturerName) ? commonData.manufacturerName : @"n/a";
    modelNumberLabel.text = (commonData.modelNumber) ? commonData.modelNumber : @"n/a";
    serialNumberLabel.text = (commonData.serialNumber) ? commonData.serialNumber : @"n/a";
    hardwareRevLabel.text = (commonData.hardwareRevision) ? commonData.hardwareRevision : @"n/a";
    firmwareRevLabel.text = (commonData.firmwareRevision) ? commonData.firmwareRevision : @"n/a";
    softwareRevLabel.text = (commonData.softwareRevision) ? commonData.softwareRevision : @"n/a";
    systemIdLabel.text = [NSString stringWithFormat:@"%llu", commonData.systemId];
    
    battLevelLabel.text = (commonData.batteryLevel==WF_BTLE_BATT_LEVEL_INVALID) ? @"n/a" : [NSString stringWithFormat:@"%u %%", commonData.batteryLevel];
    battPresentLabel.text = [self stringFromBattPresent:commonData.batteryPowerState.batteryPresent];
    battDischargeLabel.text = [self stringFromBattDischarging:commonData.batteryPowerState.batteryDischarging];
    battChargeLabel.text = [self stringFromBattCharging:commonData.batteryPowerState.batteryCharging];
    battCriticalLabel.text = [self stringFromBattCritical:commonData.batteryPowerState.batteryCritical];
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------

@end
