/*
 *  wf_antfs_types.h
 *  WFConnector
 *
 *  Created by Michael Moore on 6/9/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#ifndef _WF_ANTFS_TYPES_H_
#define _WF_ANTFS_TYPES_H_

#include <WFConnector/common_types.h>


/** The maximum length for an ANT FS password. */
#define WF_ANTFS_PASSWORD_MAX_LENGTH            255

/** Identifies the ANT FS file type. */
#define ANTFS_FILE_DATA_TYPE_ANTFS              0x80
/** Identifies the FIT Activity file sub-type. */
#define ANTFS_FILE_SUB_TYPE_ACTIVITY            0x04
/** Identifies the FIT Settings file sub-type. */
#define ANTFS_FILE_SUB_TYPE_SETTINGS            0x02


#ifndef _WF_ANTFS_DEVICE_TYPE_T_
#define _WF_ANTFS_DEVICE_TYPE_T_
/** Describes a type of ANT FS enabled device. */
typedef enum
{
	/** Specifies the ANT FS enabled weight scale. */
	WF_ANTFS_DEVTYPE_WEIGHT_SCALE = 0,
	/** Specifies the ANT FS enabled blood pressure cuff. */
	WF_ANTFS_DEVTYPE_BLOOD_PRESSURE_CUFF,
	/** Specifies the A&D pedometer. */
	WF_ANTFS_DEVTYPE_AND_PEDOMETER,
	/** Specifies a generic ANT FS enabled device which uses FIT protocol. */
	WF_ANTFS_DEVTYPE_GENERIC_FIT,
    /** Specifies any supported Garmin fitness watch. */
    WF_ANTFS_DEVTYPE_GARMIN_WATCH,
	/** Specifies the Garmin Forerunner 60. */
	WF_ANTFS_DEVTYPE_GARMIN_FR60,
	/** Specifies the Garmin Forerunner 310. */
	WF_ANTFS_DEVTYPE_GARMIN_FR310,
	/** Specifies the Garmin Forerunner 405. */
	WF_ANTFS_DEVTYPE_GARMIN_FR405,
	/** Specifies the Garmin Forerunner 610. */
	WF_ANTFS_DEVTYPE_GARMIN_FR610,
	/** Specifies an ANT FS enabled watch supporting the Fitness Equipment profile. */
	WF_ANTFS_DEVTYPE_FE_WATCH,
	/** Specifies the Garmin Forerunner 910XT. */
    WF_ANTFS_DEVTYPE_GARMIN_FR910XT,
	
} WFAntFSDeviceType_t;

#endif // _WF_ANTFS_DEVICE_TYPE_T_

#ifndef _WF_ANTFS_DEVICE_MODE_T_
#define _WF_ANTFS_DEVICE_MODE_T_
/** Describes the ANT FS mode of a device. */
typedef enum
{
    /** The device is ANT FS Host mode. */
    WF_ANTFS_DEVMODE_HOST,
    /** The device is ANT FS Client mode. */
    WF_ANTFS_DEVMODE_CLIENT,
    
} WFAntFSDeviceMode_t;

#endif  // _WF_ANTFS_DEVICE_MODE_T_

