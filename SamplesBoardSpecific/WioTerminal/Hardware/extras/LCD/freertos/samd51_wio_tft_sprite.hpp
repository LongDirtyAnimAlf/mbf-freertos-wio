#ifndef SAMD51_WIO_TFT_SPRITE_HPP_
#define SAMD51_WIO_TFT_SPRITE_HPP_

#ifdef __cplusplus

#include "samd51_wio_tft.hpp"

typedef TFT_eSprite *SpriteHandle;

#endif

#ifdef __cplusplus
 extern "C" {
#endif

SpriteHandle sprite_init(TFTHandle TFTOwner);
void sprite_delete(SpriteHandle Sprite);
void sprite_createSprite(SpriteHandle Sprite, int16_t w, int16_t h);
void sprite_fillSprite(SpriteHandle Sprite, uint32_t color);
void sprite_setTextSize(SpriteHandle Sprite, uint8_t size);
void sprite_setTextColor(SpriteHandle Sprite, uint16_t color);
void sprite_drawNumber(SpriteHandle Sprite, long long_num, int32_t poX, int32_t poY, uint8_t font);

int16_t sprite_drawChar(SpriteHandle Sprite, uint16_t uniCode, int32_t x, int32_t y, uint8_t font);
void sprite_drawCharEx(SpriteHandle Sprite, int32_t x, int32_t y, uint16_t c, uint32_t color, uint32_t bg, uint8_t size);
int16_t sprite_drawString(SpriteHandle Sprite, const char *string, int32_t poX, int32_t poY, uint8_t font);

void sprite_pushSprite(SpriteHandle Sprite, int32_t x, int32_t y);

#ifdef __cplusplus
 }
#endif

#endif /* SAMD51_WIO_TFT_SPRITE_HPP_ */
