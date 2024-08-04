const std = @import("std");
const serial = @import("serial.zig");
const terminal = @import("terminal.zig");
const pci = @import("pci.zig");
const mem = @import("mem.zig");
const idt = @import("idt.zig");

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MB1_MAGIC: u32 = 0x1BADB002;
const FLAGS: u32 = ALIGN | MEMINFO;

const MultibootHeader = extern struct {
    magic: u32 = MB1_MAGIC,
    flags: u32,
    checksum: u32,
};

export var multiboot align(4) linksection(".multiboot") = MultibootHeader{
    .flags = FLAGS,
    .checksum = @intCast(((-(@as(i64, MB1_MAGIC) + @as(i64, FLAGS))) & 0xFFFFFFFF)),
};

const STACK_SIZE = 16 * 2024;
export var stack: [STACK_SIZE]u8 align(16) linksection(".bss") = undefined;
export fn _start() linksection(".text") callconv(.Naked) noreturn {
    const asmStr = std.fmt.comptimePrint(
        \\ leaq stack + {}, %rsp
        \\ call main
    , .{STACK_SIZE});
    asm volatile (asmStr
        :
        : [stk] "r" (@intFromPtr(&stack) + @sizeOf(@TypeOf(stack))),
        : "esp"
    );
    while (true) {}
}

export fn main() i32 {
    _ = serial.open(serial.COM1 + 1) catch unreachable;
    serial.writec(serial.COM1, 'a');

    while (true) {}
    idt.init();
    terminal.init();

    pci.lspci();
    // This should trigger our custom interupt!
    asm volatile ("int $0x10");
    terminal.print("This should come after\n", .{});
    return 0;
}
