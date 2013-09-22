/* Copyright (c) 2009 Nordic Semiconductor. All Rights Reserved.
 *
 * The information contained herein is property of Nordic Semiconductor ASA.
 * Terms and conditions of usage are described in detail in NORDIC
 * SEMICONDUCTOR STANDARD SOFTWARE LICENSE AGREEMENT.
 *
 * Licensees are granted free, non-transferable use of the information. NO
 * WARRANTY of ANY KIND is provided. This heading must NOT be removed from
 * the file.
 *
 */


#ifndef __SYSTEM_NRF51_H
#define __SYSTEM_NRF51_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#define __XTAL              (16000000UL)    /* Oscillator frequency */

extern uint32_t SystemCoreClock;    /*!< System Clock Frequency (Core Clock)  */

extern void SystemInit (void);

extern void SystemCoreClockUpdate (void);

#ifdef __cplusplus
}
#endif

#endif
