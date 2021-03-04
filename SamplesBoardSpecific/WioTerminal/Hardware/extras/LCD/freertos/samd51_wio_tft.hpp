#ifndef SAMD51_WIO_TFT_HPP_
#define SAMD51_WIO_TFT_HPP_

#ifdef __cplusplus
#include "SERCOM.h"
#include "SPI.h"
#include "TFT_Interface.h"
#include "TFT_eSPI.h"

typedef TFT_eSPI *TFTHandle;

extern SERCOM PERIPH_SPI3;
extern SPIClass LCD_SPI;
extern TFT_Interface _com;

#endif

#ifdef __cplusplus
 extern "C" {
#endif

TFTHandle tft_create(void);

void tft_free(TFTHandle NewTFT);

void tft_init(TFTHandle NewTFT);

void tft_setRotation(TFTHandle NewTFT, uint8_t r);
void tft_invertDisplay(TFTHandle NewTFT, boolean i);
void tft_fillScreen(TFTHandle NewTFT, uint32_t color);

void tft_drawPixel(TFTHandle NewTFT, int32_t x, int32_t y, uint32_t color);

void tft_fillRect(TFTHandle NewTFT, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t color);
void tft_drawRect(TFTHandle NewTFT, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t color);

void tft_drawRoundRect(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t w, int32_t h, int32_t radius, uint32_t color);
void tft_fillRoundRect(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t w, int32_t h, int32_t radius, uint32_t color);

void tft_drawLine(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t x1, int32_t y1, uint32_t color);
void tft_drawFastVLine(TFTHandle NewTFT, int32_t x, int32_t y, int32_t h, uint32_t color);
void tft_drawFastHLine(TFTHandle NewTFT, int32_t x, int32_t y, int32_t w, uint32_t color);

int16_t tft_height(TFTHandle NewTFT);
int16_t tft_width(TFTHandle NewTFT);

void tft_drawCircle(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t r, uint32_t color);
void tft_fillCircle(TFTHandle NewTFT, int32_t x0, int32_t y0, int32_t r, uint32_t color);

void tft_drawCharEx(TFTHandle NewTFT, int32_t x, int32_t y, uint16_t c, uint32_t color, uint32_t bg, uint8_t size);
int16_t tft_drawChar(TFTHandle NewTFT, uint16_t uniCode, int32_t x, int32_t y, uint8_t font);
int16_t tft_drawString(TFTHandle NewTFT, const char *string, int32_t poX, int32_t poY, uint8_t font);

void tft_setTextColor(TFTHandle NewTFT, uint16_t fgcolor, uint16_t bgcolor);
void tft_setTextSize(TFTHandle NewTFT, uint8_t size);

uint16_t tft_fontsLoaded(TFTHandle NewTFT);
uint16_t tft_color565(TFTHandle NewTFT, uint8_t red, uint8_t green, uint8_t blue);
uint16_t tft_color8to16(TFTHandle NewTFT, uint8_t color332);
uint8_t tft_color16to8(TFTHandle NewTFT, uint16_t color565);

int16_t tft_drawNumber(TFTHandle NewTFT, long long_num, int32_t poX, int32_t poY, uint8_t font);
int16_t tft_drawFloat(TFTHandle NewTFT, float floatNumber, uint8_t decimal, int32_t poX, int32_t poY, uint8_t font);

#ifdef __cplusplus
 }
#endif

#endif /* SAMD51_WIO_TFT_HPP_ */
