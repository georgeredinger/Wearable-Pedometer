//
//  wf_btle_types.h
//  WFConnector
//
//  Created by Michael Moore on 2/28/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#ifndef _wf_btle_types_h_
#define _wf_btle_types_h_

/** Value indicating that the battery level is invalid. */
#define WF_BTLE_BATT_LEVEL_INVALID  0xFF


////////////////////////////////////////////////////////////////////////////////
// Battery Service Macros and Definitions.
////////////////////////////////////////////////////////////////////////////////

/** Describes whether a battery is present. */
typedef enum
{
    /** Battery presence is not known. */
    WF_BTLE_BATT_STATE_PRESENT_UNKNOWN = 0,
    /** Determination of battery presence is not supported. */
    WF_BTLE_BATT_STATE_PRESENT_NOT_SUPPORTED,
    /** Battery is not present. */
    WF_BTLE_BATT_STATE_PRESENT_NOT_PRESENT,
    /** Battery is present. */
    WF_BTLE_BATT_STATE_PRESENT_PRESENT,
    
} WFBTLEBattStatePresent_t;

/** Describes whether the battery is currently discharging. */
typedef enum
{
    /** The battery discharge state is not known. */
    WF_BTLE_BATT_STATE_DISCHARGING_UNKNOWN = 0,
    /** Determination of battery discharge state is not supported. */
    WF_BTLE_BATT_STATE_DISCHARGING_NOT_SUPPORTED,
    /** The battery is not currently discharging. */
    WF_BTLE_BATT_STATE_DISCHARGING_NOT_DISCHARGING,
    /** The battery is currently discharging. */
    WF_BTLE_BATT_STATE_DISCHARGING_DISCHARGING,
    
} WFBTLEBattStateDischarging_t;

/** Describes whether the battery is currently charging. */
typedef enum
{
    /** The battery charging state is not known. */
    WF_BTLE_BATT_STATE_CHARGING_UNKNOWN = 0,
    /** The battery is not chargeable. */
    WF_BTLE_BATT_STATE_CHARGING_NOT_CHARGEABLE,
    /** The battery is not currently charging. */
    WF_BTLE_BATT_STATE_CHARGING_NOT_CHARGING,
    /** The battery is currently charging. */
    WF_BTLE_BATT_STATE_CHARGING_CHARGING,

} WFBTLEBattStateCharging_t;

/** Describes whether the battery level is critical. */
typedef enum
{
    /** The battery critical state is not known. */
    WF_BTLE_BATT_STATE_CRITICAL_UNKNOWN = 0,
    /** Determination of battery critical state is not supported. */
    WF_BTLE_BATT_STATE_CRITICAL_NOT_SUPPORTED,
    /** The battery level is good. */
    WF_BTLE_BATT_STATE_CRITICAL_GOOD_LEVEL,
    /** The battery level is critically low. */
    WF_BTLE_BATT_STATE_CRITICAL_CRITICALLY_LOW_LEVEL,
    
} WFBTLEBattStateCritical_t;

/** Represents the battery power state. */
typedef struct
{
    /** Indicates whether the battery is present. */
    WFBTLEBattStatePresent_t batteryPresent;
    /** Indicates whether the battery is discharging. */
    WFBTLEBattStateDischarging_t batteryDischarging;
    /** Indicates whether the battery is charging. */
    WFBTLEBattStateCharging_t batteryCharging;
    /** Indicates whether the battery level is critical. */
    WFBTLEBattStateCritical_t batteryCritical;
    
} WFBTLEBattPowerState_t;


////////////////////////////////////////////////////////////////////////////////
// Glucose Service Macros and Definitions.
////////////////////////////////////////////////////////////////////////////////

