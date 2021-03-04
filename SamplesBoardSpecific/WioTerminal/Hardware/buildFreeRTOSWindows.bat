@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  Android sqlite buildscript for Windows
@rem  Builds the mORMot sqlite static libraries with the Android NDK
@rem  Please set the path towards the NDK
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set CROSS=C:\fpclazbydeluxe\newembedded\cross
set SDK=%CROSS%\bin\arm-freertos\arm-none-eabi\lib
set GCC=%CROSS%\bin\arm-freertos

@rem set TARGETDIR=.\lib\armv7em
set TARGETDIR=%CROSS%\lib\arm-freertos\armv7em\eabihf

set TARGETNAME=libfreertos_wio.a

@rem set BOARDDIR=Boards\WioTerminal
set BOARDDIR=.

set ARDUINODIR=%BOARDDIR%\ArduinoCore
set CMSISDIR=%BOARDDIR%\CMSIS-Atmel\1.2.1\CMSIS-Atmel\CMSIS\Device\ATMEL
set CMSISCOREDIR=%BOARDDIR%\CMSIS\5.4.0\CMSIS

set FREERTOSDIR=%ARDUINODIR%\libraries\Seeed_Arduino_FreeRTOS\src

mkdir %TARGETDIR%     2> nul

del .\FreeRTOSConfig.h
del /s /f /q %TARGETDIR%\*.o    2> nul
del /s /f /q %TARGETDIR%\*.d    2> nul
del /s /f /q %TARGETDIR%\*.su   2> nul
del /s /f /q %TARGETDIR%\%TARGETNAME%  2> nul
@rem del /s /f /q %TARGETDIR%\libfreertos_heap_4.a 2> nul

echo
echo ---------------------------------------------------
echo Compiling FreeRTOS for armv7em

copy %FREERTOSDIR%\FreeRTOSConfig.h FreeRTOSConfig.h
@rem copy samples\templates\FreeRTOSConfig.h.samd51 FreeRTOSConfig.h
@rem -DUSE_TINYUSB 

set USBFLAGS=-DUSE_TINYUSB -DUSB_VID=0x2886 -DUSB_PID=0x802D -DUSBCON -DUSB_CONFIG_POWER=100 -DROLE=0 "-DUSB_MANUFACTURER=\"Seeed Studio\"" "-DUSB_PRODUCT=\"Seeed Wio Terminal\""
set CFLAGS=-Wno-nonnull -Wno-unused-value -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -g3 -ffunction-sections -fdata-sections --param max-inline-insns-single=500 -fno-exceptions -O3 -fdevirtualize-at-ltrans -Wall -fstack-usage
set CXXFLAGS=-CC -Wno-nonnull -Wno-unused-value -fpermissive -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -c -g -O3 -fdevirtualize-at-ltrans -w -std=gnu++14 -ffunction-sections -fdata-sections -fno-threadsafe-statics --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -fno-use-cxa-atexit
set INCLUDES=-I. -I%FREERTOSDIR% -I%ARDUINODIR%\cores\arduino -I%ARDUINODIR%\libraries\Wire -I%ARDUINODIR%\libraries\Seeed_Arduino_LIS3DHTR\src -I%ARDUINODIR%\libraries\Seeed_Arduino_LCD -I%ARDUINODIR%\libraries\Seeed_Arduino_LCD\freertos -I%ARDUINODIR%\libraries\Seeed_Arduino_LCD\Fonts -I%ARDUINODIR%\libraries\Seeed_Arduino_LCD\TFT_Drivers -I%ARDUINODIR%\libraries\Seeed_Arduino_LCD\User_Setups -I%ARDUINODIR%\libraries\SPI -I%ARDUINODIR%\libraries\Adafruit_ZeroDMA  -I%BOARDDIR%\extras\System -I%BOARDDIR%\extras\TinyUSB\freertos -I%BOARDDIR%\extras\LCD\freertos -I%BOARDDIR%\extras\Lis\freertos -I%ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src -I%CMSISDIR%\samd51\include -I%ARDUINODIR%\variants\wio_terminal -I%CMSISCOREDIR%\Core\Include -I%CMSISCOREDIR%\DSP\Include -I%FREERTOSDIR%\boards\SAMD21\FreeRTOSVariant -I%FREERTOSDIR%\boards\SAMD51\FreeRTOSVariant