#ifndef _ANTFS_RESPONSE_T_
#define _ANTFS_RESPONSE_T_
/** Describes an ANT FS response. */
typedef enum
{
    /** No response. */
    ANTFS_RESPONSE_NONE = 0,
    /** The serial line was opened successfully. */
    ANTFS_RESPONSE_OPEN_PASS,                    // Serial
    /** The serial line was initialized successfully. */
    ANTFS_RESPONSE_INIT_PASS,
    /** Failed to initialize the serial line. */
    ANTFS_RESPONSE_SERIAL_FAIL,
    /** The request for a session failed. */
    ANTFS_RESPONSE_REQUEST_SESSION_FAIL,
    /** Client beacon opened. */
    ANTFS_RESPONSE_BEACON_OPEN,                  // Client only
    /** Client beacon closed. */
    ANTFS_RESPONSE_BEACON_CLOSED,                // Client only
    /** Connection succeeded. */
    ANTFS_RESPONSE_CONNECT_PASS,
    /** Disconnect succeeded. */
    ANTFS_RESPONSE_DISCONNECT_PASS,
    /** Broadcast disconnect succeeded. */
    ANTFS_RESPONSE_DISCONNECT_BROADCAST_PASS,    // ANT-FS Broadcast, client only (so far...)
    /** The connection was lost. */
    ANTFS_RESPONSE_CONNECTION_LOST,
    /** Authentication is not available. */
    ANTFS_RESPONSE_AUTHENTICATE_NA,
    /** Authentication passed. */
    ANTFS_RESPONSE_AUTHENTICATE_PASS,
    /** The authentication was rejected by the client. */
    ANTFS_RESPONSE_AUTHENTICATE_REJECT,
    /** Authentication failed. */
    ANTFS_RESPONSE_AUTHENTICATE_FAIL,            // Host only
    /** Request for pairing. */
    ANTFS_RESPONSE_PAIRING_REQUEST,              // Client only
    /** Pairing request timed out. */
    ANTFS_RESPONSE_PAIRING_TIMEOUT,              // Client only
    /** Request for download. */
    ANTFS_RESPONSE_DOWNLOAD_REQUEST,             // Client only
    /** The download request passed. */
    ANTFS_RESPONSE_DOWNLOAD_PASS,
    /** The download request was rejected by the client. */
    ANTFS_RESPONSE_DOWNLOAD_REJECT,
    /** Invalid file index. */
    ANTFS_RESPONSE_DOWNLOAD_INVALID_INDEX,
    /** Requested file cannot be read. */
    ANTFS_RESPONSE_DOWNLOAD_FILE_NOT_READABLE,
    /** Download not ready. */
    ANTFS_RESPONSE_DOWNLOAD_NOT_READY,
    /** The download failed. */
    ANTFS_RESPONSE_DOWNLOAD_FAIL,
    /** Upload request. */
    ANTFS_RESPONSE_UPLOAD_REQUEST,               // Client only
    /** The upload request passed. */
    ANTFS_RESPONSE_UPLOAD_PASS,
    /** The upload request was rejected. */
    ANTFS_RESPONSE_UPLOAD_REJECT,
    /** Invalid file index. */
    ANTFS_RESPONSE_UPLOAD_INVALID_INDEX,
    /** Requested upload cannot be written. */
    ANTFS_RESPONSE_UPLOAD_FILE_NOT_WRITEABLE,
    /** Insufficient space to write the requested upload. */
    ANTFS_RESPONSE_UPLOAD_INSUFFICIENT_SPACE,
    /** The upload failed. */
    ANTFS_RESPONSE_UPLOAD_FAIL,
    /** Request to erase a file. */
    ANTFS_RESPONSE_ERASE_REQUEST,                // Client only
    /** The erase request passed. */
    ANTFS_RESPONSE_ERASE_PASS,
    /** The erase request was rejected. */
    ANTFS_RESPONSE_ERASE_REJECT,                 // Client only
    /** The erase request failed. */
    ANTFS_RESPONSE_ERASE_FAIL,
    /** The manual transfer request passed. */
    ANTFS_RESPONSE_MANUAL_TRANSFER_PASS,            // Host only
    /** Manual request transmit failed. */
    ANTFS_RESPONSE_MANUAL_TRANSFER_TRANSMIT_FAIL,   // Host only
    /** Manual request response failed. */
    ANTFS_RESPONSE_MANUAL_TRANSFER_RESPONSE_FAIL,   // Host only
    /** The request to cancel has been processed. */
    ANTFS_RESPONSE_CANCEL_DONE                      // Host only
} ANTFS_RESPONSE;

#endif // _ANTFS_RESPONSE_T_

