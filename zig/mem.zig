const std = @import("std");

extern const kernel_end: u8;
var kernel_brk : usize = 0;

export fn sbrk( increment: usize) *u8 {
    return @ptrFromInt(sbrk_internal(increment));
}

fn sbrk_internal (increment: usize) usize  {
    // Unfortunately this can't be done comptime
    if (kernel_brk == 0) {
        kernel_brk = @intFromPtr(&kernel_end);
    }
    const last_brk = kernel_brk;
    kernel_brk = kernel_brk + increment;
    // This isn't really a pointer to a u8. It's a watermark in memory so we need to tell zig to trust us here.
    return last_brk;
}


const alloc = std.heap.SbrkAllocator(sbrk_internal);

pub var allocator = std.mem.Allocator{
    .ptr = @ptrCast(@constCast(&alloc)),
    .vtable = &alloc.vtable,
};