@rem  -DTXRXLED_ENABLE

@rem set FLAGS=-DDONT_USE_CMSIS_INIT -DF_CPU=120000000L -DARDUINO=10813 -DVARIANT_QSPI_BAUD_DEFAULT=50000000 -DARDUINO_ARCH_SAMD -D__SAMD51__ -D__SAMD51P19A__ -DVARIANT_QSPI_BAUD_DEFAULT=50000000 -DWIO_TERMINAL -DSEEED_WIO_TERMINAL -DSEEED_GROVE_UI_WIRELESS -D__FPU_PRESENT %USBFLAGS% -c %INCLUDES%
set FLAGS=-DF_CPU=120000000L -DARDUINO=10813 -DVARIANT_QSPI_BAUD_DEFAULT=50000000 -DARDUINO_ARCH_SAMD -D__SAMD51__ -D__SAMD51P19A__ -DVARIANT_QSPI_BAUD_DEFAULT=50000000 -DWIO_TERMINAL -DSEEED_WIO_TERMINAL -DSEEED_GROVE_UI_WIRELESS -D__FPU_PRESENT %USBFLAGS% -c %INCLUDES%

set CXXCOMPILER=%GCC%\bin\arm-none-eabi-g++ %FLAGS% %CXXFLAGS% -nostdlib -MMD -MP --specs=nano.specs --specs=nosys.specs
set CCOMPILER=%GCC%\bin\arm-none-eabi-gcc %FLAGS% %CFLAGS% -nostdlib -MMD -MP --specs=nano.specs --specs=nosys.specs

@rem call %CCOMPILER% %FREERTOSDIR%\list.c -o %TARGETDIR%\list.o
@rem call %CCOMPILER% %FREERTOSDIR%\event_groups.c -o %TARGETDIR%\event_groups.o
@rem call %CCOMPILER% %FREERTOSDIR%\heap_4.c -o %TARGETDIR%\heap_4.o
@rem call %CCOMPILER% %FREERTOSDIR%\croutine.c -o %TARGETDIR%\croutine.o
@rem call %CCOMPILER% %FREERTOSDIR%\port.c -o %TARGETDIR%\port.o
@rem call %CCOMPILER% %FREERTOSDIR%\queue.c -o %TARGETDIR%\queue.o
@rem call %CCOMPILER% %FREERTOSDIR%\stream_buffer.c -o %TARGETDIR%\stream_buffer.o
@rem call %CCOMPILER% %FREERTOSDIR%\tasks.c -o %TARGETDIR%\tasks.o
@rem call %CCOMPILER% %FREERTOSDIR%\timers.c -o %TARGETDIR%\timers.o

@rem call %CXXCOMPILER% %FREERTOSDIR%\boards\SAMD51\FreeRTOSVariant.cpp -o %TARGETDIR%\FreeRTOSVariant.o

call %CCOMPILER% %BOARDDIR%\extras\System\samd51_system_init.c -o %TARGETDIR%\samd51_system_init.o
call %CCOMPILER% %BOARDDIR%\extras\TinyUSB\freertos\samd51_usb_init.c -o %TARGETDIR%\samd51_usb_init.o
call %CXXCOMPILER% %BOARDDIR%\extras\LCD\freertos\samd51_wio_tft.cpp -o %TARGETDIR%\samd51_wio_tft.o
call %CXXCOMPILER% %BOARDDIR%\extras\LCD\freertos\samd51_wio_tft_sprite.cpp -o %TARGETDIR%\samd51_wio_tft_sprite.o
call %CXXCOMPILER% %BOARDDIR%\extras\LisSensor\freertos\samd51_wio_lis.cpp -o %TARGETDIR%\samd51_wio_lis.o


