//
// Created by jpoole on 7/7/24.
//

#include <kernel/kernel.h>
#include <stddef.h>
#include <stdint.h>

namespace terminal {
    size_t terminal_row;
    size_t terminal_column;
    uint8_t terminal_color;
    uint16_t* terminal_buffer;

    size_t strlen(const char* str)
    {
        size_t len = 0;
        while (str[len])
            len++;
        return len;
    }

    void initialize(void)
    {
        terminal_row = 0;
        terminal_column = 0;
        terminal_color = vga::entry_color(vga::COLOR_LIGHT_GREY, vga::COLOR_BLACK);
        terminal_buffer = (uint16_t*) 0xB8000;
        for (size_t y = 0; y < vga::HEIGHT; y++) {
            for (size_t x = 0; x < vga::WIDTH; x++) {
                const size_t index = y * vga::WIDTH + x;
                terminal_buffer[index] = vga::entry(' ', terminal_color);
            }
        }
    }

    void setcolor(uint8_t color)
    {
        terminal_color = color;
    }

    void putentryat(char c, uint8_t color, size_t x, size_t y)
    {
        const size_t index = y * vga::WIDTH + x;
        terminal_buffer[index] = vga::entry(c, color);
    }

    void putchar(char c)
    {
        if (c == '\n') {
            terminal_column = 0;
            terminal_row++;
            return;
        }
        putentryat(c, terminal_color, terminal_column, terminal_row);
        if (++terminal_column == vga::WIDTH) {
            terminal_column = 0;
            if (++terminal_row == vga::HEIGHT)
                terminal_row = 0;
        }
    }

    void write(const char* data, size_t size)
    {
        for (size_t i = 0; i < size; i++) {
            putchar(data[i]);
        }
    }

    void writestring(const char* data)
    {
        write(data, strlen(data));
    }
}

namespace vga {
    static inline uint8_t entry_color(enum vga_color fg, enum vga_color bg)
    {
        return fg | bg << 4;
    }

    static inline uint16_t entry(unsigned char uc, uint8_t color)
    {
        return (uint16_t) uc | (uint16_t) color << 8;
    }
}