/*
 *  hardware_connector_types.h
 *  WFConnector
 *
 *  Created by Michael Moore on 2/12/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#ifndef __HARDWARE_CONNECTOR_TYPES_H__
#define __HARDWARE_CONNECTOR_TYPES_H__

#include <WFConnector/common_types.h>
#ifdef WF_PRIVATE_BUILD
#include <WFConnector/hardware_connector_types_private.h>
#endif


#define DEVICE_INPUT_BUFFER_SIZE            128
#define WF_SENSOR_DEFAULT_SAMPLE_RATE       0.5
#define WF_MAX_SENSOR_CONNECTIONS           4


#ifndef _WF_HARDWARE_CONNECTOR_STATE_T_
#define _WF_HARDWARE_CONNECTOR_STATE_T_
/** Describes the state of the WFHardwareConnector. */
typedef enum
{
	/** The fisica device is not physically connected to the iPod. */
	WF_HWCONN_STATE_NOT_CONNECTED                = 0,
	/** The fisica device is physically connected to the iPod. */
	WF_HWCONN_STATE_CONNECTED                    = 0x01,
	/** The fisica device is connected and communication is established (norml operating mode). */
	WF_HWCONN_STATE_ACTIVE                       = 0x02,
	/** The fisica device is performing a reset operation. */
	WF_HWCONN_STATE_RESET                        = 0x04,
    /** The BTLE hardware is enabled. */
    WF_HWCONN_STATE_BT40_ENABLED                 = 0x08,
    /** The BTLE controller is in bonding mode. */
    WF_HWCONN_STATE_BT_BONDING_MODE              = 0x10,
	
} WFHardwareConnectorState_t;
#endif  // WF_HARDWARE_CONNECTOR_STATE_T


#ifndef _WF_SENSOR_TYPE_T_
#define _WF_SENSOR_TYPE_T_
/**
 * Describes a type of hardware sensor device.
 */
typedef enum
{
	/** Specifies non-existent sensor. */
	WF_SENSORTYPE_NONE                           = 0,
	/** Specifies the bike power sensor. */
	WF_SENSORTYPE_BIKE_POWER                     = 0x00000001,
	/** Specifies the bike speed sensor. */
	WF_SENSORTYPE_BIKE_SPEED                     = 0x00000002,
	/** Specifies the bike cadence sensor. */
	WF_SENSORTYPE_BIKE_CADENCE                   = 0x00000004,
	/** Specifies the combined bike speed and cadence sensor. */
	WF_SENSORTYPE_BIKE_SPEED_CADENCE             = 0x00000008,
	/** Specifies the FootPod stride and distance sensor. */
	WF_SENSORTYPE_FOOTPOD                        = 0x00000010,
	/** Specifies the heart rate monitor sensor. */
	WF_SENSORTYPE_HEARTRATE                      = 0x00000020,
	/** Specifies the Weight Scale monitor sensor */
	WF_SENSORTYPE_WEIGHT_SCALE                   = 0x00000040,
	/** Specifies a generic ANT FS device. */
	WF_SENSORTYPE_ANT_FS                         = 0x00000080,
	/** Specifies the GPS location sensor. */
	WF_SENSORTYPE_LOCATION                       = 0x00000100,
	/** Specifies the calorimeter sensor. */
	WF_SENSORTYPE_CALORIMETER                    = 0x00000200,
	/** Specifies the GeoCache sensor. */
	WF_SENSORTYPE_GEO_CACHE                      = 0x00000400,
	/** Specifies the Fitness Equipment sensor. */
	WF_SENSORTYPE_FITNESS_EQUIPMENT              = 0x00000800,
    /** Specifies the Multi-Sport Speed and Distance sensor. */
    WF_SENSORTYPE_MULTISPORT_SPEED_DISTANCE      = 0x00001000,
    /** Specifies the BTLE Proximity sensor. */
    WF_SENSORTYPE_PROXIMITY                      = 0x00002000,
    /** Specifies the BTLE Health Thermometer sensor. */
    WF_SENSORTYPE_HEALTH_THERMOMETER             = 0x00004000,
    /** Specifies the BTLE Blood Pressure sensor. */
    WF_SENSORTYPE_BLOOD_PRESSURE                 = 0x00008000,
    /** Specifies the BTLE Blood Glucose Monitor sensor. */
    WF_SENSORTYPE_BTLE_GLUCOSE                   = 0x00010000,
    /** Specifies the ANT+ Blood Glucose Monitor sensor. */
    WF_SENSORTYPE_GLUCOSE                        = 0x00020000,

	
} WFSensorType_t;
#endif  // _WF_SENSOR_TYPE_T_

