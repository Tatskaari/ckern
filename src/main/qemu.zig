const x86 = @import("x86.zig");

const QEMU_DEBUG_PORT = 0x604;

fn shutdown() void {
    x86.outw(QEMU_DEBUG_PORT, 0x2000);
}