#ifndef _ANTFS_STATE_T_
#define _ANTFS_STATE_T_
/** Describes the ANT FS device state. */
typedef enum
{
    /** The device is idle. */
	ANTFS_STATE_IDLE = 0,
    /** Polling USB for available device. */
	ANTFS_STATE_IDLE_POLLING_USB,
    /** The serial line is open. */
	ANTFS_STATE_OPEN,
    /** The device is disconnecting. */
	ANTFS_STATE_DISCONNECTING,
    /** The device is searching for a peer device. */
	ANTFS_STATE_SEARCHING,
    /** The device is connected to a peer device. */
	ANTFS_STATE_CONNECTED,
    /** ANT FS authentication state. */
	ANTFS_STATE_AUTHENTICATING,
    /** ANT FS transport state. */
	ANTFS_STATE_TRANSPORT,
    /** ANT FS download state. */
	ANTFS_STATE_DOWNLOADING,
    /** ANT FS upload state. */
	ANTFS_STATE_UPLOADING,
    /** ANT FS erase state. */
	ANTFS_STATE_ERASING,
    /** The device is sending data. */
	ANTFS_STATE_SENDING,
    /** THe device is receiving data. */
	ANTFS_STATE_RECEIVING   
    
} ANTFS_STATE;
#endif // _ANTFS_STATE_T_

#ifndef _ANTFSP_DIRECTORY_T_
#define _ANTFSP_DIRECTORY_T_
/**
 * Describes the metadata for an ANT FS directory entry.
 */
typedef struct
{
    /**
     * This field specifies the data file index.
     *
     * This is the value used when referencing files for download, upload, and erase.
     */
	USHORT usFileIndex;
    /**
     * This field specifies the data type of the file.
     *
     * The File Data Type informs the host how the file may be interpreted.
     */
	UCHAR  ucFileDataType;
    /**
     * Specifies the data sub type of the .FIT file.
     */
	UCHAR  ucFileSubType;
    /**
     * Number used to identify a specific instance of a file sub-type.
     *
     * Can refer to user, session number, etc.
     */
	USHORT usFileNumber;
    /**
     * Bit mapped flags of file data type specific permissions.
     *
     * Bits (0-7)<br />
     * 76543210<br /><br />
     * Bits are defined by the File Data Type. Bits should be allocated starting from
     * Bit 0.
     */
	UCHAR  ucSpecificFlags;
    /**
     * Bit mapped flags of file permissions.
     * 
     * Bits (0-7)<br />
     * 76543210<br />
     * ||||X------> (bit 3) Append (can append to file only)<br />
     * |||X-------> (bit 4) Archive (been downloaded)<br />
     * ||X--------> (bit 5) Erase (can erase)<br />
     * |X---------> (bit 6) Write (can upload)<br />
     * X----------> (bit 7) Read (can download)<br /><br />
     * Bits 0-2 are reserved.
     */
	UCHAR  ucGeneralFlags;
    /**
     * Size of file in bytes.
     *
     * If file size is 0, then file has not been uploaded but may be available for upload.
     */
	ULONG  ulFileSize;
    /**
     * The number of seconds elapsed since 00:00 in the morning of December 31, 1989.
     *
     * 0 specifies an unknown date. Values of less than 268435455
     * (0x0FFFFFFF) will be interpreted as being system time or some other custom
     * time format.
     */
	ULONG  ulTimestamp;
} ANTFSP_DIRECTORY;
#endif // _ANTFSP_DIRECTORY_T_

#ifndef _WF_FIT_FILE_PERMISSIONS_T_
#define _WF_FIT_FILE_PERMISSIONS_T_
/** Describes the bit-field values for ANT FS file permissions. */
typedef enum
{
    /** Appending data is allowed. */
	FIT_PERMISSIONS_APPEND   = 0x08,
    /** The file has been downloaded. */
	FIT_PERMISSIONS_ARCHIVE  = 0x10,
    /** The file may be erased. */
	FIT_PERMISSIONS_ERASE    = 0x20,
    /** The file may be written. */
	FIT_PERMISSIONS_WRITE    = 0x40,
    /** The file may be read. */
	FIT_PERMISSIONS_READ     = 0x80,
	
} WFFitFilePermissions;
#endif  // _WF_FIT_FILE_PERMISSIONS_T_


