//
//  WFCommonData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

#define WF_COMMON_BATTERY_INVALID      -1.0

/**
 * Describes the status of the battery in the ANT sensor.
 */
typedef enum
{
	/** No battery status information is available. */
	WF_BATTERY_STATUS_NOT_AVAILABLE  = 0,
	/** The battery is in new condition. */
	WF_BATTERY_STATUS_NEW            = 1,
	/** The battery is in good condition. */
	WF_BATTERY_STATUS_GOOD           = 2,
	/** The battery in in acceptable condition. */
	WF_BATTERY_STATUS_OK             = 3,
	/** The battery is in low condition. */
	WF_BATTERY_STATUS_LOW            = 4,
	/** The battery is in critical condition. */
	WF_BATTERY_STATUS_CRITICAL       = 5,
	
} WFBatteryStatus_t;



/**
 * Represents the metadata for the sensor, available from most ANT+ sensors.
 */
@interface WFCommonData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	UCHAR  hardwareVersion;
	USHORT  manufacturerId;
	USHORT modelNumber;
	
	UCHAR  softwareVersion;
	USHORT serialNumberLower;
	USHORT serialNumberUpper;
	
	ULONG operatingTime;
	float batteryVoltage;
	WFBatteryStatus_t batteryStatus;
	
	/** \endcond */
}

/**
 * Th cummulative operating time of the sensor since the last battery
 * replacement.
 *
 * Increments every 2 seconds and is reset on battery replacement.
 */
@property (nonatomic, assign) ULONG operatingTime;
/**
 * The ID number of the device manufacturer.
 */
@property (nonatomic, assign) USHORT  manufacturerId;
/**
 * The device model number.
 */
@property (nonatomic, assign) USHORT modelNumber;
/**
 * The manufacturer specified device hardware version.
 */
@property (nonatomic, assign) UCHAR  hardwareVersion;
/**
 * The manufacturer specified device software version.
 */
@property (nonatomic, assign) UCHAR  softwareVersion;
/**
 * The the lower 16 bits of a 32 bit device serial number.
 *
 * The device serial number is typically composed of a 16-bit manufacturer
 * defined serial number seed (upper two bytes), and the 16-bit device
 * number (lower two bytes).  this property provides a convenient access
 * to the lower 16-bits of the serial number.
 */
@property (nonatomic, assign) USHORT serialNumberLower;
/**
 * The the upper 16 bits of a 32 bit device serial number.
 *
 * The device serial number is typically composed of a 16-bit manufacturer
 * defined serial number seed (upper two bytes), and the 16-bit device
 * number (lower two bytes).  this property provides a convenient access
 * to the upper 16-bits of the serial number.
 */
@property (nonatomic, assign) USHORT serialNumberUpper;
/**
 * The the full 32 bit device serial number.
 */
@property (nonatomic, readonly) ULONG serialNumber;
/**
 * The current battery voltage.
 *
 * @note This property is not available for all sensors.  A value of
 * <c>WF_COMMON_BATTERY_INVALID</c> indicates invalid, or unavailable data.
 */
@property (nonatomic, assign) float batteryVoltage;
/**
 * The current battery status.
 */
@property (nonatomic, assign) WFBatteryStatus_t batteryStatus;

@end
