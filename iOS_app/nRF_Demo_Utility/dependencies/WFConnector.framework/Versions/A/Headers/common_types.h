/*
 *  common_types.h
 *  WFConnector
 *
 *  Created by Michael Moore on 5/25/10.
 *  Copyright 2010 Wahoo Fitness. All rights reserved.
 *
 */

/////////////////////////////////////////////////////////////////////////////////////////
//
// The code in this file is derived in part from the ANT+ sample code
// provided by Dynastream Inovations Inc.
// 
// Dynastream Innovations Inc.
// 228 River Avenue
// Cochrane, Alberta, Canada
// T4C 2C1
/////////////////////////////////////////////////////////////////////////////////////////

#if !defined(__COMMON_TYPES_H__)
#define __COMMON_TYPES_H__


#if !defined(LITTLE_ENDIAN)
#define LITTLE_ENDIAN
#endif


//////////////////////////////////////////////////////////////////////////////////
// Public Definitions
//////////////////////////////////////////////////////////////////////////////////

#if !defined(TRUE)
#define TRUE                           1
#endif

#if !defined(FALSE)
#define FALSE                          0
#endif

#if !defined(NULL)
#define NULL                           ((void *) 0)
#endif

#ifndef MAX_UCHAR
#define MAX_UCHAR                      ((UCHAR) 0xFF)
#endif

#ifndef MAX_SCHAR
#define MAX_SCHAR                      0x7F
#endif

#ifndef MIN_SCHAR
#define MIN_SCHAR                      0x80
#endif


#ifndef MAX_SHORT
#define MAX_SHORT                      0x7FFF
#endif

#ifndef MIN_SHORT
#define MIN_SHORT                      0x8000
#endif

#ifndef MAX_USHORT
#define MAX_USHORT                     0xFFFF
#endif

#ifndef MAX_SSHORT
#define MAX_SSHORT                     0x7FFF
#endif

#ifndef MIN_SSHORT
#define MIN_SSHORT                     0x8000
#endif

#ifndef MAX_LONG
#define MAX_LONG                       0x7FFFFFFF
#endif

#ifndef MIN_LONG
#define MIN_LONG                       0x80000000
#endif

#ifndef MAX_ULONG
#define MAX_ULONG                      0xFFFFFFFF
#endif

#ifndef MAX_SLONG
#define MAX_SLONG                      0x7FFFFFFF
#endif

#ifndef MIN_SLONG
#define MIN_SLONG                      0x80000000
#endif


#ifndef OBJC_BOOL_DEFINED
typedef unsigned char                  BOOL;
#endif

#ifndef _UCHAR_T
#define _UCHAR_T
typedef unsigned char                  UCHAR;
#endif /* _UCHAR_T */

#ifndef _BYTE_T
#define _BYTE_T
typedef unsigned char                  BYTE;
#endif /* _BYTE_T */

#ifndef _SCHAR_T
#define _SCHAR_T
typedef signed char                    SCHAR;
#endif /* _SCHAR_T */

#ifndef _SHORT_T
#define _SHORT_T
typedef short                          SHORT;
#endif /* _SHORT_T */

#ifndef _USHORT_T
#define _USHORT_T
typedef unsigned short                 USHORT;
#endif /* _USHORT_T */

#ifndef _SSHORT_T
#define _SSHORT_T
typedef signed short                   SSHORT;
#endif /* _SSHORT_T */

#ifndef _LONG_T
#define _LONG_T
typedef long                           LONG;
#endif /* _LONG_T */

#ifndef _ULONG_T
#define _ULONG_T
typedef unsigned long                  ULONG;
#endif /* _ULONG_T */

#ifndef _SLONG_T
#define _SLONG_T
typedef signed long                    SLONG;
#endif /* _SLONG_T */

#ifndef _UINT64_T
#define _UINT64_T
typedef unsigned long long             UINT64;
#endif /* _UINT64_T */

#ifndef _SINT64_T
#define _SINT64_T
typedef signed long long               SINT64;
#endif /* _SINT64_T */

#ifndef _FLOAT_T
#define _FLOAT_T
typedef float                          FLOAT;
#endif /* _FLOAT_T */

#ifndef _DOUBLE_T
#define _DOUBLE_T
typedef double                         DOUBLE;
#endif /* _DOUBLE_T */


#ifndef _USHORT_UNION_T
#define _USHORT_UNION_T
typedef union
{
	USHORT usData;
	struct
	{
#if defined(LITTLE_ENDIAN)
		UCHAR ucLow;
		UCHAR ucHigh;
#elif defined(BIG_ENDIAN)
		UCHAR ucHigh;
		UCHAR ucLow;
#else
#error
#endif
	} stBytes;
} USHORT_UNION;
#endif // _USHORT_UNION_T


#ifndef _ULONG_UNION_T
#define _ULONG_UNION_T
typedef union
{
	ULONG ulData;
	UCHAR aucBytes[4];
	struct
	{
		// The least significant byte of the ULONG in this structure is
		// referenced by ucByte0.
		UCHAR ucByte0;
		UCHAR ucByte1;
		UCHAR ucByte2;
		UCHAR ucByte3;
	} stBytes;
} ULONG_UNION;
#endif // _ULONG_UNION_T


// The following macro computes offset (in bytes) of a member in a structure.  This compiles to a constant.
#define STRUCT_OFFSET(MEMBER, STRUCT_POINTER) ( ((UCHAR *) &((STRUCT_POINTER) -> MEMBER)) - ((UCHAR *) (STRUCT_POINTER)) )

#endif // !defined(__COMMON_TYPES_H__)
