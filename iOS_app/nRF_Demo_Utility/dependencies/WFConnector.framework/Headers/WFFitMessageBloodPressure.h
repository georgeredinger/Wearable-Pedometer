//
//  WFFitMessageBloodPressure.h  (previously WFBloodPressureFitRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 6/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a single record in a Blood Pressure Profile FIT file.
 */
@interface WFFitMessageBloodPressure : WFFitMessageBase
{
	/** \cond InterfaceDocs */

    FIT_BLOOD_PRESSURE_MESG stBloodPressure;
	
	/** \endcond */
}


/**
 * Gets a pointer to the <c>FIT_BLOOD_PRESSURE_MESG</c> structure containing the
 * data for this record.
 */
@property (nonatomic, readonly) FIT_BLOOD_PRESSURE_MESG* pstBloodPressure;

/**
 * Gets or sets the systolic pressure value.
 */
@property (nonatomic, readonly) USHORT systolicPressure;

/**
 * Gets or sets the diastolic pressure value.
 */
@property (nonatomic, readonly) USHORT diastolicPressure;

/**
 * Gets or sets the heart rate value, in Beats per Minute.
 */
@property (nonatomic, readonly) USHORT heartRate;

@end
