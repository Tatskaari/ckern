const std = @import("std");
const serial = @import("serial.zig");
const terminal = @import("terminal.zig");
const pci = @import("pci.zig");
const mem = @import("mem.zig");

// TODO move these over to zig
extern fn terminal_write(data: [*]const u8, size: usize) usize;

export fn run_kernel() i32 {
    terminal.init();
    var com1 = serial.SerialPort{.Port = serial.COM1 };
    com1.init() catch {
        terminal.print("Failed to initialize COM1\n", .{});
        return -1;
    };
    const a = mem.allocator.alloc(u8, 1) catch unreachable;
    mem.allocator.free(a);

    pci.lspci();
    return 0;
}