/** Describes available features of a BTLE Glucose Monitor device. */
typedef struct
{
    /** Can detect low battery condition. */
    BOOL bLowBatteryDetect;
    /** Can detect sensor malfunction. */
    BOOL bSensorMalfunctionDetect;
    /** Supports sample size. */
    BOOL bSampleSize;
    /** Can detect strip insertion error. */
    BOOL bStripInsertErrorDetect;
    /** Can detect strip type error. */
    BOOL bStripTypeErrorDetect;
    /** Can detect high or low result. */
    BOOL bResultHighLowDetect;
    /** Can detect high or low sensor temperature. */
    BOOL bTempHighLowDetect;
    /** Can detect read interrupt. */
    BOOL bReadInterruptDetect;
    /** Supports general device fault. */
    BOOL bGeneralDeviceFault;
    /** Supports time fault. */
    BOOL bTimeFault;
    /** Supports multiple bond. */
    BOOL bMultipleBond;
    
} WFBTLEGlucoseDeviceFeatures_t;

/** Describes a glucose sample type. */
typedef enum
{
    /** Sample type not defined. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_UNDEFINED = 0,
    /** Sample taken from capillary whole blood. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_CAPILLARY_WHOLE_BLOOD,
    /** Sample taken from capillary plasma. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_CAPILLARY_PLASMA,
    /** Sample taken from venous whole blood. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_VENOUS_WHOLE_BLOOD,
    /** Sample taken from venous plasma. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_VENOUS_PLASMA,
    /** Sample taken from arterial whole blood. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_ARTERIAL_WHOLE_BLOOD,
    /** Sample taken from arterial plasma. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_ARTERIAL_PLASMA,
    /** Sample taken from whole blood - source not determined. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_UNDETERMINED_WHOLE_BLOOD,
    /** Sample taken from plasma - source not determined. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_UNDETERMINED_PLASMA,
    /** Sample taken from interstitial fluid. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_INTERSTITIAL_FLUID,
    /** Sample taken from control solution. */
    WF_BTLE_GLUCOSE_SAMPLE_TYPE_CONTROL_SOLUTION,
    
} WFBTLEGlucoseSampleType_t;

/** Describes the location where a glucose sample was taken. */
typedef enum
{
    /** The sample location is not defined. */
    WF_BTLE_GLUCOSE_SAMPLE_LOC_UNDEFINED = 0,
    /** Sample taken from a finger. */
    WF_BTLE_GLUCOSE_SAMPLE_LOC_FINGER,
    /** Sample taken from an alternate test site. */
    WF_BTLE_GLUCOSE_SAMPLE_LOC_ALTERNATE_TEST_SITE,
    /** Sample taken from the earlobe. */
    WF_BTLE_GLUCOSE_SAMPLE_LOC_EARLOBE,
    /** Sample taken from a control solution. */
    WF_BTLE_GLUCOSE_SAMPLE_LOC_CONTROL_SOLUTION,
    /** The sample location is not available. */
    WF_BTLE_GLUCOSE_SAMPLE_LOC_NOT_AVAILABLE = 15,
    
} WFBTLEGlucoseSampleLocation_t;

/**
 * Represents the status flags for the BTLE Glucose Monitor sensor.
 */
typedef union
{
    /** The raw status bytes. */
    USHORT usStatus;
    /** The flags. */
    struct
    {
        /** The battery is low. */
        BOOL bBatteryLow              : 1;
        /** A sensor malfunction occurred. */
        BOOL bSensorMalfunction       : 1;
        /** The sample size is insufficient. */
        BOOL bSampleSizeInsufficient  : 1;
        /** A strip insertion error occurred. */
        BOOL bStripInsertionError     : 1;
        /** The strip type is incorrect. */
        BOOL bStripTypeIncorrect      : 1;
        /** The result is too high. */
        BOOL bResultTooHigh           : 1;
        /** The result is too low. */
        BOOL bResultTooLow            : 1;
        /** The sensor temperature is too high. */
        BOOL bTemperatureTooHigh      : 1;
        /** The sensor temperature is too low. */
        BOOL bTemperatureTooLow       : 1;
        /** The sample reading was interrupted. */
        BOOL bReadInterrupted         : 1;
        /** A general device fault occurred. */
        BOOL bGeneralDeviceFault      : 1;
        /** A time fault occurred. */
        BOOL bTimeFault               : 1;
        BOOL                          : 1;
        BOOL                          : 1;
        BOOL                          : 1;
        BOOL                          : 1;
    };
    
} WFBTLEGlucoseSensorStatus_t;

