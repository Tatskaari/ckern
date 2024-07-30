const std = @import("std");

// This is a placeholder implementation until we can figure out a proper allocator
extern fn malloc(size: usize) callconv(.C) [*]u8;

pub var alloc : std.heap.FixedBufferAllocator = undefined;

const MEM_SIZE = 1024 * 256; // 256kb

pub fn init() void {
    const heap = malloc(MEM_SIZE)[0..MEM_SIZE];
    alloc = std.heap.FixedBufferAllocator.init(heap);
}