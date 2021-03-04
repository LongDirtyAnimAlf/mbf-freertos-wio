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
#include "User_Setup_Select.h"
#include "samd51_wio_tft.hpp"

#include "Free_Fonts.h" // Include the header file attached to this sketch

//TFT_eSPI tft;

// The scrolling area must be a integral multiple of TEXT_HEIGHT
#define TEXT_HEIGHT 16 // Height of text to be printed and scrolled
#define BOT_FIXED_AREA 0 // Number of lines in bottom fixed area (lines counted from bottom of screen)
#define TOP_FIXED_AREA 16 // Number of lines in top fixed area (lines counted from top of screen)
#define YMAX 320 // Bottom of screen area

// The initial y coordinate of the top of the scrolling area
uint16_t yStart = TOP_FIXED_AREA;
// yArea must be a integral multiple of TEXT_HEIGHT
uint16_t yArea = YMAX - TOP_FIXED_AREA - BOT_FIXED_AREA;
// The initial y coordinate of the top of the bottom text line
uint16_t yDraw = YMAX - BOT_FIXED_AREA - TEXT_HEIGHT;

// Keep track of the drawing x coordinate
uint16_t xPos = 0;

// For the byte we read from the serial port
byte data = 0;

// A few test variables used during debugging
boolean change_colour = 1;
boolean selected = 1;

// We have to blank the top line each time the display is scrolled, but this takes up to 13 milliseconds
// for a full width line, meanwhile the serial buffer may be filling... and overflowing
// We can speed up scrolling of short text lines by just blanking the character we drew
int blank[19]; // We keep all the strings pixel lengths to optimise the speed of the top line blanking

// ##############################################################################################
// Setup a portion of the screen for vertical scrolling
// ##############################################################################################
// We are using a hardware feature of the display, so we can only scroll in portrait orientation
/*
void setupScrollArea(uint16_t tfa, uint16_t bfa) {
    tft.writecommand(ILI9341_VSCRDEF); // Vertical scroll definition
    tft.writedata(tfa >> 8);           // Top Fixed Area line count
    tft.writedata(tfa);
    tft.writedata((YMAX - tfa - bfa) >> 8); // Vertical Scrolling Area line count
    tft.writedata(YMAX - tfa - bfa);
    tft.writedata(bfa >> 8);           // Bottom Fixed Area line count
    tft.writedata(bfa);
}
*/

// Init tft hardware when starting up.
TFTHandle tft_create(void)
{
    if (&PERIPH_SPI3)
    {
        // destruct            
        PERIPH_SPI3.~SERCOM();
        // create again on same spot
        new (&PERIPH_SPI3) SERCOM(SERCOM7);
    }
    else
    {
        PERIPH_SPI3 = SERCOM(SERCOM7);
    }

    if (&LCD_SPI)
    {
        // destruct
        LCD_SPI.~SPIClass();
        // create again on same spot    
        new (&LCD_SPI) SPIClass(&PERIPH_SPI3, PIN_SPI3_MISO, PIN_SPI3_SCK, PIN_SPI3_MOSI, PAD_SPI3_TX, PAD_SPI3_RX);
    }
    else
    {
        LCD_SPI = SPIClass(&PERIPH_SPI3, PIN_SPI3_MISO, PIN_SPI3_SCK, PIN_SPI3_MOSI, PAD_SPI3_TX, PAD_SPI3_RX);
    }


    if (&_com)
    {
        // destruct
        _com.~TFT_Interface();
        // create again on same spot    
        new (&_com) TFT_Interface(&LCD_SPI);
    }
    else
    {
        _com = TFT_Interface(&LCD_SPI);
    }

    // create
    TFT_eSPI *tft = new TFT_eSPI();

    tft->setFreeFont(FSSBO24);

   return tft;
}


void tft_free(TFTHandle NewTFT)
{ delete NewTFT; }

void tft_init(TFTHandle NewTFT)
{ NewTFT->init(); }

void tft_setRotation(TFTHandle NewTFT, uint8_t r)
{ NewTFT->setRotation(r); }

void tft_invertDisplay(TFTHandle NewTFT, boolean i)
{ NewTFT->invertDisplay(i); }

void tft_fillScreen(TFTHandle NewTFT, uint32_t color)
{ NewTFT->fillScreen(color); }

void tft_drawPixel(TFTHandle NewTFT, int32_t x, int32_t y, uint32_t color)
{ NewTFT->drawPixel(x , y, color); }

void tft_drawLine(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t x1, int32_t y1, uint32_t color)
{ NewTFT->drawLine(x0, y0, x1, y1, color); }