#ifndef _WF_NETWORK_TYPE_T_
#define _WF_NETWORK_TYPE_T_
/**
 * Describes a type of hardware sensor device.
 */
typedef enum
{
    /**
     * The network type is not specified.
     *
     * This value may not be used for connection requests.  If used, the connection
     * request will fail.
     */
    WF_NETWORKTYPE_UNSPECIFIED                      = 0,
	/** Default, ANT+ standard network */
	WF_NETWORKTYPE_ANTPLUS                          = 0x01,
	/** Specifies BTLE devices */
	WF_NETWORKTYPE_BTLE                             = 0x02,
	/** Specifies Suunto devices */
	WF_NETWORKTYPE_SUUNTO                           = 0x04,
    
    /**
     * Wildcard for any available network.
     *
     * This value may be specified in connection request.  When used, connection
     * attempt is made on any available network.  The first connection to be
     * established will be used.  Connection requests on other network types
     * will be cancelled.
     */
    WF_NETWORKTYPE_ANY                              = WF_NETWORKTYPE_ANTPLUS | WF_NETWORKTYPE_SUUNTO | WF_NETWORKTYPE_BTLE,
    
} WFNetworkType_t;
#endif  // _WF_NETWORK_TYPE_T_



#ifndef _WF_FITNESS_EQUIPMENT_TYPE_T_
#define _WF_FITNESS_EQUIPMENT_TYPE_T_
/** Describes the type of Fitness Equipment machine. */
typedef enum
{
	/** No FE type specified. */
	WF_FETYPE_NONE                                = 0,
	/** Non-specific FE machine - should broadcast basic FE data. */
	WF_FETYPE_GENERAL                             = 16,
	/** Specifies the treadmill. */
	WF_FETYPE_TREADMILL                           = 19,
	/** Specifies the elliptical trainer. */
	WF_FETYPE_ELLIPTICAL                          = 20,
	/** Specifies the stationary bike. */
	WF_FETYPE_BIKE                                = 21,
	/** Specifies the rower. */
	WF_FETYPE_ROWER                               = 22,
	/** Specifies the climber. */
	WF_FETYPE_CLIMBER                             = 23,
	
} WFFitnessEquipmentType_t;
#endif  // _WF_FITNESS_EQUIPMENT_TYPE_T_

#ifndef _WF_FITNESS_EQUIPMENT_STATE_T_
#define _WF_FITNESS_EQUIPMENT_STATE_T_
/** Describes the state of a Fitness Equipment machine. */
typedef enum
{
	/** The FE machine is off. */
	WF_FE_STATE_ASLEEP                            = 1,
	/** The FE machine is on, awaiting connection. */
	WF_FE_STATE_READY                             = 2,
	/** The FE machine is in use, workout in progreas. */
	WF_FE_STATE_IN_USE                            = 3,
	/**
	 The workout is paused or finished.
	 
	 If the next state is WF_FE_STATE_IN_USE, interpret as paused, if
	 the next state is WF_FE_STATE_READY, interpret as finished.
	 */
	WF_FE_STATE_FINISHED                          = 4,
	
} WFFitnessEquipmentState_t;
#endif  // _WF_FITNESS_EQUIPMENT_STATE_T_

#ifndef _WF_FITNESS_EQUIPMENT_HR_SOURCE_T_
#define _WF_FITNESS_EQUIPMENT_HR_SOURCE_T_
/** Describes the source of the HRM data in the Fitness Equipment message. */
typedef enum
{
	/** No HRM available - do not interpret HRM data. */
	WF_FE_HR_SOURCE_INVALID                       = 0,
	/** HRM data from an ANT+ HRM sensor. */
	WF_FE_HR_SOURCE_ANTPLUS                       = 1,
	/** HRM data from an EM (5kHz) heart rate monitor. */
	WF_FE_HR_SOURCE_EM                            = 2,
	/** HRM data from hand contact sensor on the Fitness Equipment. */
	WF_FE_HR_SOURCE_FE                            = 3,
	
} WFFitnessEquipmentHRSource_t;
#endif  // _WF_FITNESS_EQUIPMENT_HR_SOURCE_T_

