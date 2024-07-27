//
// Created by jpoole on 7/10/24.
//

#include "serial.h"


int com1_read(char* dest, int count) {
    return serial_read(COM1, dest, count);
}
int com2_read(char* dest, int count) {
    return serial_read(COM2, dest, count);
}
int com3_read(char* dest, int count) {
    return serial_read(COM3, dest, count);
}
int com4_read(char* dest, int count) {
    return serial_read(COM4, dest, count);
}

int com1_write(const char* dest, int count) {
    return serial_write(COM1, dest, count);
}
int com2_write(const char* dest, int count) {
    return serial_write(COM2, dest, count);
}
int com3_write(const char* dest, int count) {
    return serial_write(COM3, dest, count);
}
int com4_write(const char* dest, int count) {
    return serial_write(COM4, dest, count);
}