pub const ports = @import("ports.zig");
pub const idt = @import("idt.zig");

pub fn init() void {
    idt.init();
}