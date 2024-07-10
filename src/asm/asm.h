//
// Created by jpoole on 7/10/24.
//

#ifndef CKERN_ASM_H
#define CKERN_ASM_H

#include<stdint.h>

// Calls the outb instruction to output a byte to a port
void outb(uint16_t port, char val);
// Calls the inb instruction to read a byte from a port
uint8_t inb(uint16_t port);
// Calls the outw instruction to read a word (2 bytes) from a port
void outw(uint16_t port, uint16_t value);
// Calls the inw intruction to read a word (2 bytes) from a port
uint16_t inw(uint16_t port);

#endif //CKERN_ASM_H
