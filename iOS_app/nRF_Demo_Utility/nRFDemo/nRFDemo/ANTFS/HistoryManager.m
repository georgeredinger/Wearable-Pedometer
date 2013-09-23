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
//  HistoryManager.m
//  FisicaUtility
//
//  Created by Michael Moore on 6/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "HistoryManager.h"


@implementation HistoryManager


#pragma mark -
#pragma mark HistoryManager Implementation

//--------------------------------------------------------------------------------
- (NSString*)getLastEmail
{
	// check the date of the latest record.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
	NSString* retVal = (NSString*)[sensorInfo objectForKey:@"LastEmailUsed"];
	
	// DEBUG:  support empty email case.
	if (!retVal) retVal = @"";
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSDate*)getLastRefresh:(WFAntFSDeviceType_t)deviceType
{
	// check the date of the latest record.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
	NSString* key = [self historyKeyForDeviceType:deviceType];
	NSMutableArray* records = (NSMutableArray*)[sensorInfo objectForKey:key];
	
	NSDate* retVal;
	if ( [records count] > 0 )
	{
		NSMutableDictionary* rec = (NSMutableDictionary*)[records objectAtIndex:0];
		retVal = (NSDate*)[rec objectForKey:@"timestamp"];
	}
	else
	{
		retVal = [NSDate distantPast];;
	}
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)getPasskey:(WFAntFSDeviceType_t)deviceType
{
	// check the date of the latest record.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
	NSMutableDictionary* devPw = (NSMutableDictionary*)[sensorInfo objectForKey:@"DevicePasswords"];
	NSString* key;
	switch (deviceType)
	{
		case WF_ANTFS_DEVTYPE_WEIGHT_SCALE:
			key = @"WeightScale";
			break;
		case WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF:
			key = @"BloodPressure";
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR310:
			key = @"Garmin FR310";
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR405:
			key = @"Garmin FR405";
			break;
		case WF_ANTFS_DEVTYPE_GENERIC_FIT:
			key = @"Generic FIT";
			break;
	}
	
	NSString* retVal = (NSString*)[devPw objectForKey:key];
	
	// support empty PW case.
	if (!retVal) retVal = @"00,00,00,00";
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSMutableDictionary*)getSensorInfo
{
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
	NSMutableDictionary* retVal = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSString*)historyKeyForDeviceType:(WFAntFSDeviceType_t)deviceType
{
	NSString* retVal;
	switch (deviceType)
	{
		case WF_ANTFS_DEVTYPE_WEIGHT_SCALE:
			retVal = @"WeightHistory";
			break;
		case WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF:
			retVal = @"BloodPressureHistory";
			break;
		default:
			retVal = nil;
			break;
	}
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSArray*)loadHistory:(WFAntFSDeviceType_t)deviceType
{
	// load the sensor-info plist to a dictionary instance.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
	
	// get the history array.
	NSString* key = [self historyKeyForDeviceType:deviceType];
	NSArray* records = (NSArray*)[sensorInfo objectForKey:key];
	
	// read the entries into the return array.
	NSMutableArray* retVal = [NSMutableArray arrayWithCapacity:[records count]];
	for (int i=0; i<[records count]; i++)
	{
		// get the dictionary entry for the current record.
		NSDictionary* rec = (NSDictionary*)[records objectAtIndex:i];
		
		// parse the record based on device type.
		switch (deviceType)
		{
			case WF_ANTFS_DEVTYPE_WEIGHT_SCALE:
			{
				// create a WFFitMessageWeightScale based on the dictionary.
                FIT_WEIGHT_SCALE_MESG stMesg;
                memset( &stMesg, 0, sizeof(FIT_WEIGHT_SCALE_MESG) );
                stMesg.timestamp = [WFFitParser getTimestampFromDate:(NSDate*)[rec objectForKey:@"timestamp"]];
                stMesg.weight = [(NSNumber*)[rec objectForKey:@"weight"] doubleValue] * 100.0;
				WFFitMessageWeightScale* wsRec = [[WFFitMessageWeightScale alloc] initWithRecord:&stMesg];
				
				// add the record to the return array.
				[retVal addObject:wsRec];
				[wsRec release];
				break;
			}
			case WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF:
			{
				// create a WFFitMessageBloodPressure based on the dictionary.
                FIT_BLOOD_PRESSURE_MESG stMesg;
                memset( &stMesg, 0, sizeof(FIT_BLOOD_PRESSURE_MESG) );
                stMesg.timestamp = [WFFitParser getTimestampFromDate:(NSDate*)[rec objectForKey:@"timestamp"]];
                stMesg.systolic_pressure = [(NSNumber*)[rec objectForKey:@"systolicPressure"] unsignedShortValue];
                stMesg.diastolic_pressure = [(NSNumber*)[rec objectForKey:@"diastolicPressure"] unsignedShortValue];
                stMesg.heart_rate = [(NSNumber*)[rec objectForKey:@"heartRate"] unsignedShortValue];
				WFFitMessageBloodPressure* wsRec = [[WFFitMessageBloodPressure alloc] initWithRecord:&stMesg];
				
				// add the record to the return array.
				[retVal addObject:wsRec];
				[wsRec release];
				break;
			}
		}
	}
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (void)saveHistory:(WFAntFSDeviceType_t)deviceType fitRecords:(NSArray*)fitRecords
{
	// check the date of the latest record.
	NSDate* latestDate = [self getLastRefresh:deviceType];
	NSString* key = [self historyKeyForDeviceType:deviceType];
	
	// build an array of dictionary instances based
	// on the records in the array.
	NSMutableArray* records = [NSMutableArray arrayWithCapacity:[fitRecords count]];
	for (int i=[fitRecords count]-1; i>=0; i--)
	{
		// parse the records based on the device type.
		switch (deviceType)
		{
			case WF_ANTFS_DEVTYPE_WEIGHT_SCALE:
			{
                // ensure this is a FIT weight record.
                if ( [[fitRecords objectAtIndex:i] isKindOfClass:[WFFitMessageWeightScale class]] )
                {
                    // read the record into a dictionary instance.
                    WFFitMessageWeightScale* wfRec = (WFFitMessageWeightScale*)[fitRecords objectAtIndex:i];
                    NSLog(@"WEIGHT:  %1.2f kg", wfRec.weight);
                    
                    // check the timestamp.
                    if ( [wfRec.timestamp compare:latestDate] == NSOrderedDescending )
                    {
                        // build the dictionary object.
                        NSMutableDictionary* rec = [NSMutableDictionary dictionaryWithCapacity:2];
                        [rec setObject:wfRec.timestamp forKey:@"timestamp"];
                        [rec setObject:[NSNumber numberWithDouble:wfRec.weight] forKey:@"weight"];
                        
                        // add to the array to be saved.
                        [records addObject:rec];
                    }
                }
				break;
			}
			case WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF:
			{
                // ensure this is a FIT BP record.
                if ( [[fitRecords objectAtIndex:i] isKindOfClass:[WFFitMessageBloodPressure class]] )
                {
                    // read the record into a dictionary instance.
                    WFFitMessageBloodPressure* bpRec = (WFFitMessageBloodPressure*)[fitRecords objectAtIndex:i];
                    
                    // check the timestamp.
                    if ( [bpRec.timestamp compare:latestDate] == NSOrderedDescending )
                    {
                        // build the dictionary object.
                        NSMutableDictionary* rec = [NSMutableDictionary dictionaryWithCapacity:4];
                        [rec setObject:bpRec.timestamp forKey:@"timestamp"];
                        [rec setObject:[NSNumber numberWithUnsignedShort:bpRec.systolicPressure] forKey:@"systolicPressure"];
                        [rec setObject:[NSNumber numberWithUnsignedShort:bpRec.diastolicPressure] forKey:@"diastolicPressure"];
                        [rec setObject:[NSNumber numberWithUnsignedShort:bpRec.heartRate] forKey:@"heartRate"];
                        
                        // add to the array to be saved.
                        [records addObject:rec];
                    }
                }
				break;
			}
		}
	}
	
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
	NSMutableDictionary* sensorInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	
	// update the dictionary and save to disk.
	NSMutableArray* previousRecords = (NSMutableArray*)[sensorInfo objectForKey:key];
	[records addObjectsFromArray:previousRecords];
	
	[sensorInfo setObject:records forKey:key];
	[sensorInfo writeToFile:filePath atomically:YES];
	[sensorInfo release];
}

//--------------------------------------------------------------------------------
- (void)saveLastEmail:(NSString*)emailAddress
{
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
	NSMutableDictionary* sensorInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	
	// set the email address.
	[sensorInfo setObject:emailAddress forKey:@"LastEmailUsed"];
	
	// update the dictionary and save to disk.
	[sensorInfo writeToFile:filePath atomically:YES];
	[sensorInfo release];
}

//--------------------------------------------------------------------------------
- (void)savePasskey:(WFAntFSDeviceType_t)deviceType passkey:(NSString*)passkey
{
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
	NSMutableDictionary* sensorInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	NSMutableDictionary* devPw = (NSMutableDictionary*)[sensorInfo objectForKey:@"DevicePasswords"];
	
	// set the device passkey.
	NSString* key;
	switch (deviceType)
	{
		case WF_ANTFS_DEVTYPE_WEIGHT_SCALE:
			key = @"WeightScale";
			break;
		case WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF:
			key = @"BloodPressure";
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR310:
			key = @"Garmin FR310";
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR405:
			key = @"Garmin FR405";
			break;
		case WF_ANTFS_DEVTYPE_GENERIC_FIT:
			key = @"Generic FIT";
			break;
	}
	[devPw setObject:passkey forKey:key];
	
	// update the dictionary and save to disk.
	[sensorInfo writeToFile:filePath atomically:YES];
	[sensorInfo release];
}

@end
