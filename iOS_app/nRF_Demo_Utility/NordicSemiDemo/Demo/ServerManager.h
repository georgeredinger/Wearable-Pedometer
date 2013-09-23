//
//  ServerManager.h
//  ProximityApp
//
//  Copyright (c) 2012 Nordic Semiconductor. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>

@interface ServerManager : NSObject <CBPeripheralManagerDelegate>
@property (retain) AVAudioPlayer *player;


+ (ServerManager*) sharedInstance;

- (void) startPlayingAlarmSound;
- (void) stopPlayingAlarmSound;

@end
