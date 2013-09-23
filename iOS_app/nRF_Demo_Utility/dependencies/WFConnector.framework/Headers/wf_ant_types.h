/*
 *  wf_ant_types.h
 *  WFConnector
 *
 *  Created by Michael Moore on 3/30/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

#ifndef __WF_ANT_TYPES_H__
#define __WF_ANT_TYPES_H__

#include <WFConnector/common_types.h>


/** The maximum size of a complete ANT message. */
#define MAX_ANT_MESSAGE_SIZE  16
/** The maximum possible number of ANT channels. */
#define MAX_ANT_CHANNELS      8


/**
 * Describes a message sent or received on an ANT network.
 */
typedef struct
{
	/**
	 * The size of the message, not including the size byte or the messageId
	 * byte.
	 */
	UCHAR messageSize;
	/** The message ID. */
	UCHAR messageId;
	/** Message data byte 1 (typically the channel number). */
	UCHAR data1;
	/** Message data byte 2. */
	UCHAR data2;
	/** Message data byte 3. */
	UCHAR data3;
	/** Message data byte 4. */
	UCHAR data4;
	/** Message data byte 5. */
	UCHAR data5;
	/** Message data byte 6. */
	UCHAR data6;
	/** Message data byte 7. */
	UCHAR data7;
	/** Message data byte 8. */
	UCHAR data8;
	/** Message data byte 8. */
	UCHAR data9;
	/** Message data byte 10 (extended data - FLAG byte). */
	UCHAR data10;
	/** Message data byte 11 (extended data). */
	UCHAR data11;
	/** Message data byte 12 (extended data). */
	UCHAR data12;
	/** Message data byte 13 (extended data). */
	UCHAR data13;
	/** Message data byte 14 (extended data). */
	UCHAR data14;
	
} WFAntMessage;

#endif // __WF_ANT_TYPES_H__
