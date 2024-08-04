const terminal = @import("../../kernel/index.zig").terminal;

const IDTEntry = extern struct {
    isr_low: u16,
    kernel_cs: u16,
    reserved: u8 = 0,
    attributes: u8,
    isr_high: u16,
};

// Interrupt Descriptor Table Register:
const IDTR = packed struct(u48) {
    limit: u16,
    base: u32,
};

var idt: [256]IDTEntry = undefined;

fn setDescriptor(vector: usize, isrPtr: usize, attributes: u8) void {
    var entry = &idt[vector];
    entry.isr_low = @intCast(isrPtr & 0xFFFF);
    // TODO we should probably just set this up ourselves so we know what the kernel code segment is
    entry.kernel_cs = getCS();
    entry.attributes = attributes;
    entry.isr_high = @intCast((isrPtr >> 16) & 0xFFFF);
}

pub const InterruptStackFrame = extern struct {
    eflags: u32,
    eip: u32,
    cs: u32,
    stack_pointer: u32,
    stack_segment: u32,
};

export fn divErrISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Div by zero! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn debugISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Debug interupt! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
}

export fn nonMaskableISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Non-maskable interupt! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn breakpointISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Breakpoint interupt! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
}

export fn overflowISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Overflow error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn boundRangeExceededISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Bound range exceeded error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn invalidOpcodeISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Invalid op code! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn deviceNotAvailableISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Device not available error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn doubleFaultISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Double fault! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn invalidTSSISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Ivalid TSS error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn segmentNotPresentISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Segment not present error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn stackSegFaultISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Seg fault! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn gpaFaultISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("GPA fault! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn pageFaultISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Page fault! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn fpuErrISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("FPU error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

export fn alignCheckISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Align check (not handled)! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
}

export fn machineCheckISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Machine check (not handled)! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
}

export fn simdErrISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("SIMD error! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
    while(true){}
}

// This is just a PoC to prove I can trigger and dispatch software interrupts
export fn customISR(state: *InterruptStackFrame) callconv(.Interrupt) void {
    terminal.print("Custom! eip: 0x{x}, cs: 0x{x}, eflags: 0x{x}\n", .{state.eip, state.cs, state.eflags});
}

pub inline fn getCS() u16 {
    return asm volatile ("mov %cs, %[result]"
        : [result] "=r" (-> u16),
    );
}

pub fn init() void {
    setDescriptor(0, @intFromPtr(&divErrISR), 0x8E);
    setDescriptor(1, @intFromPtr(&debugISR), 0x8E);
    setDescriptor(2, @intFromPtr(&nonMaskableISR), 0x8E);
    setDescriptor(3, @intFromPtr(&breakpointISR), 0x8E);
    setDescriptor(4, @intFromPtr(&overflowISR), 0x8E);
    setDescriptor(5, @intFromPtr(&boundRangeExceededISR), 0x8E);
    setDescriptor(6, @intFromPtr(&invalidOpcodeISR), 0x8E);
    setDescriptor(7, @intFromPtr(&deviceNotAvailableISR), 0x8E);
    setDescriptor(8, @intFromPtr(&doubleFaultISR), 0x8E);
    setDescriptor(10, @intFromPtr(&invalidTSSISR), 0x8E);
    setDescriptor(11, @intFromPtr(&segmentNotPresentISR), 0x8E);
    setDescriptor(12, @intFromPtr(&stackSegFaultISR), 0x8E);
    setDescriptor(13, @intFromPtr(&gpaFaultISR), 0x8E);
    setDescriptor(14, @intFromPtr(&pageFaultISR), 0x8E);
    setDescriptor(16, @intFromPtr(&fpuErrISR), 0x8E);
    setDescriptor(17, @intFromPtr(&alignCheckISR), 0x8E);
    setDescriptor(18, @intFromPtr(&machineCheckISR), 0x8E);
    setDescriptor(19, @intFromPtr(&simdErrISR), 0x8E);

    // Just 'cus we can
    setDescriptor(0x10, @intFromPtr(&customISR), 0x8E);

    load();
}

fn load() void {
    const idtr = IDTR{
        .base = @intFromPtr(&idt[0]),
        .limit = (@sizeOf(@TypeOf(idt))) - 1
    };

    asm volatile ("lidt %[p]"
        :
        : [p] "*p" (&idtr),
    );
}