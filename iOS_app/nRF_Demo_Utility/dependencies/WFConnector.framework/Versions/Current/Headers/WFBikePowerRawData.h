//
//  WFBikePowerRawData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>

@class WFCommonData;
@class WFBikePowerPowerOnlyData;
@class WFBikePowerCrankTorqueData;
@class WFBikePowerCTFData;
@class WFBikePowerWheelTorqueData;


/**
 * Represents the raw data available from the ANT+ Bike Power sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikePowerRawData combines the
 * more advanced (less commonly used) of this data into a single entity.  The data
 * represents the latest of each data type sent from the sensor.
 */
@interface WFBikePowerRawData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	WFBikePowerType_t sensorType;
	WFCommonData* commonData;
	
	WFBikePowerCalibrationData_t calibrationData;
	WFBikePowerPowerOnlyData* powerOnlyData;
	WFBikePowerWheelTorqueData* wheelTorqueData;
	WFBikePowerCrankTorqueData* crankTorqueData;
	WFBikePowerCTFData* crankTorqueFreqData;
	
	/** \endcond */
}


/**
 * Indicates the type of the power meter.
 *
 * @note After the sensor connects, or is reset, it will take several
 * messages from the device before the sensor type can be determined.
 */
@property (nonatomic, assign) WFBikePowerType_t sensorType;
/**
 * Common sensor data, provides information about the sensor.
 */
@property (nonatomic, readonly) WFCommonData* commonData;
/**
 * Contains the calibration data sent from the sensor.
 */
@property (nonatomic, assign) WFBikePowerCalibrationData_t calibrationData;
/**
 * Data provided by the Power-Only sensor.  Most types of Bike Power
 * sensors provide this data.
 */
@property (nonatomic, retain) WFBikePowerPowerOnlyData* powerOnlyData;
/**
 * Data provided by the Wheel-Torque type of Bike Power sensor.
 */
@property (nonatomic, retain) WFBikePowerWheelTorqueData* wheelTorqueData;
/**
 * Data provided by the Crank-Torque type of Bike Power sensor.
 */
@property (nonatomic, retain) WFBikePowerCrankTorqueData* crankTorqueData;
/**
 * Data provided by the Crank-Torque-Frequency type of Bike Power sensor.
 */
@property (nonatomic, retain) WFBikePowerCTFData* crankTorqueFreqData;

@end