call %CXXCOMPILER% %ARDUINODIR%\variants\wio_terminal\variant.cpp -o %TARGETDIR%\variant.o
@rem call %CCOMPILER% -c -g -x assembler-with-cpp %ARDUINODIR%\cores\arduino\pulse_asm.S -o %TARGETDIR%\pulse_asm.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\WInterrupts.c -o %TARGETDIR%\WInterrupts.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\delay.c -o %TARGETDIR%\delay.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\hooks.c -o %TARGETDIR%\hooks.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\itoa.c -o %TARGETDIR%\itoa.o
@rem call %CCOMPILER% %ARDUINODIR%\cores\arduino\math_helper.c -o %TARGETDIR%\math_helper.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\pulse.c -o %TARGETDIR%\pulse.o
@rem call %CCOMPILER% %ARDUINODIR%\cores\arduino\startup.c -o %TARGETDIR%\startup.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\wiring.c -o %TARGETDIR%\wiring.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\wiring_analog.c -o %TARGETDIR%\wiring_analog.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\wiring_digital.c -o %TARGETDIR%\wiring_digital.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\wiring_shift.c -o %TARGETDIR%\wiring_shift.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\wiring_private.c -o %TARGETDIR%\wiring_private.o
@rem call %CCOMPILER% %ARDUINODIR%\cores\arduino\cortex_handlers.c -o %TARGETDIR%\cortex_handlers.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\tusb.c -o %TARGETDIR%\tusb.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\bth\bth_device.c -o %TARGETDIR%\bth_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\cdc\cdc_device.c -o %TARGETDIR%\cdc_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\dfu\dfu_rt_device.c -o %TARGETDIR%\dfu_rt_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\hid\hid_device.c -o %TARGETDIR%\hid_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\midi\midi_device.c -o %TARGETDIR%\midi_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\msc\msc_device.c -o %TARGETDIR%\msc_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\net\net_device.c -o %TARGETDIR%\net_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\usbtmc\usbtmc_device.c -o %TARGETDIR%\usbtmc_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\class\vendor\vendor_device.c -o %TARGETDIR%\vendor_device.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\device\usbd.c -o %TARGETDIR%\usbd.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\common\tusb_fifo.c -o %TARGETDIR%\tusb_fifo.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\device\usbd_control.c -o %TARGETDIR%\usbd_control.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\TinyUSB\Adafruit_TinyUSB_ArduinoCore\tinyusb\src\portable\microchip\samd\dcd_samd.c -o %TARGETDIR%\dcd_samd.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\avr\dtostrf.c -o %TARGETDIR%\dtostrf.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\libb64\cdecode.c -o %TARGETDIR%\cdecode.o
call %CCOMPILER% %ARDUINODIR%\cores\arduino\libb64\cencode.c -o %TARGETDIR%\cencode.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\IPAddress.cpp -o %TARGETDIR%\IPAddress.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\Reset.cpp -o %TARGETDIR%\Reset.o
@rem call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\Retarget.cpp -o %TARGETDIR%\Retarget.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\IPv6Address.cpp -o %TARGETDIR%\IPv6Address.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\Print.cpp -o %TARGETDIR%\Print.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\SERCOM.cpp -o %TARGETDIR%\SERCOM.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\Stream.cpp -o %TARGETDIR%\Stream.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\StreamString.cpp -o %TARGETDIR%\StreamString.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\Tone.cpp -o %TARGETDIR%\Tone.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\Uart.cpp -o %TARGETDIR%\Uart.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\WMath.cpp -o %TARGETDIR%\WMath.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\WString.cpp -o %TARGETDIR%\WString.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\abi.cpp -o %TARGETDIR%\abi.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\base64.cpp -o %TARGETDIR%\base64.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\cbuf.cpp -o %TARGETDIR%\cbuf.o
@rem call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\new.cpp -o %TARGETDIR%\new.o
call %CXXCOMPILER% %ARDUINODIR%\cores\arduino\wiring_pwm.cpp -o %TARGETDIR%\wiring_pwm.o

