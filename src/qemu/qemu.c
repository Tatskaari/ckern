//
// Created by jpoole on 7/10/24.
//

#include "qemu.h"
#include "src/asm/asm.h"

void qemu_shutdown() {
    outw(QEMU_DEBUG_PORT, 0x2000);
}