/** Represents the data for a glucose measurement. */
typedef struct
{
    /** The measurement sequence for this record. */
    USHORT usSequence;
    /** The base time value. */
    NSTimeInterval baseTime;
    /** The offset of the measurement from the base time. */
    SSHORT ssTimeOffset;
    /** The glucose concentration, measured in mg/dL. */
    float concentration;
    /** The sample type. */
    WFBTLEGlucoseSampleType_t sampleType;
    /** The sample location. */
    WFBTLEGlucoseSampleLocation_t sampleLocation;
    /** The sensor status. */
    WFBTLEGlucoseSensorStatus_t sensorStatus;
    
} WFBTLEGlucoseMeasurementData_t;

/** Describes the carbohydrate ID. */
typedef enum
{
    /** Carbohydrate ID not defined. */
    WF_BTLE_GLUCOSE_CARB_ID_UNDEFINED = 0,
    /** Breakfast. */
    WF_BTLE_GLUCOSE_CARB_ID_BREAKFAST,
    /** Lunch. */
    WF_BTLE_GLUCOSE_CARB_ID_LUNCH,
    /** Dinner. */
    WF_BTLE_GLUCOSE_CARB_ID_DINNER,
    /** Snack. */
    WF_BTLE_GLUCOSE_CARB_ID_SNACK,
    /** Drink. */
    WF_BTLE_GLUCOSE_CARB_ID_DRINK,
    /** Supper. */
    WF_BTLE_GLUCOSE_CARB_ID_SUPPER,
    /** Brunch. */
    WF_BTLE_GLUCOSE_CARB_ID_BRUNCH,
    
} WFBTLEGlucoseCarbId_t;

/** Describes the meal information. */
typedef enum
{
    /** Meal information not defined. */
    WF_BTLE_GLUCOSE_MEAL_INFO_UNDEFINED = 0,
    /** Before a meal. */
    WF_BTLE_GLUCOSE_MEAL_INFO_BEFORE_MEAL,
    /** After a meal. */
    WF_BTLE_GLUCOSE_MEAL_INFO_AFTER_MEAL,
    /** Fasting. */
    WF_BTLE_GLUCOSE_MEAL_INFO_FASTING,
    /** Casual. */
    WF_BTLE_GLUCOSE_MEAL_INFO_CASUAL,
    /** Bedtime. */
    WF_BTLE_GLUCOSE_MEAL_INFO_BEDTIME,
    
} WFBTLEGlucoseMealInfo_t;

/** Describes the tester information. */
typedef enum
{
    /** Tester information not defined. */
    WF_BTLE_GLUCOSE_TESTER_INFO_UNDEFINED = 0,
    /** Self tested. */
    WF_BTLE_GLUCOSE_TESTER_INFO_SELF,
    /** Tested by health care professional. */
    WF_BTLE_GLUCOSE_TESTER_INFO_HEALTH_CARE_PRO,
    /** Tested by laboratory. */
    WF_BTLE_GLUCOSE_TESTER_INFO_LAB_TEST,
    /** Tester information not available. */
    WF_BTLE_GLUCOSE_TESTER_INFO_NOT_AVAILABLE = 15,
    
} WFBTLEGlucoseTesterInfo_t;

/** Describes the health information. */
typedef enum
{
    /** Health information not defined. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_UNDEFINED = 0,
    /** Minor health issues. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_MINOR_HEALTH_ISSUES,
    /** Major health issues. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_MAJOR_HEALTH_ISSUES,
    /** During menses. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_DURING_MENSES,
    /** Under stress. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_UNDER_STRESS,
    /** No health issues. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_NO_HEALTH_ISSUES,
    /** Health information not available. */
    WF_BTLE_GLUCOSE_HEALTH_INFO_NOT_AVAILABLE = 15,
    
} WFBTLEGlucoseHealthInfo_t;

