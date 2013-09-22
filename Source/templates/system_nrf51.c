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


/**
A template file for system_device.c is provided by ARM but adapted by the
silicon vendor to match their actual device. As a minimum requirement this file
must provide a device specific system configuration function and a global
variable that contains the system frequency. It configures the device and
initializes typically the oscillator (PLL) that is part of the microcontroller
device.
*/

#include <stdint.h>
#include <stdbool.h>
#include "nrf.h"
#include "system_nrf51.h"

/*lint ++flb "Enter library region" */

#define __SYSTEM_CLOCK      (__XTAL)

static bool is_manual_peripheral_setup_needed (void); 
static bool is_output_31_setup_needed (void); 

/**
  System Core Clock Frequency (Core Clock).

  Contains the system core clock which is the system clock frequency supplied
  to the SysTick timer and the processor core clock. This variable can be used
  by the user application to setup the SysTick timer or configure other
  parameters. It may also be used by debugger to query the frequency of the
  debug timer or configure the trace clock speed. SystemCoreClock is
  initialized with a correct predefined value.

  The compiler must be configured to avoid the removal of this variable in case
  that the application program is not using it. It is important for debug
  systems that the variable is physically present in memory so that it can be
  examined to configure the debugger.
*/
uint32_t SystemCoreClock = __SYSTEM_CLOCK;

/**
  Sets up the microcontroller system.

  Typically this function configures the oscillator (PLL) that is part of the
  microcontroller device. For systems with variable clock speed it also updates
  the variable SystemCoreClock. SystemInit is called from startup_device file
  before entering main() function.
*/
void SystemInit (void)
{
    /* If desired, switch off the unused RAM to lower consumption by the use of RAMON register */

    /* Prepare the peripherals for use as indicated by the PAN 27 "System: Manual setup is required
       to enable the use of peripherals" found at Product Anomaly document version 1.6 found at
       https://www.nordicsemi.com/eng/Products/Bluetooth-R-low-energy/nRF51822/PAN-028. The side 
       effect of executing these instructions in the devices that do not need it is that the new 
       peripherals in the second generation devices (LPCOMP) will not be available. */
    if (is_manual_peripheral_setup_needed())
    {
        *(uint32_t *)0x40000504 = 0xC007FFDF;
        *(uint32_t *)0x40006C18 = 0x00008000;
    }

    /* The QFN package variant does not have the GPIO pin P0.31 bonded out. To ensure that the
    internal pad is not floating GPIO pin P0.31 shall be configured as an output with standard
    drive strength and set to logic-level low. See Product Specification section GPIO for further
    explanation. The side effect of executing these instruction in a device that does not need it
    (wafer level packages) is that PIN 31 will be configurad as an output and driven low. */
    if (is_output_31_setup_needed())
    {
        NRF_GPIO->PIN_CNF[31] = (GPIO_PIN_CNF_DIR_Output     << GPIO_PIN_CNF_DIR_Pos)    |
                                (GPIO_PIN_CNF_INPUT_Connect  << GPIO_PIN_CNF_INPUT_Pos)  |
                                (GPIO_PIN_CNF_PULL_Disabled  << GPIO_PIN_CNF_PULL_Pos)   |
                                (GPIO_PIN_CNF_DRIVE_S0S1     << GPIO_PIN_CNF_DRIVE_Pos)  |
                                (GPIO_PIN_CNF_SENSE_Disabled << GPIO_PIN_CNF_SENSE_Pos);
        NRF_GPIO->OUTCLR = 1UL << 31;
    }
}

/**
  Updates the variable SystemCoreClock and must be called whenever the core
  clock is changed during program execution.

  SystemCoreClockUpdate() evaluates the clock register settings and calculates
  the current core clock.
*/
void SystemCoreClockUpdate (void)
{
  SystemCoreClock = __SYSTEM_CLOCK;
}


