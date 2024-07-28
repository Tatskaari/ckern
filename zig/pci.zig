const std = @import("std");
const libc = @import("libc.zig");
const x86 = @import("x86.zig");

// THese are teh ports that PCI uses to enable software to read the PCI config
const PCI_CONFIG_ADDRESS = 0xCF8;
const PCI_CONFIG_DATA = 0xCFC;

const Class = enum(u8) {
    Unclassified,
    MassStorage,
    Network,
    Display,
    Multimedia,
    Memory,
    Bridge,
};

pub const PciAddress = packed struct {
    offset: u8,
    function: u3,
    slot: u5,
    bus: u8,
    reserved: u7,
    enable: u1,
};

fn format_class(class: u8) [*:0]const u8 {
    switch (class) {
        @intFromEnum(Class.Unclassified),
        @intFromEnum(Class.MassStorage),
        @intFromEnum(Class.Network),
        @intFromEnum(Class.Display),
        @intFromEnum(Class.Multimedia),
        @intFromEnum(Class.Memory),
        @intFromEnum(Class.Bridge) => {
            const c : Class = @enumFromInt(class);
            return @tagName(c);
        },
        else => return "Unknown class",
    }
}

pub const PciDevice = struct {
    bus: u8,
    slot: u5,
    function: u3,
    vendor: u16 = undefined,

    pub fn address(self: PciDevice, offset: u8) PciAddress {
        return PciAddress{
            .enable = 1,
            .reserved = 0,
            .bus = self.bus,
            .slot = self.slot,
            .function = self.function,
            .offset = offset,
        };
    }

    // 0                   1                   2                   3
    // 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
    // +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    // |           vendor ID           |           device ID           |
    // +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    // |            command            |             status            |
    // +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    // |  revision ID  |    prog IF    |    subclass   |     class     |
    // +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    // |cache line size| latency timer |   header type |      bist     |
    // +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    pub fn vendor_id(self: PciDevice) u16 {
        return self.config_read(u16, 0x0);
    }
    pub fn device(self: PciDevice) u16 {
        return self.config_read(u16, 0x2);
    }
    pub fn subclass(self: PciDevice) u8 {
        return self.config_read(u8, 0xa);
    }
    pub fn class(self: PciDevice) u8 {
        return self.config_read(u8, 0xb);
    }
    pub fn header_type(self: PciDevice) u8 {
        return self.config_read(u8, 0xe);
    }
    pub fn intr_line(self: PciDevice) u8 {
        return self.config_read(u8, 0x3c);
    }
    pub fn bar(self: PciDevice, n: usize) u32 {
        return self.config_read(u32, 0x10 + 4 * n);
    }
    // only for header_type == 0
    pub fn subsystem(self: PciDevice) u16 {
        return self.config_read(u8, 0x2e);
    }

    pub fn format(self: PciDevice) void {
        const slot : u8 = @intCast(self.slot);
        const function : u8 = @intCast(self.function);

        _ = libc.printf("%d:%d.%d: ", self.bus, slot, function);
        _ = libc.printf(" class: %s, subclass: %d, vendor id: %d\n", format_class(self.class()), self.subclass(), self.vendor);
    }

    pub inline fn config_read(self: PciDevice, comptime size: type, comptime offset: u8) size {
        // ask for access before reading config
        x86.outl(PCI_CONFIG_ADDRESS, @bitCast(self.address(offset)));
        switch (size) {
            // read the correct size
            u8 => return x86.inb(PCI_CONFIG_DATA),
            u16 => return x86.inw(PCI_CONFIG_DATA),
            u32 => return x86.inl(PCI_CONFIG_DATA),
            else => @compileError("pci only support reading up to 32 bits"),
        }
    }
};

pub fn init(bus: u8, slot: u5, function: u3) ?PciDevice {
    var dev = PciDevice{ .bus = bus, .slot = slot, .function = function };
    dev.vendor = dev.vendor_id();
    if (dev.vendor == 0xffff) return null;
    return dev;
}

pub fn lspci() void {
    var slot: u5 = 0;
    while (slot < 31) : (slot += 1) {
        // Check if the device exists at that slot first.
        if (init(0, slot, 0)) |_| {
            var function: u3 = 0;
            // 0..7
            while (function < 7) : (function += 1) {
                if (init(0, slot, function)) |vf| {
                    vf.format();
                }
            }
        }
    }
}