#ifndef _WF_SENSOR_CONNECTION_STATUS_T_
#define _WF_SENSOR_CONNECTION_STATUS_T_
/** Describes the connection state of an ANT sensor. */
typedef enum
{
    /** No active connection. */
	WF_SENSOR_CONNECTION_STATUS_IDLE,
    /** The connection is in process of being established. */
	WF_SENSOR_CONNECTION_STATUS_CONNECTING,
    /** The sensor connection is established and active. */
	WF_SENSOR_CONNECTION_STATUS_CONNECTED,
    /** The connection was interrupted (usually occurs when fisica is disconnected). */
    WF_SENSOR_CONNECTION_STATUS_INTERRUPTED,
    /** The connection is in process of being disconnected. */
	WF_SENSOR_CONNECTION_STATUS_DISCONNECTING,
	
} WFSensorConnectionStatus_t;
#endif  // _WF_SENSOR_CONNECTION_STATUS_T_


#pragma mark -
#pragma mark Bike Power Sensor Types
/////////////////////////////////////////////////////////////////////////////
// Bike Power Sensor Types.
/////////////////////////////////////////////////////////////////////////////

#ifndef _WF_BIKE_POWER_TYPE_T_
#define _WF_BIKE_POWER_TYPE_T_
/** Describes the type of Bike Power Meter. */
typedef enum
{
	/** Indicates that the power meter type has not been determined. */
	WF_BIKE_POWER_TYPE_UNIDENTIFIED,
	/** Indicates the Power Only power meter type. */
	WF_BIKE_POWER_TYPE_POWER_ONLY,
	/** Indicates the Crank Torque power meter type. */
	WF_BIKE_POWER_TYPE_CRANK_TORQUE,
	/** Indicates the Wheel Torque power meter type. */
	WF_BIKE_POWER_TYPE_WHEEL_TORQUE,
	/** Indicates the Crank Torque Frequency power meter type. */
	WF_BIKE_POWER_TYPE_CTF,
	
} WFBikePowerType_t;
#endif  // _WF_BIKE_POWER_TYPE_T_


#ifndef _WF_BIKE_POWER_CALIBRATION_DATA_T_
#define _WF_BIKE_POWER_CALIBRATION_DATA_T_
/**
 * Describes calibration information for a Bike Power sensor.
 */
typedef struct
{
	/** Specifies the type of calibration data. */
	UCHAR calibrationId;
	/** varies depending on the calibration ID. */
	UCHAR reserved1;
	/** varies depending on the calibration ID. */
	UCHAR reserved2;
	/** varies depending on the calibration ID. */
	UCHAR reserved3;
	/** varies depending on the calibration ID. */
	UCHAR reserved4;
	/** varies depending on the calibration ID. */
	UCHAR reserved5;
	/** varies depending on the calibration ID. */
	UCHAR reserved6;
	
} WFBikePowerCalibrationData_t;
#endif  // _WF_BIKE_POWER_CALIBRATION_DATA_T_

#define WF_BPS_CALIBRATION_ID_GENERAL_SUCCESS   0xAC
#define WF_BPS_CALIBRATION_ID_GENERAL_FAIL      0xAF
#define WF_BPS_CALIBRATION_ID_CAPABILITIES      0x12
#define WF_BPS_CALIBRATION_ID_CTF               0x10

#ifndef _WF_BIKE_POWER_CALIBRATION_CAPABILITIES_T_
#define _WF_BIKE_POWER_CALIBRATION_CAPABILITIES_T_
/**
 * Describes status information on auto zero functions and outputs of raw and offset
 * torque values.
 */
