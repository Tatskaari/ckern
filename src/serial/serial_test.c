//
// Created by jpoole on 7/14/24.
//

#include <string.h>

#include "../qemu/qemu.h"
#include "../serial/serial.h"

int main() {
    serial_init(COM1);
    char* text =  "Hello, world!\n";
    serial_write(COM1, text, strlen(text));
    qemu_shutdown();
}