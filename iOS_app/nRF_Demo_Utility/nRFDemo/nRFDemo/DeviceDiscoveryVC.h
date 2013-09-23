///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012 Nordic Semiconductor. All Rights Reserved.
// Copyright (c) 2012 Wahoo Fitness. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA and Wahoo Fitness LLC.
// Terms and conditions of usage are described in detail in
// NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
///////////////////////////////////////////////////////////////////////////////
//
//  DeviceDiscoveryVC.h
//  WahooDemo
//
//  Created by Michael Moore on 3/9/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>


typedef enum
{
    DISCOVERY_VIEW_STATE_IDLE,
    DISCOVERY_VIEW_STATE_INIT,
    DISCOVERY_VIEW_STATE_CONNECT,
    
} DiscoveryViewState_t;

// helper class declaration.
@interface DeviceInfo : NSObject
{
    WFSensorType_t sensorType;
    WFDeviceParams* devParams;
}

@property (nonatomic, assign) WFSensorType_t sensorType;
@property (nonatomic, retain) WFDeviceParams* devParams;

@end




@interface DeviceDiscoveryVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    WFSensorType_t sensorType;
    WFHardwareConnector* hardwareConnector;
    
    UILabel* sensorTypeLabel;
    UILabel* networksLabel;
    UITableView* discoveredTable;
    
    NSMutableArray* discoveredSensors;
    UCHAR ucDiscoveryCount;
    DiscoveryViewState_t state;
    
    DeviceInfo* selectedDevice;
}


@property (nonatomic, assign) WFSensorType_t sensorType;

@property (nonatomic, retain) IBOutlet UILabel* sensorTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel* networksLabel;
@property (nonatomic, retain) IBOutlet UITableView* discoveredTable;

@end
