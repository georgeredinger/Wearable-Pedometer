//
//  WFBikePowerPowerOnlyData.h
//  WFConnector
//
//  Created by Michael Moore on 11/9/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFSensorData.h>


/**
 * Represents the data available from the Power-Only type ANT+ Bike Power sensor.
 *
 * ANT+ sensors send data in multiple packets.  The WFBikePowerPowerOnlyData
 * combines this data into a single entity.  The data represents the latest of
 * each data type sent from the sensor.
 */
@interface WFBikePowerPowerOnlyData : WFSensorData
{
	/** \cond InterfaceDocs */
	
	UCHAR  eventCount;
	UCHAR  instantCadence;
	USHORT accumulatedPower;
	USHORT instantPower;
	ULONG  averagePower;
	
    BOOL pedalPowerSupported;
    BOOL pedalDifferentiation;
    float pedalPowerContributionPercent;
    
	/** \endcond */
}


/**
 * Power event count, incremented each time the sensor takes a measurement.
 */
@property (nonatomic, assign) UCHAR  eventCount;
/**
 * Crank cadence (RPMs) – if available.  Otherwise: 0xFF indicates invalid.
 */
@property (nonatomic, assign) UCHAR  instantCadence;
/**
 * Accumulated power (1-watt resolution).
 */
@property (nonatomic, assign) USHORT accumulatedPower;
/**
 * Instantaneous power (1-watt resolution).
 */
@property (nonatomic, assign) USHORT instantPower;
/**
 * Buffered power measurement (1-watt resolution).
 */
@property (nonatomic, assign) ULONG  averagePower;
/**
 * Pedal power data availble.
 */
@property (nonatomic, assign) BOOL pedalPowerSupported;
/**
 * Pedal Differentation - TRUE if pedal power used and power sensor is capable of differentiating between left and right.
 * Otherwise FALSE
 */
@property (nonatomic, assign) BOOL pedalDifferentiation;
/**
 * Pedal power contribution between left and right pedals.
 * If pedalDifferentiation is TRUE, then value is for Right Pedal
 * Otherwise the sensor does not known if the value is for the Left or Right Pedal.
 */
@property (nonatomic, assign) float pedalPowerContributionPercent;

@end
