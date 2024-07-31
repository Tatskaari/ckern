const std = @import("std");

// This is a placeholder implementation until we can figure out a proper allocator
extern fn malloc(size: usize) callconv(.C) [*]u8;

pub var alloc : std.heap.FixedBufferAllocator = undefined;

const MEM_SIZE = 1024 * 256; // 256kb

extern const kernel_end: u8;
var kernel_brk = &kernel_end;

export fn sbrk( increment: usize) *u8 {
    const last_brk = kernel_brk;
    kernel_brk = @ptrFromInt(@intFromPtr(kernel_brk) + increment);
    // This isn't really a pointer to a u8. It's a watermark in memory so we need to tell zig to trust us here.
    return @constCast(last_brk);
}

pub fn init() void {
    const heap = malloc(MEM_SIZE)[0..MEM_SIZE];
    alloc = std.heap.FixedBufferAllocator.init(heap);
}