//
//  WFPedometerManager.h
//  WFConnector
//
//  Created by Michael Moore on 9/13/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFileManager.h>


///////////////////////////////////////////////////////////////////////////////
//
// WFPedometerManager Interface Declaration.
//

/**
 * Provides a means of communicating with, and transferring data from a
 * A&D Pedometer Profile ANT FS device.
 */
@interface WFPedometerManager : WFAntFileManager
{
}


/**
 * Parses the file data downloaded from the pedometer.
 *
 * @param filePath The path to the downloaded file.
 *
 * @return A WFANDPedometerFile_t structure containing the parsed file data.
 */
- (WFANDPedometerFile_t)parsePedometerFile:(NSString*)filePath;

@end
