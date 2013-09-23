//
//  wf_glucose_types.h
//  WFConnector
//
//  Created by Michael Moore on 2/23/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#ifndef _wf_glucose_types_h_
#define _wf_glucose_types_h_


#define WF_GLUCOSE_VALUES_UNINITIALIZED    ((USHORT)0x000)
#define WF_GLUCOSE_VALUES_UNAVAILABLE      ((USHORT)0x001)
#define WF_GLUCOSE_VALUES_FILE_DATA_ONLY   ((USHORT)0x002)
#define WF_GLUCOSE_VALUES_EQUILIBRIUM_25   ((USHORT)0x003)
#define WF_GLUCOSE_VALUES_EQUILIBRIUM_50   ((USHORT)0x004)
#define WF_GLUCOSE_VALUES_EQUILIBRIUM_75   ((USHORT)0x005)
#define WF_GLUCOSE_VALUES_EQUILIBRIUM_100  ((USHORT)0x006)


/**
 * Represents the status flags for the Glucose Monitor sensor.
 */
typedef union
{
    /** The raw status byte. */
    UCHAR ucStatus;
    /** The flags. */
    struct
    {
        /** High alert condition present. */
        BOOL bHighAlert             : 1;
        /** Low alert condition present. */
        BOOL bLowAlert              : 1;
        /** Glucose level below 55. */
        BOOL bBelow55               : 1;
        /** Glucose level is rising. */
        BOOL bRisingAlert           : 1;
        /** Glucose level is falling. */
        BOOL bFallingAlert          : 1;
        /** Additional error information is available. */
        BOOL bRequestFurtherError   : 1;
        /** Additional status information is available. */
        BOOL bRequestFurtherStatus  : 1;
        BOOL                        : 1;
        
    };
    
} WFGlucoseStatus_t;

/** Describes the rate of change in the glucose level. */
typedef enum
{
    /** Change rate not available. */
    WF_GLUCOSE_CHANGE_RATE_UNAVAILABLE = 0,
    /** The glucose level is rapidly increasing. */
    WF_GLUCOSE_CHANGE_RATE_RAPIDLY_INCREASING,
    /** The glucose level is increasing. */
    WF_GLUCOSE_CHANGE_RATE_INCREASING,
    /** The glucose level is slowly increasing. */
    WF_GLUCOSE_CHANGE_RATE_SLOWLY_INCREASING,
    /** The glucose level is holding steady. */
    WF_GLUCOSE_CHANGE_RATE_STEADY,
    /** The glucose level is slowly decreasing. */
    WF_GLUCOSE_CHANGE_RATE_SLOWLY_DECREASING,
    /** The glucose level is decreasing. */
    WF_GLUCOSE_CHANGE_RATE_DECREASING,
    /** The glucose level is rapidly decreasing. */
    WF_GLUCOSE_CHANGE_RATE_RAPIDLY_DECREASING,
    
} WFGlucoseChangeRate_t;

/** Describes the glucose level change alert level. */
typedef enum
{
    /** Change rate alert is disabled. */
    WF_GLUCOSE_RATE_ALERT_LEVEL_DISABLED = 0,
    /** Change rate alert when glucose level changes by 2 mg/dL or more. */
    WF_GLUCOSE_RATE_ALERT_LEVEL_2_MG_DL_MIN,
    /** Change rate alert when glucose level changes by 3 mg/dL or more. */
    WF_GLUCOSE_RATE_ALERT_LEVEL_3_MG_DL_MIN,
    
} WFGlucoseRateAlertLevel_t;

#endif // _wf_glucose_types_h_
