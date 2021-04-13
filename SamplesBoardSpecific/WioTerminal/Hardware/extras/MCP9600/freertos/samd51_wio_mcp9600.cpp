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
#include "samd51_wio_mcp9600.hpp"

MCP9600Handle mcp9600_init(void)
{

   /*
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
   */

   if (&PERIPH_WIRE)
   {
      // destruct            
      PERIPH_WIRE.~SERCOM();
      // create again on same spot
      new (&PERIPH_WIRE) SERCOM(SERCOM3);
   }
   else
   {
      PERIPH_WIRE = SERCOM(SERCOM3);
   }

   if (&Wire)
   {
      // destruct
      Wire.~TwoWire();
      // create again on same spot    
      new (&Wire) TwoWire (&PERIPH_WIRE, PIN_WIRE_SDA, PIN_WIRE_SCL);
   }
   else
   {
      Wire = TwoWire (&PERIPH_WIRE, PIN_WIRE_SDA, PIN_WIRE_SCL);
   }

   //MCP9600 *mysensor = new MCP9600(Wire,DEFAULT_IIC_ADDR);
   MCP9600 *mysensor = new MCP9600();
 
   return mysensor;
}

void mcp9600_delete(MCP9600Handle MCP9600)
{
   delete MCP9600;
}

void mcp9600_setup(MCP9600Handle MCP9600)
{
   MCP9600->init(THER_TYPE_K);
   MCP9600->set_filt_coefficients(FILT_MID);
   MCP9600->set_cold_junc_resolution(COLD_JUNC_RESOLUTION_0_25);
   MCP9600->set_ADC_meas_resolution(ADC_14BIT_RESOLUTION);
   MCP9600->set_burst_mode_samp(BURST_32_SAMPLE);
   MCP9600->set_sensor_mode(NORMAL_OPERATION);
}

double mcp9600_get_hot_temperature(MCP9600Handle MCP9600)
{
   float hot_junc = 0;
   MCP9600->read_hot_junc(&hot_junc);
   return static_cast<double>(hot_junc);
}

double mcp9600_get_delta_temperature(MCP9600Handle MCP9600)
{
   float junc_delta = 0;
   MCP9600->read_junc_temp_delta(&junc_delta);
   return static_cast<double>(junc_delta);
}

double mcp9600_get_cold_temperature(MCP9600Handle MCP9600)
{
   float cold_junc = 0;
   MCP9600->read_cold_junc(&cold_junc);
   return static_cast<double>(cold_junc);
}
