const arch = @import("../arch/index.zig");

const QEMU_DEBUG_PORT = 0x604;

fn shutdown() void {
    arch.ports.outw(QEMU_DEBUG_PORT, 0x2000);
}