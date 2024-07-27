const libasm = @import("asm.zig");

const SerialError = error{
    InitFailed,
};

const IOError = error{
    ReadFailed,
    WriteFailed,
};

pub const COM1: u16 = 0x3F8;
pub const COM2: u16 = 0x2F8;
pub const COM3: u16 = 0x3E8;
pub const COM4: u16 = 0x2E8;

pub const SerialPortFile = struct {
    Port: u16,

    pub fn init(self: *SerialPortFile) !void {
        try serial_init(self.Port);
    }

    pub fn read(self: *SerialPortFile, buffer: []u8, count: usize) !usize {
        const nread = serial_read(self.Port, buffer, count);
        if (nread < 0) {
            return IOError.ReadFailed;
        }
        return nread;
    }

    pub fn write(self: *SerialPortFile, buffer: [*]const u8, count: usize) !usize {
        const nwrite = serial_write(self.Port, buffer, count);
        if (nwrite < 0) {
            return IOError.WriteFailed;
        }
        return count;
    }
};

pub fn serial_received(port: u16) u8 {
    return libasm.inb(port + 5) & 1;
}

pub fn sgetc(port: u16) u8 {
    // Hang until we get a byte
    while (serial_received(port) == 0) {}
    return libasm.inb(port);
}

pub fn serial_read(port: u16, dest: []u8, count: usize) usize {
    for (0..count) |i| {
        dest[i] = sgetc(port);
    }
    // We always read count, but this conforms to the file writing signature which makes posix-ing more easier
    // We can monkey patch this into a file descriptor later.
    return count;
}

fn is_transmit_empty(port: u16) bool {
    return libasm.inb(port + 5) & 0x20 == 0;
}

fn writec(port: u16, c: u8) void {
    while (is_transmit_empty(port)) {}
    libasm.outb(port, c);
}

fn serial_write(port: u16, data: [*]const u8, count: usize) usize {
    for (0..count) |i| {
        writec(port, data[i]);
    }
    return count;
}

fn serial_init(port: u16) !void {
    // TODO use bitmasks because the tutorial is horrible
    libasm.outb(port + 1, 0x00); // Disable all interrupts
    libasm.outb(port + 3, 0x80); // Enable DLAB (set baud rate divisor)
    libasm.outb(port + 0, 0x03); // Set divisor to 3 (lo byte) 38400 baud
    libasm.outb(port + 1, 0x00); //                  (hi byte)
    libasm.outb(port + 3, 0x03); // 8 bits, no parity, one stop bit
    libasm.outb(port + 2, 0xC7); // Enable FIFO, clear them, with 14-byte threshold
    libasm.outb(port + 4, 0x0B); // IRQs enabled, RTS/DSR set

    libasm.outb(port + 4, 0x1E); // Set in loopback mode, test the serial chip
    libasm.outb(port + 0, 0xAE); // Test serial chip (send byte 0xAE and check if serial returns same byte)

    // Check if serial is faulty (i.e: not same byte as sent)
    if (libasm.inb(port + 0) != 0xAE) {
        return SerialError.InitFailed;
    }

    // If serial is not faulty set it in normal operation mode
    // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
    libasm.outb(port + 4, 0x0F);
}
