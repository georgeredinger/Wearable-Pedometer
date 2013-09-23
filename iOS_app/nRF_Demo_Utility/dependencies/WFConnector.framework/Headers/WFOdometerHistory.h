//
//  WFOdometerHistory.h
//  WFConnector
//
//  Created by Michael Moore on 3/29/12.
//  Copyright (c) 2012 Wahoo Fitness. All rights reserved.
//

#import <WFConnector/hardware_connector_types.h>


#define WF_ODOMETER_HISTORY_MAX_SIZE      52
#define WF_ODOMETER_HISTORY_INVALID       -1.0
#define WF_ODOMETER_WHEEL_REVS_INVALID    ((ULONG)0xFFFFFFFF)


/**
 * Represents the odometer history for the Wahoo BlueSC bike speed and cadence
 * sensor (or similar).
 *
 * The Wahoo Fitness BlueSC provides the ability to record odometer history
 * by week for the past year.
 */
@interface WFOdometerHistory : NSObject
{
    ULONG aulHistoryBuffer[WF_ODOMETER_HISTORY_MAX_SIZE];
    
    float bikeWheelCircumference;
    ULONG ulCurrentWheelRevolutions;
}


/**
 * Gets or sets the bike wheel circumference, in meters.
 * 
 * @note The default value is 2.07 m (207 cm), or whatever value is set in the
 * WFConnectorSettings::bikeWheelCircumference property.
 */
@property (nonatomic, assign) float bikeWheelCircumference;
/** Gets the current total wheel revolutions for the device. */
@property (nonatomic, assign) ULONG ulCurrentWheelRevolutions;


/**
 * Returns the distance traveled during the specified week.
 *
 * @param ucWeek The number for which to get the odometer reading.  The current
 * week is <c>0</c>, the previous week is <c>1</c>, the week before that is
 * <c>2</c>, etc.  The earliest week possible is ::WF_ODOMETER_HISTORY_MAX_SIZE.
 *
 * @return The odometer distance traveled during the specified week.  For the
 * earliest available week, this will be the distance traveled up to and including
 * that week.  For the current week, this will be the distance traveled this
 * week, up till now.  If an invalid week is specified, or if there is no
 * history for that week, the return will be ::WF_ODOMETER_HISTORY_INVALID.
 */
- (float)getDistanceForWeek:(UCHAR)ucWeek;

/**
 * Returns the odometer reading as of the end of the specified week.
 *
 * @param ucWeek The number for which to get the odometer reading.  The current
 * week is <c>0</c>, the previous week is <c>1</c>, the week before that is
 * <c>2</c>, etc.  The earliest week possible is ::WF_ODOMETER_HISTORY_MAX_SIZE.
 *
 * @return The odometer reading as of the end of the specified week.  If an
 * invalid week is specified, or if there is no history for that week, the
 * return will be ::WF_ODOMETER_HISTORY_INVALID.
 */
- (float)getOdometerForWeek:(UCHAR)ucWeek;

/**
 * Returns the raw wheel revolutions as of the end of the specified week.
 *
 * @param ucWeek The number for which to get the wheel revolutions.  The current
 * week is <c>0</c>, the previous week is <c>1</c>, the week before that is
 * <c>2</c>, etc.  The earliest week possible is ::WF_ODOMETER_HISTORY_MAX_SIZE.
 *
 * @return The cumulative wheel revolutions as of the end of the specified week.
 * If an invalid week is specified, or if there is no history for that week, the
 * return will be ::WF_ODOMETER_WHEEL_REVS_INVALID.
 */
- (ULONG)getWheelRevolutionsForWeek:(UCHAR)ucWeek;


/** \cond InterfaceDocs */
/**
 * Returns a pointer to the history buffer.
 *
 * @note This method is for internal use.
 *
 * @return A pointer to the history buffer.
 */
- (ULONG*)historyBufferPtr;
/**
 * Clears the history buffer.
 *
 * @note This method is for internal use.
 */
- (void)clearHistoryBuffer;
/** \endcond */


@end