call %CCOMPILER% %BOARDDIR%\extras\TinyUSB\freertos\msc_disk.c -o %TARGETDIR%\msc_disk.o
call %CCOMPILER% %BOARDDIR%\extras\TinyUSB\freertos\usb_descriptors.c -o %TARGETDIR%\usb_descriptors.o

call %CXXCOMPILER% %ARDUINODIR%\libraries\Seeed_Arduino_LCD\TFT_Interface.cpp -o %TARGETDIR%\TFT_Interface.o
call %CXXCOMPILER% %ARDUINODIR%\libraries\Seeed_Arduino_LCD\TFT_eSPI.cpp -o %TARGETDIR%\TFT_eSPI.o
call %CXXCOMPILER% %ARDUINODIR%\libraries\SPI\SPI.cpp -o %TARGETDIR%\SPI.o
call %CXXCOMPILER% %ARDUINODIR%\libraries\Adafruit_ZeroDMA\Adafruit_ZeroDMA.cpp -o %TARGETDIR%\Adafruit_ZeroDMA.o

call %CXXCOMPILER% %ARDUINODIR%\libraries\Wire\Wire.cpp -o %TARGETDIR%\Wire.o
call %CXXCOMPILER% %ARDUINODIR%\libraries\Seeed_Arduino_LIS3DHTR\src\LIS3DHTR.cpp -o %TARGETDIR%\LIS3DHTR.o

@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\list.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\event_groups.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\heap_4.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\croutine.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\port.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\queue.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\stream_buffer.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\tasks.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\timers.o

@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\FreeRTOSVariant.o

@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\cortex_handlers.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\variant.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\pulse_asm.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\bth_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\cdc_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\dfu_rt_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\hid_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\midi_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\msc_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\net_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\usbtmc_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\vendor_device.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\tusb_fifo.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\usbd.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\usbd_control.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\dcd_samd.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\tusb.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\WInterrupts.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\dtostrf.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\delay.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\hooks.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\itoa.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\cdecode.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\cencode.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\math_helper.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\pulse.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\startup.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\wiring.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\wiring_analog.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\wiring_digital.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\wiring_private.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\wiring_shift.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\IPAddress.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\IPv6Address.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Print.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Reset.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Retarget.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\SERCOM.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Stream.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\StreamString.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Tone.o

call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\samd51_system_init.o

call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\msc_disk.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\usb_descriptors.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\samd51_usb_init.o

call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\samd51_wio_tft.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\samd51_wio_tft_sprite.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\samd51_wio_lis.o

call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\TFT_Interface.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\TFT_eSPI.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\SPI.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Adafruit_ZeroDMA.o

call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Wire.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\LIS3DHTR.o

call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\Uart.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\WMath.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\WString.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\abi.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\base64.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\cbuf.o
@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\new.o
call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\%TARGETNAME% %TARGETDIR%\wiring_pwm.o

@rem call %GCC%\bin\arm-none-eabi-ar rcs %TARGETDIR%\libfreertos_heap_4.a %TARGETDIR%\heap_4.o

Set LIBCARMV7EM=%SDK%\thumb\v7e-m\fpv4-sp\hard
copy %LIBCARMV7EM%\libc_nano.a %TARGETDIR%\
copy %LIBCARMV7EM%\libm.a %TARGETDIR%\

del /s /f /q %TARGETDIR%\*.o    2> nul
del /s /f /q %TARGETDIR%\*.d    2> nul
del /s /f /q %TARGETDIR%\*.su   2> nul

if "%OS%"=="Windows_NT" endlocal

pause
