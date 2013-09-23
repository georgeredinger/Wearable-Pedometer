// Copyright (c) 2011 Nordic Semiconductor. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA.
// Terms and conditions of usage are described in detail in // NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
//
//
//  NordicSemiAppDelegate.m
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/1/11.
//

#import "NordicSemiAppDelegate.h"
#import "ServerManager.h"

#import <AudioToolbox/AudioToolbox.h>

#define KEY_DEVICE_PASSKEYS                 @"DevicePasskeys"
#define KEY_GARMIN_WATCH                    @"GarminWatch"
#define KEY_GARMIN_FR60                     @"GarminFR60"
#define KEY_GARMIN_FR310                    @"GarminFR310"
#define KEY_GARMIN_FR405                    @"GarminFR405"
#define KEY_GARMIN_FR610                    @"GarminFR610"

@implementation NordicSemiAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize wildcardSwitches, proximitySwitches, rootBg, allowMultitask, proximityAlertThreshold, proximityAlertLevel;
@synthesize cgmPlotData, hrmPlotData, initialCGMTime, initialHRMTime;

#pragma mark -
#pragma mark NSObject Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [wildcardSwitches release];
    [proximitySwitches release];
    [cgmPlotData release];
    [initialCGMTime release];
    [hrmPlotData release];
    [initialHRMTime release];
    [super dealloc];
}


#pragma mark -
#pragma mark UINavigationContollerDelegate Implementation
- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(willAppearIn:)])
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}

#pragma mark -
#pragma mark UIApplicationDelegate Implementation

//--------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:didFinishLaunchingWithOptions");
    
    [ServerManager sharedInstance];
    
    sensorSettings = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    wildcardSwitches = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    proximitySwitches = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    proximityAlertThreshold = WF_PROXIMITY_ALERT_THRESHOLD_2;
    proximityAlertLevel = WF_BTLE_CH_ALERT_LEVEL_HIGH;
    
    // copy the sensor info file.
	[self copyPlistToDocs];
    cgmPlotData = [[NSMutableArray arrayWithCapacity:600] retain];
    hrmPlotData = [[NSMutableArray arrayWithCapacity:600] retain];
    
  //  [self generateData]; // for plot testing
    /*
    // re-route console logs to a file in the temp folder.
	NSString* logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"console.log"];
    // comment this line to persist log - uncommenting will clear log when app starts.
	//[[NSFileManager defaultManager] removeItemAtPath:logPath error:NULL];
	freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    */
    
    navigationController.delegate = self;
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
    hardwareConnector.settings.useMetricUnits = YES;
    
    // determine support for BTLE.
    if ( hardwareConnector.hasBTLESupport )
    {
        // enable BTLE.
        [hardwareConnector enableBTLE:TRUE inBondingMode:YES];
    }
    NSLog(@"%@", hardwareConnector.hasBTLESupport?@"DEVICE HAS BTLE SUPPORT":@"DEVICE DOES NOT HAVE BTLE SUPPORT");
    
    // set HW Connector to call hasData only when new data is available.
    [hardwareConnector setSampleTimerDataCheck:YES];
    
    self.allowMultitask = YES;
	
    UIImage* defaultImage = [UIImage imageNamed:@"Default.png"];
	splashView = [[UIImageView alloc] initWithImage:defaultImage];
    splashView.frame = CGRectMake(0, 20, 320, 460);
	[self.window.rootViewController.view addSubview:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
    CGRect r = [splashView frame];
    [splashView setFrame:r];
	[UIView commitAnimations];
    
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
    if (!allowMultitask) {
        [[WFHardwareConnector sharedConnector] resetConnections];
        exit(0);
    }
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    static UIAlertView *view;
    
    if (view != nil)
    {
        [view dismissWithClickedButtonIndex:0 animated:NO];
    }
    
    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) 
    {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    
    view = [[UIAlertView alloc] initWithTitle:@"nRF Utility" message:[notification alertBody] delegate:self cancelButtonTitle:nil otherButtonTitles:[notification alertAction], nil];
    [view show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[ServerManager sharedInstance] stopPlayingAlarmSound];
}



