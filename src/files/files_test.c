//
// Created by jpoole on 7/14/24.
//

#include <stdio.h>

#include "../qemu/qemu.h"
#include "../serial/serial.h"

int main() {
    serial_init(COM1);
    FILE* com0 = fopen("/dev/com1", "w");
    fprintf(com0, "This should print to com0!\n");
    qemu_shutdown();
}