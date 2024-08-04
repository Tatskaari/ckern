pub const terminal = @import("terminal.zig");
pub const serial = @import("serial.zig");
pub const mem = @import("mem.zig");

pub fn init() void {
    terminal.init();
}