- (void)animateRootBg:(BOOL)left 
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:rootBg cache:YES];
	[UIView setAnimationDelegate:self]; 
    CGRect r = [rootBg frame];
    if (left) {
        r.origin.x = -320.0f;
        [UIView setAnimationDuration:0.4];
    } else {
        r.origin.x = 0.0f;
        [UIView setAnimationDuration:0.35];
    }
    [rootBg setFrame:r];
	[UIView commitAnimations];
}


//--------------------------------------------------------------------------------
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    	[splashView removeFromSuperview];
    	[splashView release];
       splashView = nil;
}

#pragma mark -
#pragma mark HardwareConnectorDelegate Implementation

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector connectedSensor:(WFSensorConnection*)connectionInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_CONNECTED object:nil];
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
  //  NSLog(@"tick");
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_HAS_DATA object:nil];
}


#pragma mark Device Passkeys

//--------------------------------------------------------------------------------
- (NSString*)getPasskey:(WFAntFSDeviceType_t)deviceType
{
    NSString* retVal = nil;
	
    // get the passkey settings.
    NSMutableDictionary* passkeys = (NSMutableDictionary*)[sensorSettings objectForKey:KEY_DEVICE_PASSKEYS];
    NSLog(@"passkeys: %@", passkeys.description);
	// get the key for the FIT device type.
	NSString* key = nil;
	switch (deviceType)
	{
		case WF_ANTFS_DEVTYPE_GARMIN_WATCH:
			key = KEY_GARMIN_WATCH;
            break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR60:
			key = KEY_GARMIN_FR60;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR310:
			key = KEY_GARMIN_FR310;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR405:
			key = KEY_GARMIN_FR405;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR610:
			key = KEY_GARMIN_FR610;
			break;
        default:
			key = KEY_GARMIN_WATCH;
            break;
	}
    
    // continue only if the keys are valid.
    if ( key && passkeys )
    {
        // load the passkey.
        retVal = (NSString*)[passkeys objectForKey:key];
    }
    
	NSLog(@"getting passkey %@", retVal);
    return retVal;
}

//--------------------------------------------------------------------------------
- (BOOL)savePasskey:(NSString*)passkey forDeviceType:(WFAntFSDeviceType_t)deviceType
{
    BOOL retVal = FALSE;
	NSLog(@"saving passkey %@", passkey);
	// get the key for the FIT device type.
	NSString* key = nil;
	switch (deviceType)
	{
		case WF_ANTFS_DEVTYPE_GARMIN_WATCH:
			key = KEY_GARMIN_WATCH;
            break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR60:
			key = KEY_GARMIN_FR60;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR310:
			key = KEY_GARMIN_FR310;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR405:
			key = KEY_GARMIN_FR405;
			break;
		case WF_ANTFS_DEVTYPE_GARMIN_FR610:
			key = KEY_GARMIN_FR610;
			break;
        default:
			key = KEY_GARMIN_WATCH;
            break;
	}
    
    // continue only if the key is valid.
    if ( key )
    {
        retVal = TRUE;
        
        // get the passkey settings.
        NSMutableDictionary* passkeys = (NSMutableDictionary*)[sensorSettings objectForKey:KEY_DEVICE_PASSKEYS];
        
        // create passkey settings, if they don't exist.
        if ( !passkeys )
        {
            passkeys = [NSMutableDictionary dictionaryWithCapacity:1];
            [sensorSettings setObject:passkeys forKey:KEY_DEVICE_PASSKEYS];
        }
        
        // set the passkey.
        [passkeys setObject:passkey forKey:key];
        
        // save the settings (In a plist perhaps)
      //  [self saveSettings];
    }
    
    return retVal;
}

#pragma mark -
#pragma mark NordicSemiAppDelegate Implementation