/** Describes the medication ID. */
typedef enum
{
    /** Medication ID not defined. */
    WF_BTLE_GLUCOSE_MED_ID_UNDEFINED = 0,
    /** Rapid-acting insulin. */
    WF_BTLE_GLUCOSE_MED_ID_RAPID_ACTING_INSULIN,
    /** Short-acting insulin. */
    WF_BTLE_GLUCOSE_MED_ID_SHORT_ACTING_INSULIN,
    /** Immediate-acting insulin. */
    WF_BTLE_GLUCOSE_MED_ID_IMMEDIATE_ACTING_INSULIN,
    /** Long-acting insulin. */
    WF_BTLE_GLUCOSE_MED_ID_LONG_ACTING_INSULIN,
    /** Pre-mixed insulin. */
    WF_BTLE_GLUCOSE_MED_ID_PRE_MIXED_INSULIN,
    
} WFBTLEGlucoseMedId_t;

/** Describes the medication units. */
typedef enum
{
    /** Medication measured in milligrams. */
    WF_BTLE_GLUCOSE_MED_UNITS_MILLIGRAMS = 0,
    /** Medication measured in milliliters. */
    WF_BTLE_GLUCOSE_MED_UNITS_MILLILITERS,
    
} WFBTLEGlucoseMedUnits_t;

/** Represents the context of a glucose measurement. */
typedef struct
{
    /** The measurement sequence number. */
    USHORT usSequence;
    /** The carbohydrate ID. */
    WFBTLEGlucoseCarbId_t carbohydrateId;
    /** The carbohydrate quantity, measured in kilograms. */
    float carbohydrate;
    /** The meal information. */
    WFBTLEGlucoseMealInfo_t mealInfo;
    /** The tester information. */
    WFBTLEGlucoseTesterInfo_t testerInfo;
    /** The health information. */
    WFBTLEGlucoseHealthInfo_t healthInfo;
    /** The exercise duration, measured in seconds. */
    USHORT usExerciseDuration;
    /** The exercise intensity, measured in percent. */
    UCHAR ucExerciseIntensity;
    /** The medication ID. */
    WFBTLEGlucoseMedId_t medicationId;
    /** The medication quantity (units specified by <c>medicationUnits</c>). */
    float medication;
    /** The medication units. */
    WFBTLEGlucoseMedUnits_t medicationUnits;
    /** HbA1c, measured in percent. */
    float hbA1c;
    
} WFBTLEGlucoseMeasurementContext_t;


/** Describes a BTLE Record Access command code. */
typedef enum
{
    /** OP CODE not defined. */
    WF_BTLE_RECORD_OP_CODE_UNDEFINED = 0,
    /** Command to report stored records. */
    WF_BTLE_RECORD_OP_CODE_REPORT_STORED_RECORDS,
    /** Command to delete stored records. */
    WF_BTLE_RECORD_OP_CODE_DELETE_STORED_RECORDS,
    /** Command to abort the current operation. */
    WF_BTLE_RECORD_OP_CODE_ABORT_OPERATION,
    /** Command to report the record count. */
    WF_BTLE_RECORD_OP_CODE_REPORT_RECORD_COUNT,
    /** Code indicating a record count response (sent from the device). */
    WF_BTLE_RECORD_OP_CODE_RECORD_COUNT_RESPONSE,
    /** Code indicating a response to a command (sent from the device). */
    WF_BTLE_RECORD_OP_CODE_RESPONSE_CODE,
    
} WFBTLERecordOpCode_t;

