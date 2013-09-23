//
//  WFFitMesgUserProfile.h
//  WFConnector
//
//  Created by Michael Moore on 6/3/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents the User Profile record from a FIT file.
 */
@interface WFFitMesgUserProfile : NSObject
{
	/** \cond InterfaceDocs */
    
	FIT_USER_PROFILE_MESG stUserProfile;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_USER_PROFILE_MESG</c> structure containing the
 * data for this record.
 */
@property (nonatomic, readonly) FIT_USER_PROFILE_MESG* pstUserProfile;


/**
 * Initializes the WFFitMesgUserProfile with the contents of the specified FIT record.
 *
 * @param pstRecord A pointer to the FIT record used to initialize this instance.
 *
 * @return This WFFitMesgUserProfile instance.
 */
- (id)initWithRecord:(void*)pstRecord;

@end