void tft_drawFastVLine(TFTHandle NewTFT, int32_t x, int32_t y, int32_t h, uint32_t color)
{ NewTFT->drawFastVLine(x, y, h, color); }

void tft_drawFastHLine(TFTHandle NewTFT, int32_t x, int32_t y, int32_t w, uint32_t color)
{ NewTFT->drawFastHLine(x, y, w, color); }

void tft_drawCharEx(TFTHandle NewTFT, int32_t x, int32_t y, uint16_t uniCode, uint32_t color, uint32_t bg, uint8_t size)
{ NewTFT->drawChar(x, y, uniCode, color, bg, size); }

//int16_t drawChar(TFTHandle NewTFT, uint16_t uniCode, int32_t x, int32_t y)
//{ return NewTFT->drawChar(uniCode, x, y); }

int16_t tft_drawChar(TFTHandle NewTFT, uint16_t uniCode, int32_t x, int32_t y, uint8_t font)
{ return NewTFT->drawChar(uniCode, x, y, font); }

int16_t tft_drawString(TFTHandle NewTFT, const char *string, int32_t poX, int32_t poY, uint8_t font)
{ return NewTFT->drawString(string, poX, poY, font); }

int16_t tft_height(TFTHandle NewTFT)
{ return NewTFT->height(); }

int16_t tft_width(TFTHandle NewTFT)
{ return NewTFT->width(); }

void tft_fillRect(TFTHandle NewTFT, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t color)
{ NewTFT->fillRect(x, y, w, h, color);}

void tft_drawRect(TFTHandle NewTFT, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t color)
{ NewTFT->drawRect(x, y, w, h, color); }

void tft_drawRoundRect(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t w, int32_t h, int32_t radius, uint32_t color)
{ NewTFT->drawRoundRect(x0, y0, w, h, radius, color); }

void tft_fillRoundRect(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t w, int32_t h, int32_t radius, uint32_t color)
{ NewTFT->fillRoundRect(x0, y0, w, h, radius, color); }

void tft_drawCircle(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t r, uint32_t color)
{ NewTFT->drawCircle(x0, y0, r, color); }

void tft_fillCircle(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t r, uint32_t color)
{ NewTFT->fillCircle(x0, y0, r, color); }

uint16_t tft_fontsLoaded(TFTHandle NewTFT)
{ return NewTFT->fontsLoaded();}

uint16_t tft_color565(TFTHandle NewTFT, uint8_t red, uint8_t green, uint8_t blue)
{ return NewTFT->color565(red, green, blue); }

uint16_t tft_color8to16(TFTHandle NewTFT, uint8_t color332)
{ return NewTFT->color8to16(color332); }

uint8_t tft_color16to8(TFTHandle NewTFT, uint16_t color565)
{ return NewTFT->color16to8(color565); }

int16_t tft_drawNumber(TFTHandle NewTFT, long long_num, int32_t poX, int32_t poY, uint8_t font)
{ return NewTFT->drawNumber(long_num, poX, poY, font); }

int16_t tft_drawFloat(TFTHandle NewTFT, float floatNumber, uint8_t decimal, int32_t poX, int32_t poY, uint8_t font)
{ return NewTFT->drawFloat(floatNumber, decimal, poX, poY, font); }

void tft_setTextColor(TFTHandle NewTFT, uint16_t fgcolor, uint16_t bgcolor)
{ NewTFT->setTextColor(fgcolor, bgcolor); }

void tft_setTextSize(TFTHandle NewTFT, uint8_t size)
{ NewTFT->setTextSize(size); }

/*

// ##############################################################################################
// Setup the vertical scrolling start address pointer
// ##############################################################################################
void scrollAddress(uint16_t vsp) {
    tft.writecommand(ILI9341_VSCRSADD); // Vertical scrolling pointer
    tft.writedata(vsp >> 8);
    tft.writedata(vsp);
}

// ##############################################################################################
// Call this function to scroll the display one text line
// ##############################################################################################
int scroll_line() {
    int yTemp = yStart; // Store the old yStart, this is where we draw the next line
    // Use the record of line lengths to optimise the rectangle size we need to erase the top line
    tft.fillRect(0, yStart, blank[(yStart - TOP_FIXED_AREA) / TEXT_HEIGHT], TEXT_HEIGHT, TFT_BLACK);

    // Change the top of the scroll area
    yStart += TEXT_HEIGHT;
    // The value must wrap around as the screen memory is a circular buffer
    if (yStart >= YMAX - BOT_FIXED_AREA) {
        yStart = TOP_FIXED_AREA + (yStart - YMAX + BOT_FIXED_AREA);
    }
    // Now we can scroll the display
    scrollAddress(yStart);
    return  yTemp;
}
*/