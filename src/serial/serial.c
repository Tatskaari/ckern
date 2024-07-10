//
// Created by jpoole on 7/10/24.
//

#include<stdio.h>

#include "src/serial/serial.h"

inline void outb(uint16_t port, char val) {
    __asm__ volatile ( "outb %b0, %w1" :: "a"(val), "Nd"(port) : "memory");
}

inline uint8_t inb(uint16_t port) {
    char ret;
    __asm__ volatile ( "inb %w1, %b0" : "=a"(ret) : "Nd"(port) : "memory");
    return ret;
}

int serial_init(uint16_t port) {
    // TODO use bitmasks because the tutorial is horrible
    outb(port + 1, 0x00);    // Disable all interrupts
    outb(port + 3, 0x80);    // Enable DLAB (set baud rate divisor)
    outb(port + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
    outb(port + 1, 0x00);    //                  (hi byte)
    outb(port + 3, 0x03);    // 8 bits, no parity, one stop bit
    outb(port + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
    outb(port + 4, 0x0B);    // IRQs enabled, RTS/DSR set

    outb(port + 4, 0x1E);    // Set in loopback mode, test the serial chip
    outb(port + 0, 0xAE);    // Test serial chip (send byte 0xAE and check if serial returns same byte)

    // Check if serial is faulty (i.e: not same byte as sent)
    if(inb(port + 0) != 0xAE) {
        return 1;
    }

    // If serial is not faulty set it in normal operation mode
    // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
    outb(port + 4, 0x0F);
    return 0;
}

static int serial_received(uint16_t port) {
    return inb(port + 5) & 1;
}

static char sgetc(uint16_t port) {
    while (serial_received(port) == 0);

    return inb(port);
}

int serial_read(uint16_t port, char* dest, int count) {
    for(int i = 0; i < count; i++) {
        dest[i] = sgetc(port);
    }
    // We always read count, but this conforms to the file writing signature which makes posix-ing more easier
    // We can monkey patch this into a file descriptor later.
    return count;
}

static int is_transmit_empty(uint16_t port) {
    // TODO no magic numbers plz
    return inb(port + 5) & 0x20;
}

void writec(uint16_t port, char c) {
    while (is_transmit_empty(port) == 0);

    outb(port, c);
}

void serial_write(uint16_t port, char* data) {
    int i = 0;
    while(data[i] != '\0') {
        writec(port, data[i]);
        i++;
    }
}