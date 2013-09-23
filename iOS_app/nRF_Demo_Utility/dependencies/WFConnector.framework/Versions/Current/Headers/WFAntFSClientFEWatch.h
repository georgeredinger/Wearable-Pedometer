//
//  WFAntFSClientFEWatch.h
//  WFConnector
//
//  Created by Michael Moore on 12/20/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFSClientBase.h>


/**
 * Represents an ANT FS Client implementation which simulates a Fitness Equipment
 * enabled watch.
 *
 * The WFAntFSClientFEWatch will generate an ANT FS beacon which will link to
 * Fitness Equipment machines which utilize Fit1e technology.  Once linked,
 * the WFAntFSClientFEWatch will transfer any previously specified settings
 * or workout FIT files.
 */
@interface WFAntFSClientFEWatch : WFAntFSClientBase
{
}


/**
 * The ANT device ID specified in the ANT FS beacon.
 *
 * This is the device ID which the Fit1e machine will use for the Fitness
 * Equipment profile broadcast.  The application should use this device
 * ID when initializing the connection with the WFFitnessEquipmentConnection.
 */
@property (nonatomic, readonly) USHORT deviceNumber;

@end
