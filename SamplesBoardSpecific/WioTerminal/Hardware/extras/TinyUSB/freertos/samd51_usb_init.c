/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2019, hathach for Adafruit
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifdef USE_TINYUSB

#include "Arduino.h"
#include "tusb.h"
#include "samd51_usb_init.h"

//--------------------------------------------------------------------+
// Forward USB interrupt events to TinyUSB IRQ Handler
//--------------------------------------------------------------------+
void USB_0_Handler (void) { tud_int_handler(0); }
void USB_1_Handler (void) { tud_int_handler(0); }
void USB_2_Handler (void) { tud_int_handler(0); }
void USB_3_Handler (void) { tud_int_handler(0); }

// static task for usbd
// Increase stack size when debug log is enabled
#if CFG_TUSB_DEBUG
  #define USBD_STACK_SIZE     (3*configMINIMAL_STACK_SIZE)
#else
  #define USBD_STACK_SIZE     (3*configMINIMAL_STACK_SIZE/2)
#endif
StackType_t  usb_device_stack[USBD_STACK_SIZE];

// static task for cdc
#define CDC_STACK_SZIE      configMINIMAL_STACK_SIZE
StackType_t  cdc_stack[CDC_STACK_SZIE];

// Init usb hardware when starting up. Softdevice is not enabled yet
void usb_hardware_init(void)
{
/* Enable USB clock */
	MCLK->APBBMASK.reg |= MCLK_APBBMASK_USB;
	MCLK->AHBMASK.reg |= MCLK_AHBMASK_USB;

	// Set up the USB DP/DN pins
	PORT->Group[0].PINCFG[PIN_PA24H_USB_DM].bit.PMUXEN = 1;
	PORT->Group[0].PMUX[PIN_PA24H_USB_DM/2].reg &= ~(0xF << (4 * (PIN_PA24H_USB_DM & 0x01u)));
	PORT->Group[0].PMUX[PIN_PA24H_USB_DM/2].reg |= MUX_PA24H_USB_DM << (4 * (PIN_PA24H_USB_DM & 0x01u));
	PORT->Group[0].PINCFG[PIN_PA25H_USB_DP].bit.PMUXEN = 1;
	PORT->Group[0].PMUX[PIN_PA25H_USB_DP/2].reg &= ~(0xF << (4 * (PIN_PA25H_USB_DP & 0x01u)));
	PORT->Group[0].PMUX[PIN_PA25H_USB_DP/2].reg |= MUX_PA25H_USB_DP << (4 * (PIN_PA25H_USB_DP & 0x01u));

	GCLK->PCHCTRL[USB_GCLK_ID].reg = GCLK_PCHCTRL_GEN_GCLK1_Val | (1 << GCLK_PCHCTRL_CHEN_Pos);

  NVIC_DisableIRQ(USB_0_IRQn);
  NVIC_ClearPendingIRQ(USB_0_IRQn);
  NVIC_SetPriority(USB_0_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

  NVIC_DisableIRQ(USB_1_IRQn);
  NVIC_ClearPendingIRQ(USB_1_IRQn);
  NVIC_SetPriority(USB_1_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

  NVIC_DisableIRQ(USB_2_IRQn);
  NVIC_ClearPendingIRQ(USB_2_IRQn);
  NVIC_SetPriority(USB_2_IRQn, (1 << __NVIC_PRIO_BITS) - 1);

  NVIC_DisableIRQ(USB_3_IRQn);
  NVIC_ClearPendingIRQ(USB_3_IRQn);
  NVIC_SetPriority(USB_3_IRQn, (1 << __NVIC_PRIO_BITS) - 1);
}

#endif // USE_TINYUSB
