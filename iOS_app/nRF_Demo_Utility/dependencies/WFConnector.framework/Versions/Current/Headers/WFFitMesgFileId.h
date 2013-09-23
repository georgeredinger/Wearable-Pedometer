//
//  WFFitMesgFileId.h
//  WFConnector
//
//  Created by Michael Moore on 6/3/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents the File ID record from a FIT file.
 */
@interface WFFitMesgFileId : NSObject
{
	/** \cond InterfaceDocs */
    
	FIT_FILE_ID_MESG stFileId;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_FILE_ID_MESG</c> structure containing the data for
 * this record.
 */
@property (nonatomic, readonly) FIT_FILE_ID_MESG* pstFileId;


/**
 * Initializes the WFFitMesgFileId with the contents of the specified FIT record.
 *
 * @param pstRecord A pointer to the FIT record used to initialize this instance.
 *
 * @return This WFFitMesgFileId instance.
 */
- (id)initWithRecord:(void*)pstRecord;

@end
