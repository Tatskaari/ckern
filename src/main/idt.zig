const terminal = @import("terminal.zig");

const KERNEL_CS: u16 = 0x0010;
const KERNEL_DS: u16 = 0x0018;

const IDTEntry = extern struct {
    isr_low: u16,
    kernel_cs: u16,
    reserved: u8 = 0,
    attributes: u8,
    isr_high: u16,
};

// Interrupt Descriptor Table Register:
const IDTR = extern struct {
    limit: u16,
    base: u64,
};

const vectorCount = 32;
export var idt: [256]IDTEntry = undefined;

fn setDescriptor(vector: usize, isrPtr: *const anyopaque, attributes: u8) void {
    var entry = &idt[vector];
    entry.isr_low = @intCast(@intFromPtr(isrPtr) & 0xFFFF);
    entry.kernel_cs = KERNEL_CS;
    entry.attributes = attributes;
    entry.isr_high = @intCast((@intFromPtr(isrPtr) >> 16) & 0xFFFF);
}

export fn isrWrapper() callconv(.Naked) void {
    asm volatile (
        \\ call isr
        \\ iretl
        ::
    );
}

const State = extern struct {
    eip: u32,
    cs: u32,
    eflags: u32,
};

export fn isr(state: State) void {
    terminal.print("Exception thrown! eip: {}, cs: {}, eflags: {}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

pub fn init() void {
    const idtr = IDTR{
        .base = @intFromPtr(&idt[0]),
        .limit = (@sizeOf(IDTEntry) * vectorCount) - 1
    };

    for(0..vectorCount) |vector| {
        setDescriptor(vector, @as(*const anyopaque, isrWrapper), 0x8E);
    }

    asm volatile (
        \\ lidt %[idt]
        :
        : [idt] "m" (idtr),
    );
}