/** Describes the operator for a BTLE Glucose Monitor record command. */
typedef enum
{
    /** NULL operator. */
    WF_BTLE_RECORD_OPERATOR_NULL = 0,
    /** Command affects all records. */
    WF_BTLE_RECORD_OPERATOR_ALL_RECORDS,
    /** Command affects records less than or equal to a specified value. */
    WF_BTLE_RECORD_OPERATOR_LESS_THAN_OR_EQUAL,
    /** Command affects records greater than or equal to a specified value. */
    WF_BTLE_RECORD_OPERATOR_GREATER_THAN_OR_EQUAL,
    /** Command affects records within range of specified values. */
    WF_BTLE_RECORD_OPERATOR_WITHIN_RANGE,
    /** Command affects the first record. */
    WF_BTLE_RECORD_OPERATOR_FIRST_RECORD,
    /** Command affects the last record. */
    WF_BTLE_RECORD_OPERATOR_LAST_RECORD,
    
} WFBTLERecordOperator_t;


////////////////////////////////////////////////////////////////////////////////
// Blood Pressure Service Macros and Definitions.
////////////////////////////////////////////////////////////////////////////////

/** Describes the Pulse Rate Range detected by the Blood Pressure Monitor. */
typedef enum
{
    /** Pulse Rate is within the acceptable range. */
    WF_BTLE_BP_PULSE_RANGE_OK = 0,
    /** Pulse Rate exceeds the upper limit. */
    WF_BTLE_BP_PULSE_RANGE_EXCEEDS_UPPER_LIMIT,
    /** Pulse Rate is below the lower limit. */
    WF_BTLE_BP_PULSE_RANGE_BELOW_LOWER_LIMIT,
    
} WFBTLEBPPulseRange_t;

/** Represents the status reported by the Blood Pressure Monitor. */
typedef struct
{
    /** <c>TRUE</c> if body movement was detected during measurement, otherwise <c>FALSE</c>. */
    BOOL bBodyMovementDetected;
    /** <c>TRUE</c> if the cuff fit is too loose, otherwise <c>FALSE</c>. */
    BOOL bCuffTooLoose;
    /** <c>TRUE</c> if the an irregular pulse was detected, otherwise <c>FALSE</c>. */
    BOOL bIrregularPulseDetected;
    /** A ::WFBTLEBPPulseRange_t value describing the detected pulse rate. */
    WFBTLEBPPulseRange_t pulseRange;
    /** <c>TRUE</c> if an improper measurement position was detected, otherwise <c>FALSE</c>. */
    BOOL bImproperPosition;
    
} WFBTLEBPStatus_t;


////////////////////////////////////////////////////////////////////////////////
// RSC Service Macros and Definitions.
////////////////////////////////////////////////////////////////////////////////

/** Represents the features of a Running Speed and Cadence device. */
typedef struct
{
    /** <c>TRUE</c> if the device supports instantaneous stride length measurement, otherwise <c>FALSE</c>. */
    BOOL bInstStrideLengthMeasurementSupported;
    /** <c>TRUE</c> if the device supports total distance measurement, otherwise <c>FALSE</c>. */
    BOOL bTotalDistanceMeasurementSupported;
    /** <c>TRUE</c> if the device supports indicating running or walking, otherwise <c>FALSE</c>. */
    BOOL bWalkingOrRunningSupported;
    /** <c>TRUE</c> if the device supports a calibration procedure, otherwise <c>FALSE</c>. */
    BOOL bCalibrationSupported;
    /** <c>TRUE</c> if the device can be mounted in alternate locations, otherwise <c>FALSE</c>. */
    BOOL bMultipleSensorLocationsSupported;
    
} WFBTLERSCFeatures_t;


////////////////////////////////////////////////////////////////////////////////
// CSC Service Macros and Definitions.
////////////////////////////////////////////////////////////////////////////////

/** Represents the features of a Bike Speed and Cadence device. */
typedef struct
{
    /** <c>TRUE</c> if the device supports speed measurement, otherwise <c>FALSE</c>. */
    BOOL bSpeedMeasurementSupported;
    /** <c>TRUE</c> if the device supports cadence measurement, otherwise <c>FALSE</c>. */
    BOOL bCadenceMeasurementSupported;
    /** <c>TRUE</c> if the device can be mounted in alternate locations, otherwise <c>FALSE</c>. */
    BOOL bMultipleSensorLocationsSupported;
    
} WFBTLECSCFeatures_t;