typedef struct
{
    /** Torque Meter Capabilities message. */
    UCHAR ucCalibrationId;
    /** Sensor Configuration Descriptive Bit Field. */
    UCHAR ucConfigurationBitField;
    /** Raw torque (lower byte of 16-bit signed value). */
    UCHAR ucRawTorqueLSB;
    /** Raw torque (upper byte of 16-bit signed value). */
    UCHAR ucRawTorqueMSB;
    /** Offset torque (lower byte of 16-bit signed value). */
    UCHAR ucOffsetTorqueLSB;
    /** Offset torque (upper byte of 16-bit signed value). */
    UCHAR ucOffsetTorqueMSB;
    /** Reserved for future use. */
    UCHAR ucReserved6;
    
} WFBikePowerCalibrationCapabilities_t;
#endif  // _WF_BIKE_POWER_CALIBRATION_CAPABILITIES_T_

#ifndef _WF_BIKE_POWER_CALIBRATION_GENERAL_T_
#define _WF_BIKE_POWER_CALIBRATION_GENERAL_T_
/** Describes the general calibration response for the Bike Power meter. */
typedef struct
{
    /** Calibration ID.
     *
     * 0xAC (Calibration Response Successful)<br />
     * 0xAF (Calibration Response Failed)
     */
    UCHAR ucCalibrationId;
    /**
     * Auto-zero status.
     *
     * 0x00 – Auto Zero Is OFF<br />
     * 0x01 – Auto Zero Is ON<br />
     * 0xFF – Auto Zero Is Not Supported
     */
    UCHAR ucAutoZeroStatus;
    /** Reserved for future use. */
    UCHAR ucReserved2;
    /** Reserved for future use. */
    UCHAR ucReserved3;
    /** Reserved for future use. */
    UCHAR ucReserved4;
    /** Calibration data (lower byte of 16-bit signed value). */
    UCHAR ucCalibrationDataLSB;
    /** Calibration data (upper byte of 16-bit signed value). */
    UCHAR ucCalibrationDataMSB;
    
} WFBikePowerCalibrationGeneral_t;
#endif  // _WF_BIKE_POWER_CALIBRATION_GENERAL_T_

#ifndef _WF_BIKE_POWER_CALIBRATION_CTF_T_
#define _WF_BIKE_POWER_CALIBRATION_CTF_T_
/** Describes the calibration response specific to the CTF type Bike Power meter. */
typedef struct
{
    /** CTF defined message. */
    UCHAR ucCalibrationId;
    /** CTF Defined ID. */
    UCHAR ucCTFID;
    /** Reserved for future use. */
    UCHAR ucReserved2;
    /** Reserved for future use. */
    UCHAR ucReserved3;
    /** Reserved for future use. */
    UCHAR ucReserved4;
    /** Offset (lower byte of 16-bit unsigned value). */
    UCHAR ucOffsetLSB;
    /** Offset (upper byte of 16-bit unsigned value). */
    UCHAR ucOffsetMSB;
    
} WFBikePowerCalibrationCTF_t;
#endif  // _WF_BIKE_POWER_CALIBRATION_CTF_T_

#pragma mark -
#pragma mark Calorimeter Sensor Types
/////////////////////////////////////////////////////////////////////////////
// Calorimeter Sensor Types.
/////////////////////////////////////////////////////////////////////////////

#ifndef _WF_CAL_CONFIDENCE_T_
#define _WF_CAL_CONFIDENCE_T_
/** Describes the confidence in the accuracy of a calorimeter measurement. */
typedef enum
{
	/** Indicates a low confidence in the accuracy of the measurement. */
	WF_CAL_CONFIDENCE_LOW,
	/** Indicates a reasonable confidence in the accuracy of the measurement. */
	WF_CAL_CONFIDENCE_MODERATE,
	/** Indicates a high confidence in the accuracy of the measurement. */
	WF_CAL_CONFIDENCE_HIGH,
	/** Indicates an error. */
	WF_CAL_CONFIDENCE_ERROR,
	
} WFCalConfidence_t;
#endif  // _WF_CAL_CONFIDENCE_T_


#pragma mark -
#pragma mark Weight Scale Sensor Types
/////////////////////////////////////////////////////////////////////////////
// Weight Scale Sensor Types.
/////////////////////////////////////////////////////////////////////////////

/** Weight Scale User Profile - Female User */
#define WF_WSS_GENDER_FEMALE                ((UCHAR) 0)
/** Weight Scale User Profile - Male User */
#define WF_WSS_GENDER_MALE                  ((UCHAR) 1)

