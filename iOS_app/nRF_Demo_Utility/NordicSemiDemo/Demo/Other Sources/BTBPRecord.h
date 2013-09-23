//
//  BTBPRecord.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTBPRecord : NSObject
{
    NSDate* timestamp;
    float systolic;
    float diastolic;
    float heartRate;
    float meanArterialPressure;
    
}

@property (nonatomic, retain) NSDate* timestamp;
@property float systolic;
@property float diastolic;
@property float heartRate;
@property float meanArterialPressure;

@end
