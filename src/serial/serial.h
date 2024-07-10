//
// Created by jpoole on 7/10/24.
//

#ifndef CKERN_SERIAL_H
#define CKERN_SERIAL_H

#include<stdint.h>

#define COM1 0x3f8
#define COM2 0x2F8
#define COM3 0x3E8
#define COM4 0x2E8

void serial_write(uint16_t port, char* data);
int serial_read(uint16_t port, char* dest, int count);
int serial_init(uint16_t port);

#endif //CKERN_SERIAL_H