//--------------------------------------------------------------------------------
- (void)copyPlistToDocs
{
	// First, test for existence - we don’t want to wipe out a user’s DB
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"sensor-info.plist"];
	NSString *filePathCGM = [documentsDirectory stringByAppendingPathComponent:@"cgm-settings.plist"];
	
	// for debugging, uncomment this line to overwrite existing copy.
	// DEBUG:  overwrite existing settings file.
	//[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disclaimer:" message:@"This application is only for demonstration purposes and not for medical use."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
	if ( ![fileManager fileExistsAtPath:filePath] )
	{
       
        
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *templatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"fs-sensor-info.plist"];
		
		NSError* error;
		
		BOOL success = [fileManager copyItemAtPath:templatePath toPath:filePath error:&error];
		
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
    if ( ![fileManager fileExistsAtPath:filePathCGM] )
	{
        
        
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *templatePathCGM = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cgmsettings.plist"];
		
		NSError* errorCGM;
		
		BOOL successCGM = [fileManager copyItemAtPath:templatePathCGM toPath:filePathCGM error:&errorCGM];
		
		if (!successCGM) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [errorCGM localizedDescription]);
		}
	}
}

-(void)generateData
{
    double timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
    for ( NSUInteger i = 0; i < 800; i++ ) {
        id x = [NSNumber numberWithDouble:timestamp+i];
        id y = [NSNumber numberWithInt:i];
        [self storeGGMPlot:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"timestamp", y, @"concentration", nil]];
    }
	
}
-(void)storeGGMPlot:(NSDictionary*)point {
    NSNumber * newTimestamp = [NSNumber numberWithDouble:[[point objectForKey:@"timestamp"] doubleValue]];
    [initialCGMTime release];
    initialCGMTime = [newTimestamp retain];
    [cgmPlotData insertObject:point atIndex:0];
    int ct = [cgmPlotData count];
    if (ct < 2) return;
    int fromEnd = 1;
    BOOL hasPtOutOfRange = NO;
    NSDictionary *pt = [cgmPlotData objectAtIndex:ct - fromEnd];
    NSNumber * timeAtIndex = [pt objectForKey:@"timestamp"];
    int outOfRangeCt = 0;
    while ([newTimestamp doubleValue] - [timeAtIndex doubleValue] > 600 && fromEnd < ct - 1) {
        hasPtOutOfRange = YES;
        outOfRangeCt++;
        fromEnd++;
        pt = [cgmPlotData objectAtIndex:ct - fromEnd];
        timeAtIndex = [pt objectForKey:@"timestamp"];
    }
    if (hasPtOutOfRange) {
        for (int i = 0; i < outOfRangeCt; i++) {
            [cgmPlotData removeLastObject];
        }
    }
}

-(void)storeHRMPlot:(NSDictionary*)point {
    NSNumber * newTimestamp = [NSNumber numberWithDouble:[[point objectForKey:@"timestamp"] doubleValue]];
    [initialHRMTime release];
    initialHRMTime = [newTimestamp retain];
    [hrmPlotData insertObject:point atIndex:0];
    int ct = [hrmPlotData count];
    if (ct < 2) return;
    int fromEnd = 1;
    BOOL hasPtOutOfRange = NO;
    NSDictionary *pt = [hrmPlotData objectAtIndex:ct - fromEnd];
    NSNumber * timeAtIndex = [pt objectForKey:@"timestamp"];
    int outOfRangeCt = 0;
    while ([newTimestamp doubleValue] - [timeAtIndex doubleValue] > 600 && fromEnd < ct - 1) {
        hasPtOutOfRange = YES;
        outOfRangeCt++;
        fromEnd++;
        pt = [hrmPlotData objectAtIndex:ct - fromEnd];
        timeAtIndex = [pt objectForKey:@"timestamp"];
    }
    if (hasPtOutOfRange) {
        for (int i = 0; i < outOfRangeCt; i++) {
            [hrmPlotData removeLastObject];
        }
        
    }
}

@end