/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_SEDENTARY     ((UCHAR) 0)
/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_LIGHT_20      ((UCHAR) 1)
/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_LIGHT_40      ((UCHAR) 2)
/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_LIGHT_60      ((UCHAR) 3)
/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_REGULAR_1     ((UCHAR) 4)
/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_REGULAR_5     ((UCHAR) 5)
/** Weight Scale User Profile - User's activity level. */
#define WF_WSS_ACTIVITY_LEVEL_REGULAR_9     ((UCHAR) 6)


#ifndef _WF_WEIGHT_SCALE_PROFILE_T_
#define _WF_WEIGHT_SCALE_PROFILE_T_
/**
 * Describes user profile data for the weight scale.
 */
typedef struct
{
	/** User profile ID number. */
	USHORT userProfileId;
	/** User's gender. */
	UCHAR  gender;
	/** User's age. */
	UCHAR  age;
	/** User's height (in cm). */
	UCHAR  height;
	/** <c>TRUE</c> if user is an athelete. */
	BOOL   athelete;
	/** User's activity level */
	UCHAR  activityLevel;
	
} WFWeightScaleUserProfile_t;
#endif  // _WF_WEIGHT_SCALE_PROFILE_T_

#pragma mark -
#pragma mark GeoCache Sensor Types
/////////////////////////////////////////////////////////////////////////////
// GeoCache Sensor Types.
/////////////////////////////////////////////////////////////////////////////

#ifndef _WF_GEO_CACHE_PROGRAM_STATUS_T_
#define _WF_GEO_CACHE_PROGRAM_STATUS_T_
/** Describes the status of a request to program the GeoCache device. */
typedef enum
{
	/** The programming request was initialized successfully. */
	WF_GEO_CACHE_PROGRAM_OK,
	/** The PIN was not specified (PIN must be non-zero). */
	WF_GEO_CACHE_PROGRAM_PIN_NOT_SET,
	/** The specified PIN does not match the PIN on the device. */
	WF_GEO_CACHE_PROGRAM_PIN_MISMATCH,
	/** A communication error occured while initiating the programming request. */
	WF_GEO_CACHE_PROGRAM_COMM_ERROR,
	/**
	 * The GeoCache sensor is in the wrong state for programming.
	 * 
	 * The sensor is likely either not connected, or not authenticated.
	 */
	WF_GEO_CACHE_PROGRAM_WRONG_STATE,
	
} WFGeoCacheProgramStatus_t;
#endif  // _WF_GEO_CACHE_PROGRAM_STATUS_T_

#ifndef _WF_GPS_FIX_TYPE_T_
#define _WF_GPS_FIX_TYPE_T_
/** Describes the type and quality of the GPS fix. */
typedef enum
{
    /** No fix. Position data is not accurate. */
    WF_GPS_FIX_TYPE_NONE,
    /** The GPS receiver is searching for satellites. */
    WF_GPS_FIX_TYPE_SEARCHING,
    /**
     * The GPS receiver had a fix, but is currently without a fix. The position
     * data is calculated based on changes from a last known fix.
     */
    WF_GPS_FIX_TYPE_PROPAGATING,
    /**
     * The GPS receiver had a fix, but is currently without a fix. The position
     * data has not been updated since the last known position.
     */
    WF_GPS_FIX_TYPE_LAST_KNOWN_POSITION,
    /** A position has been obtained that is accurate in 2 dimensions (horizontal only). */
    WF_GPS_FIX_TYPE_2D,
    /**
     * A 2D position has been obtained and is using WAAS corrections for better
     * positional accuracy.
     */
    WF_GPS_FIX_TYPE_2D_WAAS,
    /**
     * A 2D position has been obtained and is using differential corrections for
     * better positional accuracy.
     */
    WF_GPS_FIX_TYPE_2D_DIFFERENTIAL,
    /**
     * A position has been obtained that is accurate in 3 dimensions (vertical
     * and horizontal).
     */
    WF_GPS_FIX_TYPE_3D,
    /**
     * A 3D position has been obtained and is using WAAS corrections for better
     * positional accuracy.
     */
    WF_GPS_FIX_TYPE_3D_WAAS,
    /**
     * A 3D position has been obtained and is using differential correct ions
     * for better positional accuracy.
     */
    WF_GPS_FIX_TYPE_3D_DIFFERENTIAL,
    
} WFGPSFixType_t;
#endif  // _WF_GPS_FIX_TYPE_T_

