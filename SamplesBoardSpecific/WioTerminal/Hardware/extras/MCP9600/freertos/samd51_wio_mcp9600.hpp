#ifndef SAMD51_WIO_MCP9600_HPP_
#define SAMD51_WIO_MCP9600_HPP_

#ifdef __cplusplus

#include "Arduino.h"
#include "variant.h"
#include "Seeed_MCP9600.h"

typedef MCP9600 *MCP9600Handle;

extern SERCOM PERIPH_WIRE;
extern TwoWire Wire;

#endif

#ifdef __cplusplus
 extern "C" {
#endif

MCP9600Handle mcp9600_init(void);
void mcp9600_delete(MCP9600Handle MCP9600);
void mcp9600_setup(MCP9600Handle MCP9600);
double mcp9600_get_hot_temperature(MCP9600Handle MCP9600);
double mcp9600_get_delta_temperature(MCP9600Handle MCP9600);
double mcp9600_get_cold_temperature(MCP9600Handle MCP9600);

//err_t sensor_basic_config() {

#ifdef __cplusplus
 }
#endif

#endif /* SAMD51_WIO_MCP9600_HPP_ */
