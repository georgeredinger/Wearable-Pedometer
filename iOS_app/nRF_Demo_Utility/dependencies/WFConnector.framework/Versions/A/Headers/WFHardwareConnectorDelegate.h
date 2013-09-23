/*
 *  WFHardwareConnectorDelegate.h
 *  WFHardwareConnector
 *
 *  Created by Michael Moore on 2/10/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#import <WFConnector/hardware_connector_types.h>


@class WFHardwareConnector;
@class WFSensorConnection;


/**
 * The WFHardwareConnectorDelegate protocol declares the interface that
 * WFHardwareConnector delegates must implement.
 *
 * The WFHardwareConnectorDelegate protocol should be adopted in classes
 * where the sensor data is processed.  It is common to adopt this protocol
 * in the same class where the WFHardwareConnector instance is created, but
 * this is not necessary.  Sensor data updates and connection status events
 * will be delivered to the delegate.
 */
@protocol WFHardwareConnectorDelegate <NSObject>

@optional

/**
 * Alerts the delegate that a sensor connection has been established.
 *
 * The <i>connectionInfo</i> parameter may be used to determine the type
 * and identification of the sensor which was connected.
 *
 * See the WFHardwareConnector::requestSensorConnection: method for
 * documentation about the sensor connection process.
 *
 * @param hwConnector The WFHardwareConnector instance.
 *
 * @param connectionInfo A WFSensorConnection instance that may be used to
 * determine the sensor type and manage the connection.
 */
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector connectedSensor:(WFSensorConnection*)connectionInfo;

/**
 * Alerts the delegate that a device has been discovered.
 *
 * @note See the WFHardwareConnector::discoverDevicesOfType:onNetwork:searchTimeout:
 * method for documentation about the sensor discovery process.
 *
 * @param hwConnector The WFHardwareConnector instance.
 *
 * @param connectionParams An <c>NSSet</c> instance containing zero or more
 * WFConnectionParams instances.  Each WFConnectionParams instance will contain
 * connection information for the discovered device in the
 * WFConnectionParams::device1 property.
 * 
 * @param bCompleted <c>TRUE</c> if the discovery is finished, otherwise <c>FALSE</c>.
 */
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector didDiscoverDevices:(NSSet*)connectionParams searchCompleted:(BOOL)bCompleted;

/**
 * Alerts the delegate that a sensor connection has ended.
 *
 * The <i>connectionInfo</i> parameter may be used to determine the type
 * and identification of the sensor which was disconnected.
 *
 * See the WFHardwareConnector::requestSensorConnection: method for
 * documentation about the sensor connection process.
 *
 * @param hwConnector The WFHardwareConnector instance.
 *
 * @param connectionInfo A WFSensorConnection instance that may be used to
 * determine the sensor type.
 */
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector disconnectedSensor:(WFSensorConnection*)connectionInfo;

/**
 * Alerts the delegate that the state of the hardware connector has changed.
 *
 * This method is invoked when the fisica (key or case) accessory device has
 * been physically connected to and recognized by the iPhone, or when it is
 * physically removed from the iPhone.  It will also be invoked at the
 * beginning and end of a reset operation
 * (see WFHardwareConnector::resetConnections).
 *
 * @param hwConnector The WFHardwareConnector instance.
 * @param currentState  The current state of the hardware connector.
 *
 * @note
 * For more information about the possible state values, see
 * WFHardwareConnector::currentState.
 */
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector stateChanged:(WFHardwareConnectorState_t)currentState;

/**
 * Alerts the delegate that data is available.
 *
 * This method may be invoked only when new data is availabe, or on a
 * specified interval.  See the WFHardwareConnector::sampleRate and
 * WFHardwareConnector::setSampleTimerDataCheck: documentation for information
 * about how to configure the data alerts.
 */
- (void)hardwareConnectorHasData;

@end