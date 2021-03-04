#ifndef SAMD51_USB_INIT_H_
#define SAMD51_USB_INIT_H_

#ifndef USE_TINYUSB
#error TinyUSB is not selected, please select it in Tools->Menu->USB Stack
#endif

#ifdef __cplusplus
 extern "C" {
#endif

#include "tusb.h"

// Called by main.cpp to initialize usb device typically with CDC device for Serial
void usb_hardware_init(void);

#ifdef __cplusplus
 }
#endif

#endif /* SAMD51_USB_INIT_H_ */
