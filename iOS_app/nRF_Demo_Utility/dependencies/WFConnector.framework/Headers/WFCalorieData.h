//
//  WFCalorieData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the data available from the ANT+ Calorimeter sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFCalorieData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFCalorieData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	USHORT usBurnRate;
	USHORT usTotalCalories;
	USHORT usElapsedTime;
	WFCalConfidence_t confidence;
	USHORT usAvgBurnRate;
	USHORT usSmartCal;
	
	/** \endcond */
}


/** The current calorie burn rate, in calories per hour. */
@property (nonatomic, assign) USHORT usBurnRate;
/** Total calories burned since the user began using the sensor. */
@property (nonatomic, assign) USHORT usTotalCalories;
/** The length of time the sensor has been in use, measured in minutes. */
@property (nonatomic, assign) USHORT usElapsedTime;
/** A value indicating the confidence in the accuracy of the measurement. */
@property (nonatomic, assign) WFCalConfidence_t confidence;
/** The average calorie burn rate, in calories per hour. */
@property (nonatomic, assign) USHORT usAvgBurnRate;
/** The SmartCAL value. */
@property (nonatomic, assign) USHORT usSmartCal;	

@end