/** Describes the location of a sensor. */
typedef enum
{
    /** The sensor location is other than the specified locations. */
    WF_BTLE_SENSOR_LOCATION_OTHER = 0,
    /** The sensor is located on the top of the shoe. */
    WF_BTLE_SENSOR_LOCATION_TOP_OF_SHOE,
    /** The sensor is located in the shoe. */
    WF_BTLE_SENSOR_LOCATION_IN_SHOE,
    /** The sensor is located on the hip. */
    WF_BTLE_SENSOR_LOCATION_HIP,
    /** The bike sensor is located on the wheel. */
    WF_BTLE_SENSOR_LOCATION_WHEEL,
    /** The bike sensor is located in the left crankset. */
    WF_BTLE_SENSOR_LOCATION_LEFT_CRANKSET,
    /** The bike sensor is located in the right crankset. */
    WF_BTLE_SENSOR_LOCATION_RIGHT_CRANKSET,
    /** The bike sensor is located on the left pedal. */
    WF_BTLE_SENSOR_LOCATION_LEFT_PEDAL,
    /** The bike sensor is located on the right pedal. */
    WF_BTLE_SENSOR_LOCATION_RIGHT_PEDAL,
    /** The bike sensor is located in the hub. */
    WF_BTLE_SENSOR_LOCATION_HUB,
    /** The bike sensor is located in the rear dropout. */
    WF_BTLE_SENSOR_LOCATION_REAR_DROP_OUT,
    
} WFBTLESensorLocation_t;

/** Describes an odometer command code for the Wahoo Fitness BlueSC. */
typedef enum
{
    /** OP CODE not defined. */
    WF_BTLE_WAHOO_CSC_OP_CODE_UNDEFINED = 0,
    /** Command to retrieve stored records. */
    WF_BTLE_WAHOO_CSC_OP_CODE_RETRIEVE_STORED_RECORDS,
    /** Response to retrieve stored records command. */
    WF_BTLE_WAHOO_CSC_OP_CODE_STORED_RECORDS_RESPONSE,
    /** Command to delete stored records. */
    WF_BTLE_WAHOO_CSC_OP_CODE_DELETE_STORED_RECORDS,
    /**
     * Command to set the time on the device.
     *
     * For Wahoo devices, the command operand to set the device time is a 32-bit
     * value representing the number of seconds since the Cocoa reference date.
     */
    WF_BTLE_WAHOO_CSC_OP_CODE_SET_TIME,
    /** Command to abort the current operation. */
    WF_BTLE_WAHOO_CSC_OP_CODE_ABORT_OPERATION,
    /** Code indicating a response to a command (sent from the device). */
    WF_BTLE_WAHOO_CSC_OP_CODE_RESPONSE_CODE,
    
} WFBTLEWahooCSCOpCode_t;

/** Describes a command code for the BTLE Bike Speed and Cadence Sensor. */
typedef enum
{
    /** OP CODE not defined. */
    WF_BTLE_CSC_OP_CODE_UNDEFINED                    = 0,
    /** Command to reset the cumulative wheel revolutions (odometer). */
    WF_BTLE_CSC_OP_CODE_RESET_CUMULATIVE_VALUE,
    /** Command to begin the calibration process (currently unused). */
    WF_BTLE_CSC_OP_CODE_START_SENSOR_CALIBRATION,
    /** Command to update the sensor location (not supported on BlueSC). */
    WF_BTLE_CSC_OP_CODE_UPDATE_SENSOR_LOCATION,
    /** Command to retrieve the sensor locations (not supported on BlueSC). */
    WF_BTLE_CSC_OP_CODE_REQUEST_SUPPORTED_LOCATIONS,
    /** Code indicating a response to a command (sent from the device). */
    WF_BTLE_CSC_OP_CODE_RESPONSE_CODE                = 0x10,
    
} WFBTLECSCOpCode_t;

#endif  // _wf_btle_types_h_
