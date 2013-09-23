//
//  WFFitMessageWeightScale.h  (previously WFWeightScaleFitRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 6/10/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents a single record in a Weight Scale Profile FIT file.
 */
@interface WFFitMessageWeightScale : WFFitMessageBase
{
	/** \cond InterfaceDocs */

    FIT_WEIGHT_SCALE_MESG stWeightScale;
	
	/** \endcond */
}


/**
 * Gets a pointer to the <c>FIT_WEIGHT_SCALE_MESG</c> structure containing the
 * data for this record.
 */
@property (nonatomic, readonly) FIT_WEIGHT_SCALE_MESG* pstWeightScale;

/**
 * Gets or sets the weight in kilograms.
 *
 * @note <c>-1</c> indicates an invalid value.
 */
@property (nonatomic, readonly) double weight;

@end
