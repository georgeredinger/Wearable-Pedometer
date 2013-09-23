//
//  WFGarminFitWatch.h
//  WFConnector
//
//  Created by Michael Moore on 5/9/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitDeviceManager.h>


///////////////////////////////////////////////////////////////////////////////
//
// ANT+ type definitions.
//
#define GARMIN_MANUFACTURER_ID               ((USHORT) 0x0001)

#define FR60_DEVICE_TYPE                     ((USHORT) 0x03DC)   // decimal 988
#define FR310_DEVICE_TYPE                    ((USHORT) 0x03FA)   // decimal 1018
#define FR610_DEVICE_TYPE                    ((USHORT) 0x0541)   // decimal 1345
#define FR910XT_DEVICE_TYPE                  ((USHORT) 0x0530)   // decimal 1328

 


///////////////////////////////////////////////////////////////////////////////
//
// WFGarminFitWatch Interface Declaration.
//

/**
 * Provides a means of communicating with, and transferring data from an
 * unspecified model Garmin Fitness Watch.
 */
@interface WFGarminFitWatchManager : WFFitDeviceManager
{
}

@end
