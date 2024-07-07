//
// Created by jpoole on 7/7/24.
//

#ifndef CKERN_KERNEL_H
#define CKERN_KERNEL_H

#include <stddef.h>
#include <stdint.h>

namespace terminal {
    void initialize(void);
    void setcolor(uint8_t color);
    void putentryat(char c, uint8_t color, size_t x, size_t y);
    void putchar(char c);
    void write(const char* data, size_t size);
    void writestring(const char* data);
}

namespace vga {
    static const size_t WIDTH = 80;
    static const size_t HEIGHT = 25;

    enum vga_color {
        COLOR_BLACK = 0,
        COLOR_BLUE = 1,
        COLOR_GREEN = 2,
        COLOR_CYAN = 3,
        COLOR_RED = 4,
        COLOR_MAGENTA = 5,
        COLOR_BROWN = 6,
        COLOR_LIGHT_GREY = 7,
        COLOR_DARK_GREY = 8,
        COLOR_LIGHT_BLUE = 9,
        COLOR_LIGHT_GREEN = 10,
        COLOR_LIGHT_CYAN = 11,
        COLOR_LIGHT_RED = 12,
        COLOR_LIGHT_MAGENTA = 13,
        COLOR_LIGHT_BROWN = 14,
        COLOR_WHITE = 15,
    };

    static inline uint8_t entry_color(enum vga_color fg, enum vga_color bg);

    static inline uint16_t entry(unsigned char uc, uint8_t color);
}

#endif //CKERN_KERNEL_H