#ifndef _ANTFS_DIRECTORY_HEADER_T_
#define _ANTFS_DIRECTORY_HEADER_T_
/**
 * Describes the ANT FS directory header.
 */
typedef struct
{
    /**
     * The version of the Directory File Structure.
     *
     * The most significant 4 bits indicate major revision (format of Index
     * and File Data Type) while the least significant 4 bits indicate a
     * minor revision.
     */
	UCHAR ucVersion;
    /**
     * The length of each structure in bytes.
     */
	UCHAR ucElementLength;
    /**
     * Defines how the system will keep track of Date/Time Stamps.
     *
     * 0 – Device will use time as described in the Date parameter below, if the
     * correct time is not known (prior to initial time sync) the device will use
     * system time instead.<br />
     * 1 - Device will only use system time (seconds since power up).<br />
     * 2 – Device will only use the Date parameter as a counter.
     */
	UCHAR ucTimeFormat;
    /** Reserved byte. */
	UCHAR ucReserved01;
    /** Reserved byte. */
	UCHAR ucReserved02;
    /** Reserved byte. */
	UCHAR ucReserved03;
    /** Reserved byte. */
	UCHAR ucReserved04;
    /** Reserved byte. */
	UCHAR ucReserved05;
    /**
     * The number of seconds elapsed since the system was powered up.
     *
     * If Time Format 0 is selected, the system time should roll over at 268435455
     * (0x0FFFFFFF). If the system time is not used, it should be set to zero.
     */
	ULONG ulSystemTime;
    /**
     * The number of seconds elapsed since 00:00 in the morning of December 31, 1989.
     *
     * 0 specifies an unknown date. Values of less than 268435455
     * (0x0FFFFFFF) will be interpreted as being system time or some other
     * custom time format. This field is updated every time the directory entries
     * are modified. In systems where time is unknown, this variable can be used
     * as a counter that is incremented every time the directory entries are
     * modified.
     */
	ULONG ulTimestamp;   
} ANTFS_DIRECTORY_HEADER;
#endif // _ANTFS_DIRECTORY_HEADER_T_

#ifndef _WF_AND_PEDOMETER_RECORD_T_
#define _WF_AND_PEDOMETER_RECORD_T_
/**
 * Describes an individual record from the A&D Pedometer.
 */
typedef struct
{
    /** The total number of exercise hours. */
	UCHAR ucExerciseHours;
    /** The number of exercise minutes (in addition to the total hours). */
	UCHAR ucExerciseMinutes;
    /** The total number of steps taken. */
	USHORT usTotalSteps;
    /** The total number of calories burned. */
	USHORT usTotalCalories;
	
} WFANDPedometerRecord_t;
#endif  // _WF_AND_PEDOMETER_RECORD_T_

#ifndef _WF_AND_PEDOMETER_FILE_T_
#define _WF_AND_PEDOMETER_FILE_T_
/**
 * Describes the file format for the A&D Pedometer.
 */
typedef struct
{
    /**
     * Specifies the stride length.
     *
     * If WFANDPedometerFile_t::bIsStrideMetric is <c>TRUE</c>, the value is in
     * cm, otherwise, the value is in inches.
     */
	UCHAR ucStrideLength;
    /** Specifies whether the WFANDPedometerFile_t::ucStrideLength value is defined in metric units. */
	BOOL bIsStrideMetric;
    /**
     * Specifies the weight.
     *
     * If WFANDPedometerFile_t::bIsWeightMetric is <c>TRUE</c>, the value is in
     * kg, otherwise, the value is in pounds.
     */
	UCHAR ucWeight;
    /** Specifies whether the WFANDPedometerFile_t::ucWeight value is defined in metric units. */
	BOOL bIsWeightMetric;
    /** The record for the previous day. */
	WFANDPedometerRecord_t stFirstDayBefore;
    /** The record from two days before. */
	WFANDPedometerRecord_t stSecondDayBefore;
    /** The record from three days before. */
	WFANDPedometerRecord_t stThirdDayBefore;
    /** The record from four days before. */
	WFANDPedometerRecord_t stFourthDayBefore;
    /** The record from five days before. */
	WFANDPedometerRecord_t stFifthDayBefore;
    /** The record from six days before. */
	WFANDPedometerRecord_t stSixthDayBefore;
    /** The record from seven days before. */
	WFANDPedometerRecord_t stSeventhDayBefore;
    /** The record from the current day. */
	WFANDPedometerRecord_t stCurrentDay;
	
} WFANDPedometerFile_t;
#endif  // _WF_AND_PEDOMETER_FILE_T_