#ifndef _WF_PROXIMITY_RANGE_T_
#define _WF_PROXIMITY_RANGE_T_
/** Describes the proximity range for pairing ANT devices. */
typedef enum
{
    /** Proximity searching is disabled. */
    WF_PROXIMITY_RANGE_DISABLED,
    /** Proximity range 1 of 10 (closest range). */
    WF_PROXIMITY_RANGE_1,
    /** Proximity range 2 of 10. */
    WF_PROXIMITY_RANGE_2,
    /** Proximity range 3 of 10. */
    WF_PROXIMITY_RANGE_3,
    /** Proximity range 4 of 10. */
    WF_PROXIMITY_RANGE_4,
    /** Proximity range 5 of 10. */
    WF_PROXIMITY_RANGE_5,
    /** Proximity range 6 of 10. */
    WF_PROXIMITY_RANGE_6,
    /** Proximity range 7 of 10. */
    WF_PROXIMITY_RANGE_7,
    /** Proximity range 8 of 10. */
    WF_PROXIMITY_RANGE_8,
    /** Proximity range 9 of 10. */
    WF_PROXIMITY_RANGE_9,
    /** Proximity range 10 of 10 (farthest range). */
    WF_PROXIMITY_RANGE_10,
    
} WFProximityRange_t;
#endif  // _WF_PROXIMITY_RANGE_T_

#pragma mark -
#pragma mark BTLE Characteristic Value Definitions
/////////////////////////////////////////////////////////////////////////////
// BTLE Characteristic Value Definitions.
/////////////////////////////////////////////////////////////////////////////

#ifndef _WF_BTLE_CH_ALERT_LEVEL_T_
#define _WF_BTLE_CH_ALERT_LEVEL_T_
/** Describes the alert level for the BTLE Alert Level characteristic. */
typedef enum
{
    /** No Alert. */
    WF_BTLE_CH_ALERT_LEVEL_NONE     = 0,
    /** Mild Alert. */
    WF_BTLE_CH_ALERT_LEVEL_MILD     = 1,
    /** High Alert. */
    WF_BTLE_CH_ALERT_LEVEL_HIGH     = 2,
    
} WFBTLEChAlertLevel_t;
#endif  // _WF_BTLE_CH_ALERT_LEVEL_T_

#ifndef _WF_PROXIMITY_ALERT_MODE_T_
#define _WF_PROXIMITY_ALERT_MODE_T_
/** Describes the proximity alert mode. */
typedef enum
{
    /** Alert is issued as the device moves farther away. */
    WF_PROXIMITY_ALERT_MODE_FARTHER,
    /** Alert is issued as the device moves closer. */
    WF_PROXIMITY_ALERT_MODE_CLOSER,
    
} WFProximityAlertMode_t;
#endif  // _WF_PROXIMITY_ALERT_MODE_T_

#ifndef _WF_PROXIMITY_ALERT_THRESHOLD_T_
#define _WF_PROXIMITY_ALERT_THRESHOLD_T_
/**
 * Describes the threshold for proximity alert.
 *
 * The proximity connection will monitor the RSSI value for the connected
 * device.  If the signal power loss (TX Power - RSSI) crosses a specified
 * threshold, an alert is issued.
 */
typedef enum
{
    /** Proximity alert is disabled. */
    WF_PROXIMITY_ALERT_THRESHOLD_DISABLED,
    /** Proximity threshold 1 of 10 (Signal loss 35 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_1,
    /** Proximity threshold 1 of 10 (Signal loss 40 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_2,
    /** Proximity threshold 1 of 10 (Signal loss 45 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_3,
    /** Proximity threshold 1 of 10 (Signal loss 50 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_4,
    /** Proximity threshold 1 of 10 (Signal loss 55 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_5,
    /** Proximity threshold 1 of 10 (Signal loss 60 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_6,
    /** Proximity threshold 1 of 10 (Signal loss 65 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_7,
    /** Proximity threshold 1 of 10 (Signal loss 70 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_8,
    /** Proximity threshold 1 of 10 (Signal loss 75 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_9,
    /** Proximity threshold 1 of 10 (Signal loss 80 dBm). */
    WF_PROXIMITY_ALERT_THRESHOLD_10,
    
} WFProximityAlertThreshold_t;
#endif  // _WF_PROXIMITY_ALERT_THRESHOLD_T_

