//
//  WFBloodPressureManager.h
//  WFConnector
//
//  Created by Michael Moore on 6/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFAntFileManager.h>


///////////////////////////////////////////////////////////////////////////////
//
// WFBloodPressureManager Interface Declaration.
//

/**
 * Provides a means of communicating with, and transferring data from a
 * Blood Pressure Profile ANT FS device.
 */
@interface WFBloodPressureManager : WFAntFileManager
{
	/** \cond InterfaceDocs */

	int dataFileIndex;
	
	/** \endcond */
}


/**
 * Erases all records stored on the device.
 *
 * The blood pressure cuff stores a certain number of records (typically 50) in
 * its internal memory.  This method will erase all records.
 *
 * @return <c>TRUE</c> if the erase operation was successful, otherwise <c>FALSE</c>.
 */
- (BOOL)eraseDeviceData;

@end
