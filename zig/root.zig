const std = @import("std");
const libc = @import("libc.zig");
const serial = @import("serial.zig");

// TODO move these over to zig
extern fn terminal_write(data: [*]const u8, size: usize) usize;

export fn zig_test() i32 {
    var com1 = serial.SerialPortFile{.Port = serial.COM1 };
    com1.init() catch {
        _ = libc.printf("Failed to initialize COM1\n");
        return 10;
    };
    _ = com1.write("test", 4) catch {
        _ = libc.printf("Failed to write to COM1\n");
    };

    var dest : [5]u8 = undefined;
    _ = com1.read(&dest, 4) catch unreachable;
    dest[4] = 0;
    _ = libc.printf("got %s\n", &dest);

    return std.fmt.parseInt(i32, "10", 10) catch unreachable;
}
