const std = @import("std");
const std2 = @import("std/mystd.zig");

export fn zig_test() i32 {
    _ = std2.printf("hello %s", "fromm zig\n");

    return std.fmt.parseInt(i32, "10", 10) catch unreachable;
}