#ifndef _WF_BTLE_TEMPERATURE_TYPE_T_
#define _WF_BTLE_TEMPERATURE_TYPE_T_
/** Describes the type of temperature measurement. */
typedef enum
{
    /** Temperature type is not known. */
    WF_BTLE_TEMPERATURE_TYPE_UNKNOWN,
    /** Temperature measured in the armpit. */
    WF_BTLE_TEMPERATURE_TYPE_ARMPIT,
    /** Temperature measured on the body. */
    WF_BTLE_TEMPERATURE_TYPE_BODY,
    /** Temperature measured in the ear. */
    WF_BTLE_TEMPERATURE_TYPE_EAR,
    /** Temperature measured on the finger. */
    WF_BTLE_TEMPERATURE_TYPE_FINGER,
    /** Temperature measured in the GI tract. */
    WF_BTLE_TEMPERATURE_TYPE_GI_TRACT,
    /** Temperature measured in the mouth. */
    WF_BTLE_TEMPERATURE_TYPE_MOUTH,
    /** Temperature measured in the rectum. */
    WF_BTLE_TEMPERATURE_TYPE_RECTUM,
    /** Temperature measured on the toe. */
    WF_BTLE_TEMPERATURE_TYPE_TOE,
    /** Temperature measured in the tympanum. */
    WF_BTLE_TEMPERATURE_TYPE_TYMPANUM,
    
} WFBTLETemperatureType_t;
#endif  // _WF_BTLE_TEMPERATURE_TYPE_T_

#ifndef _WF_CONNECTOR_ERROR_DOMAIN_
#define _WF_CONNECTOR_ERROR_DOMAIN_
/** Error domain for the WFHardwareConnector. */
FOUNDATION_EXPORT NSString* const WFConnectorErrorDomain; 
enum
{
    /** No error has occured. */
    WFConnectionErrorNone = 0,
    /** The hardware is not ready. */
    WFConnectionErrorHardwareNotReady = 1,
    /** The fisica key is not present. */
    WFConnectionErrorKeyNotPresent = 2,
    /** BTLE is not supported on this device. */
    WFConnectionErrorBTLENotSupported = 3,
    /** The sensor type was not specified. */
    WFConnectionErrorTypeNotSpecified = 4,
    /** The connection parameters are invalid. */
    WFConnectionErrorInvalidParams = 5,
    /** A device discovery is currently in progress. */
    WFConnectionErrorDiscoveryInProgress = 6,
    
};
/** An error code for errors in the ::WFConnectorErrorDomain. */
typedef NSUInteger WFConnectorError;
#endif  // _WF_CONNECTOR_ERROR_DOMAIN_

#ifndef _WF_COMPARISON_TYPE_T_
#define _WF_COMPARISON_TYPE_T_
/** Describes a method of comparing data. */
typedef enum
{
    /** No comparison specified. */
    WF_COMPARISON_TYPE_NONE = 0,
    /** The comparison is <c>TRUE</c> if the item on the left is less than the item on the right. */
    WF_COMPARISON_TYPE_LESS_THAN,
    /** The comparison is <c>TRUE</c> if the item on the left is less than or equal to the item on the right. */
    WF_COMPARISON_TYPE_LESS_THAN_OR_EQUAL,
    /** The comparison is <c>TRUE</c> if the item on the left is equal to the item on the right. */
    WF_COMPARISON_TYPE_EQUAL,
    /** The comparison is <c>TRUE</c> if the item on the left is greater than or equal to the item on the right. */
    WF_COMPARISON_TYPE_GREATER_THAN_OR_EQUAL,
    /** The comparison is <c>TRUE</c> if the item on the left is greater than the item on the right. */
    WF_COMPARISON_TYPE_GREATER_THAN,
    
} WFComparisonType_t;
#endif // _WF_COMPARISON_TYPE_T_

#endif  // __HARDWARE_CONNECTOR_TYPES_H__
