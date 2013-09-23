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
//  HistoryManager.m
//  FisicaUtility
//
//  Created by Michael Moore on 6/10/10.
//

#import "HistoryManager.h"
#import "BTBPRecord.h"


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
- (NSDate*)getLastRefresh:(NSString*)key
{
	// check the date of the latest record.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
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
- (BOOL)duplicateBTBP:(NSDate*)date
{
	// check the date of the latest record.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
	NSMutableArray* records = (NSMutableArray*)[sensorInfo objectForKey:@"BTBloodPressureHistory"];
	
	BOOL retVal = NO;
    NSMutableDictionary* rec;
	for (rec in records)
	{
		NSDate * aDate = (NSDate*)[rec objectForKey:@"timestamp"];
        if ([date timeIntervalSinceReferenceDate] == [aDate timeIntervalSinceReferenceDate]) {
            retVal = YES;
            break;
        }
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
        default:
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
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"sensor-info.plist"];
	NSMutableDictionary* retVal = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSMutableDictionary*)getBTBPInfo
{
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"bgbp-info.plist"];
	NSMutableDictionary* retVal = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSMutableDictionary*)getCGMInfo
{
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"cgm-settings.plist"];
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
            default:
                break;
		}
	}
	
	return retVal;
}

//--------------------------------------------------------------------------------
- (NSArray*)loadBTBPHistory
{
	// load the sensor-info plist to a dictionary instance.
	NSMutableDictionary* sensorInfo = [self getSensorInfo];
	// get the history array.
	NSString* key = @"BTBloodPressureHistory";
	NSArray* records = (NSArray*)[sensorInfo objectForKey:key];
	
	// read the entries into the return array.
	NSMutableArray* retVal = [NSMutableArray arrayWithCapacity:[records count]];
	for (int i=0; i<[records count]; i++)
	{
		// get the dictionary entry for the current record.
		NSDictionary* rec = (NSDictionary*)[records objectAtIndex:i];
		BTBPRecord * bpRec = [[BTBPRecord alloc] init];
        bpRec.timestamp = (NSDate*)[rec objectForKey:@"timestamp"];
        bpRec.systolic = [(NSNumber*)[rec objectForKey:@"systolicPressure"] floatValue];
        bpRec.diastolic = [(NSNumber*)[rec objectForKey:@"diastolicPressure"] floatValue];
        bpRec.heartRate = [(NSNumber*)[rec objectForKey:@"heartRate"] floatValue];
        [retVal addObject:bpRec];
        [bpRec release];
    }
	return retVal;
}

//--------------------------------------------------------------------------------
- (void)saveBTBPRecord:(BTBPRecord *)record
{
	NSString* key = @"BTBloodPressureHistory";
	// check the date of the latest record.
	if ([self duplicateBTBP:record.timestamp]) return;
    // load the sensor-info plist to a dictionary instance.
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"sensor-info.plist"];
    NSMutableDictionary* sensorInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
                
    // build the dictionary object.
    NSMutableDictionary* rec = [NSMutableDictionary dictionaryWithCapacity:4];
    [rec setObject:record.timestamp forKey:@"timestamp"];
    [rec setObject:[NSNumber numberWithFloat:record.systolic] forKey:@"systolicPressure"];
    [rec setObject:[NSNumber numberWithFloat:record.diastolic] forKey:@"diastolicPressure"];
    [rec setObject:[NSNumber numberWithFloat:record.heartRate] forKey:@"heartRate"];
    
    // update the dictionary and save to disk.
    NSMutableArray* records;
    if ([sensorInfo objectForKey:key] ==  nil) {
        records = [NSMutableArray arrayWithCapacity:1];
    } else {
        records = (NSMutableArray*)[sensorInfo objectForKey:key];
    }
    [records addObject:rec];
    
    [sensorInfo setObject:records forKey:key];
    [sensorInfo writeToFile:filePath atomically:YES];
  //  NSLog(@"%@", sensorInfo.description);
    [sensorInfo release];
    
}
//--------------------------------------------------------------------------------
- (void)saveHistory:(WFAntFSDeviceType_t)deviceType fitRecords:(NSArray*)fitRecords
{
	// check the date of the latest record.
	NSString* key = [self historyKeyForDeviceType:deviceType];
	NSDate* latestDate = [self getLastRefresh:key];
	
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
            default:
                break;
		}
	}
	
	// load the sensor-info plist to a dictionary instance.
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"sensor-info.plist"];
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
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"sensor-info.plist"];
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
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"sensor-info.plist"];
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
        default:
            key = @"Generic FIT";
			break;
	}
	[devPw setObject:passkey forKey:key];
	
	// update the dictionary and save to disk.
	[sensorInfo writeToFile:filePath atomically:YES];
	[sensorInfo release];
}

- (void)saveCGMInfo:(NSDictionary *)infoDict {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"cgm-settings.plist"];
	NSMutableDictionary* cgmSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSString * permKey = [infoDict objectForKey:@"permissionKey"];
    NSString * txId = [infoDict objectForKey:@"txId"];
    NSNumber * low = [infoDict objectForKey:@"low"];
    NSNumber * high = [infoDict objectForKey:@"high"];
    NSNumber * highAlert = [infoDict objectForKey:@"highAlert"];
    NSNumber * lowAlert = [infoDict objectForKey:@"lowAlert"];
    NSNumber * riseAlert = [infoDict objectForKey:@"riseAlert"];
    NSNumber * fallAlert = [infoDict objectForKey:@"fallAlert"];
    NSNumber * riseAlertLevel = [infoDict objectForKey:@"riseAlertLevel"];
    NSNumber * fallAlertLevel = [infoDict objectForKey:@"fallAlertLevel"];
    [cgmSettings setObject:permKey forKey:@"permissionKey"];
    [cgmSettings setObject:txId forKey:@"txId"];
    [cgmSettings setObject:low forKey:@"low"];
    [cgmSettings setObject:high forKey:@"high"];
    [cgmSettings setObject:riseAlert forKey:@"riseAlert"];
    [cgmSettings setObject:fallAlert forKey:@"fallAlert"];
    [cgmSettings setObject:highAlert forKey:@"highAlert"];
    [cgmSettings setObject:lowAlert forKey:@"lowAlert"];
    [cgmSettings setObject:riseAlertLevel forKey:@"riseAlertLevel"];
    [cgmSettings setObject:fallAlertLevel forKey:@"fallAlertLevel"];
    
	// update the dictionary and save to disk.
	[cgmSettings writeToFile:filePath atomically:YES];
	[cgmSettings release];
}
@end
