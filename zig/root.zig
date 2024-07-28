const std = @import("std");
const libc = @import("libc.zig");
const serial = @import("serial.zig");
const terminal = @import("terminal.zig");
const pci = @import("pci.zig");

// TODO move these over to zig
extern fn terminal_write(data: [*]const u8, size: usize) usize;

export fn run_kernel() i32 {
    var com1 = serial.SerialPort{.Port = serial.COM1 };
    com1.init() catch {
        _ = libc.printf("Failed to initialize COM1\n");
        return 10;
    };

    _ = libc.printf("> lspci\n");
    pci.lspci();
    return 0;
}
