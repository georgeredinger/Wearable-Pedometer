//
//  WFFitMesgHRMProfile.h
//  WFConnector
//
//  Created by Michael Moore on 6/3/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents the HRM (Heart Rate Monitor) Profile record from a FIT file.
 */
@interface WFFitMesgHRMProfile : NSObject
{
	/** \cond InterfaceDocs */
    
	FIT_HRM_PROFILE_MESG stHRMProfile;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_HRM_PROFILE_MESG</c> structure containing the data
 * for this record.
 */
@property (nonatomic, readonly) FIT_HRM_PROFILE_MESG* pstHRMProfile;


/**
 * Initializes the WFFitMesgHRMProfile with the contents of the specified FIT record.
 *
 * @param pstRecord A pointer to the FIT record used to initialize this instance.
 *
 * @return This WFFitMesgHRMProfile instance.
 */
- (id)initWithRecord:(void*)pstRecord;

@end
