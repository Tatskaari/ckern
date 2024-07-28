const std = @import("std");
const libc = @import("libc.zig");
const serial = @import("serial.zig");
const terminal = @import("terminal.zig");

// TODO move these over to zig
extern fn terminal_write(data: [*]const u8, size: usize) usize;

export fn zig_test() i32 {
    var com1 = serial.SerialPort{.Port = serial.COM1 };
    com1.init() catch {
        _ = libc.printf("Failed to initialize COM1\n");
        return 10;
    };

     _ = terminal.Terminal1.init(80, 25, terminal.entry_colour(terminal.VGAColor.LightBlue, terminal.VGAColor.Red));

    return std.fmt.parseInt(i32, "10", 10) catch unreachable;
}
