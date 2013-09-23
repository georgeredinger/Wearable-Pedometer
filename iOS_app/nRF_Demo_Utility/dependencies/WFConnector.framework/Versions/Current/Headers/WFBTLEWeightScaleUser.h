//
//  WFBTLEWeightScaleUser.h
//  WFConnector
//
//  Created by Ben Johnston on 7/3/12.
//  Copyright 2012 Wahoo Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>




/**
 * Represents a User Profile for the Wahoo Fitness BTLE Weight Scale.
 *
 * The user profile is stored on the scale and used to attribute weight readings
 * to individuals, compare weight readings to users' goals, and calculate BMI.
 */
@interface WFBTLEWeightScaleUser : NSObject
{
	/** \cond InterfaceDocs */
	
	int _user_id;
    char _c_initial_left;
    char _c_initial_middle;
    char _c_initial_right;
    float _user_range_min_weight_kg;
    float _user_range_max_weight_kg;
    float _user_goal_weight_kg;
    float _tolerance_kg;
    int _height_in_cm;
	
	/** \endcond */
    
}


/** 
 * User ID number (assigned by the scale). Call requestUserId on the weight scale connection
 * and use the value returned for this user id.
 */
@property (nonatomic, assign) int user_id;

/** 
 * First (left) initial of user initials to be displayed on the scale. 
 * Will only be shown on the scale if alphanumeric, using the ISO basic Latin alphabet
 * or a digit from 0 to 9. 
 * Will automatically be set to upper case on the scale.
 */
@property (nonatomic, assign) char c_initial_left;

/** 
 * Second (middle) initial of user initials to be displayed on the scale. 
 * Will only be shown on the scale if alphanumeric, using the ISO basic Latin alphabet 
 * or a digit from 0 to 9. 
 * Will automatically be set to upper case on the scale.
 */
@property (nonatomic, assign) char c_initial_middle;

/** 
 * Last (right) initial of user name to be displayed on the scale.
 * Will only be shown on the scale if alphanumeric, using the ISO basic Latin alphabet 
 * or a digit from 0 to 9. 
 * Will automatically be set to upper case on the scale.
 */
@property (nonatomic, assign) char c_initial_right;

/** 
 * Lower end of the weight range used by the scale to identify the user. 
 * Must be a positive number. Must not overlap with any other user.
 * Must be less than user_range_max_weight_kg.
 */
@property (nonatomic, assign) float user_range_min_weight_kg;

/** 
 * Upper end of the weight range used by the scale to identify the user. 
 * Must be a positive number. Must not overlap with any other user. 
 * Must be greater than user_range_min_weight_kg.
 */
@property (nonatomic, assign) float user_range_max_weight_kg;

/** 
 * User's goal weight in kilograms. Must be 0 or a positive number.  
 * If 0, no happy, sad, or neutral face will be shown on the scale.
 */
@property (nonatomic, assign) float user_goal_weight_kg;

/** 
 * Tolerance value (in kg) used as a threshold by the scale to ignore weight gain/loss. 
 * Used with goal weight and user's previous weight in determining if happy, sad or neutral face 
 * is shown on the scale. Must be 0 or a positive number. 
 * If 0, every difference between the user's current weight reading and previous weight reading
 * will be counted as a gain or loss. If greater than 0, any difference between the user's current 
 * weight reading and the previous weight reading that is less than the tolerance value will 
 * be considered as neither a gain nor a loss.
 */
@property (nonatomic, assign) float tolerance_kg;

/** 
 * User's height in cm. 
 * Must be 0 or a positive number.  If 0, no BMI will be shown on the scale.
 */
@property (nonatomic, assign) int height_in_cm;


/**
 * Initialises a user record of type WFBTLEWeightScaleUser and returns it.
 * If there are anyinconsistencies with the input data (max < min, weights below zero etc) 
 * then method will return nil.
 *
 * @param initials An NSString containing 3 initials.  Will be trimmed/padded and
 * capitalised if it is not done so already.
 *
 * @param minWeightKg The low end of the user's weight range, in kg.
 *
 * @param maxWeightKg The upper end of the user's weight range, in kg.
 *
 * @param heightCm user's height in cm
 *
 * @param goalWeightKg user's goal weight in kg
 *
 * @param toleranceKg threshold for the scale to recognise a weight loss or gain.  e.g if
 * tolerance is 0.1kg, user must lose > 0.1kg for scale to display smiley face
 *
 * @return An instance of <c>WFBTLEWeightScaleUser</c> if the data is valid, otherwise <c>nil</c>
 */

+(WFBTLEWeightScaleUser*)userRecordWithInitials:(NSString *)initials
                                      minWeight:(float)minWeightKg
                                      maxWeight:(float)maxWeightKg
                                         height:(float)heightCm
                                     goalWeight:(float)goalWeightKg
                              gainLossTolerance:(float)toleranceKg;


@end