/* Known nRF51 chip variant HWIDs */
#define HWID_NRF51422_QFAA_CA   (0x1EUL)
#define HWID_NRF51422_QFAA_C0   (0x24UL)
#define HWID_NRF51422_QFAA_DA   (0x2DUL)
#define HWID_NRF51422_QFAA_D0   (0x2EUL)
#define HWID_NRF51422_CEAA_A0   (0x31UL)

#define HWID_NRF51822_QFAA_CA   (0x1DUL)
#define HWID_NRF51822_QFAA_C0   (0x1DUL)
#define HWID_NRF51822_QFAA_FA   (0x2AUL)
#define HWID_NRF51822_QFAA_FB   (0x2BUL)
#define HWID_NRF51822_QFAA_FC   (0x34UL)
#define HWID_NRF51822_QFAA_F0   (0x2CUL)
#define HWID_NRF51822_CEAA_B0   (0x2FUL)
//#define HWID_NRF51822_CEAA_CA   (0xUL)    New device to come

#define HWID_NRF51822_QFAB_AA   (0x26UL)
#define HWID_NRF51822_QFAB_A0   (0x27UL)
//#define HWID_NRF51822_QFAB_B0   (0xUL)    New device to come

#define HWID_NRF51922_QFAA_AA   (0x33UL)
//#define HWID_NRF51922_QFAA_BA   (0xUL)    New device to come

static bool is_manual_peripheral_setup_needed (void) 
{
    switch ((NRF_FICR->CONFIGID & FICR_CONFIGID_HWID_Msk) >> FICR_CONFIGID_HWID_Pos)
    {
        case HWID_NRF51422_QFAA_CA: return true;
        case HWID_NRF51422_QFAA_C0: return true;
        case HWID_NRF51422_QFAA_DA: return false;
        case HWID_NRF51422_QFAA_D0: return false;
        case HWID_NRF51422_CEAA_A0: return true;
        case HWID_NRF51822_QFAA_C0: return true;
        case HWID_NRF51822_QFAA_FA: return false;
        case HWID_NRF51822_QFAA_FB: return false;
        case HWID_NRF51822_QFAA_FC: return false;
        case HWID_NRF51822_QFAA_F0: return false;
        case HWID_NRF51822_CEAA_B0: return true;
        case HWID_NRF51822_QFAB_AA: return true;
        case HWID_NRF51822_QFAB_A0: return true;
        case HWID_NRF51922_QFAA_AA: return true;
        /* WARNING: Other device than those defined is found. Since no information is available, 
                the most probable option will be take. The assumption is that the unknown device does not
                need the workaround, since at the time of writing this note we are not aware of any plans
                to produce any new device that will need it. */  
        default: return false;
    }
}

static bool is_output_31_setup_needed (void) 
{
    switch ((NRF_FICR->CONFIGID & FICR_CONFIGID_HWID_Msk) >> FICR_CONFIGID_HWID_Pos)
    {
        case HWID_NRF51422_QFAA_CA: return true;
        case HWID_NRF51422_QFAA_C0: return true;
        case HWID_NRF51422_QFAA_DA: return true;
        case HWID_NRF51422_QFAA_D0: return true;
        case HWID_NRF51422_CEAA_A0: return false;
        case HWID_NRF51822_QFAA_C0: return true;
        case HWID_NRF51822_QFAA_FA: return true;
        case HWID_NRF51822_QFAA_FB: return true;
        case HWID_NRF51822_QFAA_FC: return true;
        case HWID_NRF51822_QFAA_F0: return true;
        case HWID_NRF51822_CEAA_B0: return false;
        case HWID_NRF51822_QFAB_AA: return true;
        case HWID_NRF51822_QFAB_A0: return true;
        case HWID_NRF51922_QFAA_AA: return true;
        /* WARNING: Other device than those defined is found. Since no information is available, 
                the most probable option will be take. The assumption is that you use devices  
                in a QFN package. Please modify the default case if this assumption is not correct. */
        default: return true;
    }
}

/*lint --flb "Leave library region" */
