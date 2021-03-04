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
#include "samd51_wio_tft_sprite.hpp"

#include "Free_Fonts.h"

//TFT_eSprite* mysprite;

SpriteHandle sprite_init(TFTHandle TFTOwner)
{
   TFT_eSprite *mysprite = new TFT_eSprite(TFTOwner);
   return mysprite;
}

void sprite_delete(SpriteHandle Sprite)
{
   delete Sprite;
}

void sprite_createSprite(SpriteHandle Sprite, int16_t w, int16_t h)
{
   Sprite->createSprite(w, h);
}

void sprite_fillSprite(SpriteHandle Sprite, uint32_t color)
{
   Sprite->fillSprite(color);
}

void sprite_setTextSize(SpriteHandle Sprite, uint8_t size)
{
   Sprite->setTextSize(size);
}

void sprite_setTextColor(SpriteHandle Sprite, uint16_t color)
{
   Sprite->setTextColor(color);
}

void sprite_drawNumber(SpriteHandle Sprite, long long_num, int32_t poX, int32_t poY, uint8_t font)
{
   Sprite->drawNumber(long_num, poX, poY, font);
}

void sprite_drawCharEx(SpriteHandle Sprite, int32_t x, int32_t y, uint16_t uniCode, uint32_t color, uint32_t bg, uint8_t size)
{
   Sprite->drawChar(x, y, uniCode, color, bg, size);
}

int16_t sprite_drawChar(SpriteHandle Sprite, uint16_t uniCode, int32_t x, int32_t y, uint8_t font)
{
   return Sprite->drawChar(uniCode, x, y, font);
}

int16_t sprite_drawString(SpriteHandle Sprite, const char *string, int32_t poX, int32_t poY, uint8_t font)
{
   return Sprite->drawString(string, poX, poY, font);
}

void sprite_pushSprite(SpriteHandle Sprite, int32_t x, int32_t y)
{
   Sprite->pushSprite(x,y);
}