#ifndef _WF_ANTFS_CLIENT_PARAMS_
#define _WF_ANTFS_CLIENT_PARAMS_
#define ANTFS_AUTH_PASSTHRU                     ((UCHAR) 0x00)
/** ANT-FS Client Parameters */
typedef struct
{
	/** Client serial number.  Set to zero to use the serial number of the USB device. */
	ULONG ulSerialNumber;
	/** Client device type (in beacon). */
	USHORT usBeaconDeviceType;
	/** Client manufacturing ID (in beacon). */
	USHORT usBeaconDeviceManufID;
	/** Link Radio Frequency. */
	UCHAR ucBeaconFrequency;
	/** Link Channel Period. */ 
	UCHAR ucLinkPeriod;
	/** Pairing is enabled/disabled. */
	BOOL bPairingEnabled;
	/** Upload is enabled/disabled. */
	BOOL bUploadEnabled;
	/** Data is available/not available for download. */
	BOOL bDataAvailable;
	/** Authentication type to include in beacon. */
	UCHAR ucAuthType;
	/** In seconds.  Timeout disabled = 0xFF. */
	UCHAR ucBeaconTimeout;
	/** In seconds.  Timeout disabled = 0xFF. */
	UCHAR ucPairingTimeout;
} WFAntFSClientParams_t;
#endif  // _WF_ANTFS_CLIENT_PARAMS_

#ifndef _WF_ANTFS_CLIENT_ERROR_
#define _WF_ANTFS_CLIENT_ERROR_
/** Describes an error encountered by the ANT FS Client. */
typedef enum
{
	/** Unspecified error. */
	WF_ANTFS_CLIENT_ERROR_UNSPECIFIED,
	/** An error was encountered during the download process. */
	WF_ANTFS_CLIENT_ERROR_DOWNLOAD,
	
} WFAntFSClientError_t;
#endif  // _WF_ANTFS_CLIENT_ERROR_

#ifndef _WF_GENDER_T_
#define _WF_GENDER_T_
/** Describes the gender. */
typedef enum
{
    /** Male. */
	WF_GENDER_MALE,
    /** Female. */
	WF_GENDER_FEMALE,
	
} WFGender_t;
#endif  // _WF_GENDER_T_

#ifndef _WF_FITNESS_EQUIPMENT_SETTINGS_T_
#define _WF_FITNESS_EQUIPMENT_SETTINGS_T_
/** Represents the settings transferred to an FE machine. */
typedef struct
{
	/** User display name. */
	__unsafe_unretained NSString* userName;
	/** Weight, measured in kilograms. */
	float weight;
	/** Height, measured in meters. */
	float height;
    /** Age, measured in years. */
	UCHAR age;
    /** Gender. */
	WFGender_t gender;
	/** TRUE if FE machine should connect to HRM. */
	BOOL hrmEnabled;
	/** The device ID of the HRM which should be connected (requires hrmEnabled = TRUE). */
	USHORT hrmDeviceId;
	
} WFFitnessEquipmentSettings_t;
#endif  // _WF_FITNESS_EQUIPMENT_SETTINGS_T_


#endif // _WF_ANTFS_TYPES_H_
