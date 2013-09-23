//
//  WFFitMessageEvent.h  (previously WFFitEventRecord.h)
//  WFConnector
//
//  Created by Michael Moore on 4/11/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMessageBase.h>
#import <WFConnector/fit_sdk.h>


/**
 * Represents an event record from a fitness device FIT file.
 */
@interface WFFitMessageEvent : WFFitMessageBase
{
	/** \cond InterfaceDocs */
    
	FIT_EVENT_MESG stEvent;
    
	/** \endcond */
}


/**
 * Gets a pointer to a <c>FIT_EVENT_MESG</c> structure containing the data for this
 * record.
 */
@property (nonatomic, readonly) FIT_EVENT_MESG* pstEvent;

@end
