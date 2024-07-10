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

int serial_write(uint16_t port, const char* data, int count);
int serial_read(uint16_t port, char* dest, int count);
int serial_init(uint16_t port);

int com1_read(char* dest, int count);
int com2_read(char* dest, int count);
int com3_read(char* dest, int count);
int com4_read(char* dest, int count);

int com1_write(const char* data, int count);
int com2_write(const char* data, int count);
int com3_write(const char* data, int count);
int com4_write(const char* data, int count);

#endif //CKERN_SERIAL_H
