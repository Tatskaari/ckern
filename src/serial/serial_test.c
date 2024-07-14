//
// Created by jpoole on 7/14/24.
//

#include "../qemu/qemu.h"
#include "../serial/serial.h"

int main() {
    serial_init(COM1);
    serial_write(COM1, "Hello, world!\n", 13);
    qemu_shutdown();
}