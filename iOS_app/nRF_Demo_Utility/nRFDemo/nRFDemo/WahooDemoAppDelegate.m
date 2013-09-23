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
//  WahooDemoAppDelegate.m
//  WahooDemo
//
//  Created by Michael Moore on 9/1/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import "WahooDemoAppDelegate.h"


@interface WahooDemoAppDelegate (_PRIVATE_)

- (void)copyPlistToDocs;

@end



@implementation WahooDemoAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;


#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [_window release];
    [_navigationController release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark UIApplicationDelegate Implementation

//--------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:didFinishLaunchingWithOptions");

    /*
    // re-route console logs to a file in the temp folder.
	NSString* logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"console.log"];
    // comment this line to persist log - uncommenting will clear log when app starts.
	[[NSFileManager defaultManager] removeItemAtPath:logPath error:NULL];
	freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    */

    // copy the sensor data file if necessary.
    [self copyPlistToDocs];
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
	// disable sleep mode.
	application.idleTimerDisabled = TRUE;
	
    // configure the hardware connector.
    hardwareConnector = [WFHardwareConnector sharedConnector];
    hardwareConnector.delegate = self;
	hardwareConnector.sampleRate = 0.5;  // sample rate 500 ms, or 2 Hz.
    //
    // determine support for BTLE.
    if ( hardwareConnector.hasBTLESupport )
    {
        // enable BTLE.
        [hardwareConnector enableBTLE:TRUE];
    }
    NSLog(@"%@", hardwareConnector.hasBTLESupport?@"DEVICE HAS BTLE SUPPORT":@"DEVICE DOES NOT HAVE BTLE SUPPORT");
    
    // set HW Connector to call hasData only when new data is available.
    [hardwareConnector setSampleTimerDataCheck:YES];
    
    return YES;
}

//--------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

//--------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

//--------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

//--------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
     NSLog(@"applicationDidBecomeActive");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

//--------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
     NSLog(@"applicationWillTerminate");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark HardwareConnectorDelegate Implementation

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector connectedSensor:(WFSensorConnection*)connectionInfo
{
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector didDiscoverDevices:(NSSet*)connectionParams searchCompleted:(BOOL)bCompleted
{
    // post the sensor type and device params to the notification.
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                         connectionParams, @"connectionParams",
                         [NSNumber numberWithBool:bCompleted], @"searchCompleted",
                         nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_DISCOVERED_SENSOR object:nil userInfo:userInfo];
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector disconnectedSensor:(WFSensorConnection*)connectionInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_DISCONNECTED object:nil];
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector stateChanged:(WFHardwareConnectorState_t)currentState
{
	BOOL connected = ((currentState & WF_HWCONN_STATE_ACTIVE) || (currentState & WF_HWCONN_STATE_BT40_ENABLED)) ? TRUE : FALSE;
	if (connected)
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_HW_CONNECTED object:nil];
	}
	else
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
	}
}

//--------------------------------------------------------------------------------
- (void)hardwareConnectorHasData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_HAS_DATA object:nil];
}


#pragma mark -
#pragma mark WahooDemoAppDelegate Implementation

#pragma mark Private Methods

//--------------------------------------------------------------------------------
- (void)copyPlistToDocs
{
	// First, test for existence - we don’t want to wipe out a user’s DB
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
	
	// for debugging, uncomment this line to overwrite existing copy.
	// DEBUG:  overwrite existing settings file.
	//[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
	
	if ( ![fileManager fileExistsAtPath:filePath] )
	{
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *templatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
		
		NSError* error;
		
		BOOL success = [fileManager copyItemAtPath:templatePath toPath:filePath error:&error];
		
		if (!success)
        {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
}


@end




