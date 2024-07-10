//
// Created by jpoole on 7/10/24.
//

#include "asm.h"

void outb(uint16_t port, char val) {
    __asm__ volatile ( "outb %b0, %w1" :: "a"(val), "Nd"(port) : "memory");
}

uint8_t inb(uint16_t port) {
    char ret;
    __asm__ volatile ( "inb %w1, %b0" : "=a"(ret) : "Nd"(port) : "memory");
    return ret;
}

void outw(uint16_t port, uint16_t value) {
    asm volatile ("outw %w0, %w1" : : "a"(value), "Nd"(port));
}

uint16_t inw(uint16_t port) {
    char ret;
    __asm__ volatile ( "inw %w1, %w0" : "=a"(ret) : "Nd"(port) : "memory");
    return ret;
}