//
//  WFFitSettingsFileData.h
//  WFConnector
//
//  Created by Michael Moore on 6/3/11.
//  Copyright 2011 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFConnector/WFFitMesgFileId.h>
#import <WFConnector/WFFitMesgDeviceSettings.h>
#import <WFConnector/WFFitMesgUserProfile.h>
#import <WFConnector/WFFitMesgHRMProfile.h>


/**
 * Represents the data from a FIT settings file.
 */
@interface WFFitSettingsFileData : NSObject
{
    WFFitMesgFileId* fileIdMesg;
    WFFitMesgDeviceSettings* deviceSettingsMesg;
    WFFitMesgUserProfile* userProfileMesg;
    WFFitMesgHRMProfile* hrmProfileMesg;
}


/** Gets the File ID data (contains FIT file metadata). */
@property (nonatomic, retain) WFFitMesgFileId* fileIdMesg;
/** Gets the Device settings data. */
@property (nonatomic, retain) WFFitMesgDeviceSettings* deviceSettingsMesg;
/** User profile data. */
@property (nonatomic, retain) WFFitMesgUserProfile* userProfileMesg;
/** Gets the Heart rate monitor profile data. */
@property (nonatomic, retain) WFFitMesgHRMProfile* hrmProfileMesg;

@end
