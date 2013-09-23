//
//  ServerManager.m
//  ProximityApp
//
//  Copyright (c) 2012 Nordic Semiconductor. All rights reserved.
//
//

#import "ServerManager.h"

@implementation ServerManager
{
    CBPeripheralManager *pm;
    CBMutableService *immediateAlertService;
    
    UILocalNotification *lastAlarm;
}
@synthesize player;

static ServerManager* sharedServerManager;

+ (CBUUID*) immediateAlertServiceUUID
{
    return [CBUUID UUIDWithString:@"1802"];
}

+ (CBUUID*) immediateAlertCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"2A06"];
}

+ (ServerManager*) sharedInstance
{
    if (sharedServerManager == nil)
    {
        sharedServerManager = [[ServerManager alloc] init];
    }
    return sharedServerManager;
}

- (ServerManager*) init
{
    if ([super init])
    {
        pm = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm-sound" ofType:@"wav"]];
    
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];

    return self;
}

- (void) setupService
{
    CBMutableCharacteristic *c = [[CBMutableCharacteristic alloc] initWithType:ServerManager.immediateAlertCharacteristicUUID properties:CBCharacteristicPropertyWriteWithoutResponse value:nil permissions:CBAttributePermissionsWriteable];
    
    immediateAlertService = [[CBMutableService alloc] initWithType:ServerManager.immediateAlertServiceUUID primary:YES];
    immediateAlertService.characteristics = [NSArray arrayWithObject:c];
    
    [pm removeAllServices];
    [pm addService:immediateAlertService];
}

- (void) startPlayingAlarmSound
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.player.numberOfLoops = -1;
    [player play];
    NSLog(@"Alarm-sound played, is it playing: %d", [player isPlaying]);
}

- (void) stopPlayingAlarmSound
{
    if ([self.player isMemberOfClass:[AVAudioPlayer class]] && self.player.isPlaying)
    {
        [self.player stop];
    }
}

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"Peripheral manager updated state, %d", [pm state]);
    if ([pm state] == CBCentralManagerStatePoweredOn)
    {
        [self setupService];
    }
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Did add peripheral service, with error %@.", error);
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    static UILocalNotification *alarm;
    if (alarm != nil)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:alarm];
    }
    
    NSLog(@"Someone wrote to a characteristic");
    for (CBATTRequest *request in requests)
    {
        if ([[[request characteristic] UUID] isEqual:ServerManager.immediateAlertCharacteristicUUID])
        {
            NSUInteger alertValue = *(NSUInteger*) [[request value] bytes];

            if (alertValue > 0)
            {
                [self startPlayingAlarmSound];

                alarm = [[UILocalNotification alloc] init];
                alarm.alertBody = [NSString stringWithFormat:@"A tag wants to find your phone."];
                alarm.alertAction = @"OK";
                
                [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
            }
            else
            {
                [self stopPlayingAlarmSound];
            }
        }
    }
}

@end
