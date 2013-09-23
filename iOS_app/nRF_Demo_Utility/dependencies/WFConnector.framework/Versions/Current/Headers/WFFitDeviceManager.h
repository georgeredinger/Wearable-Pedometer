//
//  WFFitDeviceManager.h
//  WFConnector
//
//  Created by Michael Moore on 6/7/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFileManager.h>

@class WFFitActivityFileData;


///////////////////////////////////////////////////////////////////////////////
//
// WFFitDeviceManager Interface Declaration.
//

/**
 * Provides a means of communicating with, and transferring data from an
 * ANT FS fitness device.
 */
@interface WFFitDeviceManager : WFAntFileManager
{
}


/**
 * Parses the FIT file at the specified path and returns the contents in a
 * WFFitActivityFileData instance.
 *
 * @param filePath The path of the FIT file to be parsed.
 *
 * @param pbCancel A pointer to a <c>BOOL</c> value indicating whether the parsing
 * operation should be cancelled.  The parsing operation can take quite a while if
 * the FIT file is large.  Setting the underlying value at the pointer location to
 * <c>TRUE</c> while the parsing is in progress will cause the parsing to be
 * cancelled (this would need to be done from a thread other than the one on which
 * this method was invoked).  <b>This parameter may not be <c>NULL</c></b>.
 *
 * @return The contents of the FIT file represented as a WFFitActivityFileData
 * instance.
 */
- (WFFitActivityFileData*)getFitActivityFromFile:(NSString*)filePath cancelPointer:(volatile BOOL*)pbCancel;

@end
