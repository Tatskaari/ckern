const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MB1_MAGIC: u32 = 0x1BADB002;
const FLAGS: u32 = ALIGN | MEMINFO;

const MultibootHeader = extern struct {
    magic: u32 = MB1_MAGIC,
    flags: u32,
    checksum: u32,
};

export var multiboot align(4) linksection(".multiboot") = MultibootHeader {
    .flags = FLAGS,
    .checksum = @intCast(((-(@as(i64, MB1_MAGIC) + @as(i64, FLAGS))) & 0xFFFFFFFF)),
};

var stack: [64 * 1024]u8 align(16) = undefined;
export fn _start() callconv(.Naked) noreturn {
    asm volatile (
        \\ movl %[stk], %esp
        \\ movl %esp, %ebp
        \\ call main
        :
        : [stk] "{ecx}" (@intFromPtr(&stack) + @sizeOf(@TypeOf(stack))),
    );
    while (true) {}
}

const std = @import("std");
const serial = @import("serial.zig");
const terminal = @import("terminal.zig");
const pci = @import("pci.zig");
const mem = @import("mem.zig");


export fn main() i32 {
    terminal.init();
    var com1 = serial.SerialPort{ .Port = serial.COM1 };
    com1.init() catch {
        terminal.print("Failed to initialize COM1\n", .{});
        return -1;
    };
    _ = terminal.Terminal1.writeAll("test") catch unreachable;

    const a = mem.allocator.alloc(u8, 1) catch unreachable;
    mem.allocator.free(a);

    pci.lspci();
    return 0;
}