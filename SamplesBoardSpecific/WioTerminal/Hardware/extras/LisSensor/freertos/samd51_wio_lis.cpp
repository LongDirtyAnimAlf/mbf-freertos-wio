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

#include <new>
#include "Arduino.h"
#include "variant.h"
#include "samd51_wio_lis.hpp"


//--------------------------------------------------------------------+
// Forward Wire1 interrupt events to Wire1 IRQ Handler
//--------------------------------------------------------------------+
//void WIRE1_IT_HANDLER_0 (void) { Wire1.onService(); }
//void WIRE1_IT_HANDLER_1 (void) { Wire1.onService(); }
//void WIRE1_IT_HANDLER_2 (void) { Wire1.onService(); }
//void WIRE1_IT_HANDLER_3 (void) { Wire1.onService(); }

LisHandle lis_init(void)
{

   if (&PERIPH_WIRE1)
   {
      // destruct            
      PERIPH_WIRE1.~SERCOM();
      // create again on same spot
      new (&PERIPH_WIRE1) SERCOM(SERCOM4);
   }
   else
   {
      PERIPH_WIRE1 = SERCOM(SERCOM4);
   }

   if (&Wire1)
   {
      // destruct
      Wire1.~TwoWire();
      // create again on same spot    
      new (&Wire1) TwoWire (&PERIPH_WIRE1, PIN_WIRE1_SDA, PIN_WIRE1_SCL);
   }
   else
   {
      Wire1 = TwoWire (&PERIPH_WIRE1, PIN_WIRE1_SDA, PIN_WIRE1_SCL);
   }

   LIS3DHTR<TwoWire> *mylis = new LIS3DHTR<TwoWire>;

   mylis->begin(Wire1);
 
   mylis->setPowerMode(POWER_MODE_NORMAL);
   mylis->setOutputDataRate(LIS3DHTR_DATARATE_100HZ); //Data output rate
   mylis->setFullScaleRange(LIS3DHTR_RANGE_2G); //Scale range set to 2g

   return mylis;
}

void lis_delete(LisHandle Lis)
{
   delete Lis;
}

double getAccelerationX(LisHandle Lis)
{
   float result = Lis->getAccelerationX();
   return static_cast<double>(result);
}

double getAccelerationY(LisHandle Lis)
{
   float result = Lis->getAccelerationY();
   return static_cast<double>(result);
}

double getAccelerationZ(LisHandle Lis)
{
   float result = Lis->getAccelerationZ();
   return static_cast<double>(result);
}

uint32_t getAccelerationIntX(LisHandle Lis)
{
   return static_cast<uint32_t>(1000*getAccelerationX(Lis));
}

uint32_t getAccelerationIntY(LisHandle Lis)
{
   return static_cast<uint32_t>(1000*getAccelerationY(Lis));
}

uint32_t getAccelerationIntZ(LisHandle Lis)
{
   return static_cast<uint32_t>(1000*getAccelerationZ(Lis));
}
