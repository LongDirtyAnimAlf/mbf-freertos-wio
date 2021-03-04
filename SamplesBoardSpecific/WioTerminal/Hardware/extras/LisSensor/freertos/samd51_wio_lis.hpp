#ifndef SAMD51_WIO_LIS_HPP_
#define SAMD51_WIO_LIS_HPP_

#ifdef __cplusplus

//#include "Wire.h"
#include "LIS3DHTR.h"

typedef LIS3DHTR<TwoWire> *LisHandle;

#endif

#ifdef __cplusplus
 extern "C" {
#endif

LisHandle lis_init(void);
void lis_delete(LisHandle Lis);
double getAccelerationX(LisHandle Lis);
double getAccelerationY(LisHandle Lis);
double getAccelerationZ(LisHandle Lis);
uint32_t getAccelerationIntX(LisHandle Lis);
uint32_t getAccelerationIntY(LisHandle Lis);
uint32_t getAccelerationIntZ(LisHandle Lis);

#ifdef __cplusplus
 }
#endif

#endif /* SAMD51_WIO_LIS_HPP_ */
