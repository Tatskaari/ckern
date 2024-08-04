const std = @import("std");
const arch = @import("arch/index.zig");
const kernel = @import("kernel/index.zig");
const drivers = @import("drivers/index.zig");

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
    asm volatile (std.fmt.comptimePrint(
    \\ lea stack + {}, %esp
    \\ push %eax
    \\ call main
, .{STACK_SIZE}) ::: "esp"
    );
    while (true) {}
}

const MULTI_BOOT_MAGIC = 0x2BADB002;
export fn main(multiBootMagic: u32) i32 {
    arch.init();
    kernel.init();

    if (multiBootMagic != MULTI_BOOT_MAGIC) {
        kernel.terminal.print("Failed multiboot handshake. Functionality will be limitted. Expected magic number: 0x{x}, got 0x{x}", .{MULTI_BOOT_MAGIC, multiBootMagic});
    }

    drivers.pci.lspci();
    // This should trigger our custom interupt!
    asm volatile ("int $0x10");
    kernel.terminal.print("This should come after\n", .{});
    return 0;
}
