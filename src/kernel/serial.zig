const ports = @import("../arch/index.zig").host.ports;

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

pub const SerialPort = struct {
    Port: u16,

    pub fn init(self: *SerialPort) !void {
        const result = serial_init(self.Port);
        if (result != 0) {
            return SerialError.InitFailed;
        }
    }

    pub fn read(self: *SerialPort, buffer: [*]u8, count: usize) !usize {
        const nread = serial_read(self.Port, buffer, count);
        if (nread < 0) {
            return IOError.ReadFailed;
        }
        return nread;
    }

    pub fn write(self: *SerialPort, buffer: [*]const u8, count: usize) !usize {
        const nwrite = serial_write(self.Port, buffer, count);
        if (nwrite < 0) {
            return IOError.WriteFailed;
        }
        return count;
    }
};

pub fn serial_received(port: u16) u8 {
    return ports.inb(port + 5) & 1;
}

pub fn sgetc(port: u16) u8 {
    // Hang until we get a byte
    while (serial_received(port) == 0) {}
    return ports.inb(port);
}

pub export fn serial_read(port: u16, dest: [*]u8, count: usize) usize {
    for (0..count) |i| {
        dest[i] = sgetc(port);
    }
    // We always read count, but this conforms to the file writing signature which makes posix-ing more easier
    // We can monkey patch this into a file descriptor later.
    return count;
}

fn is_transmit_empty(port: u16) bool {
    return ports.inb(port + 5) & 0x20 == 0;
}

fn writec(port: u16, c: u8) void {
    while (is_transmit_empty(port)) {}
    ports.outb(port, c);
}

export fn serial_write(port: u16, data: [*]const u8, count: usize) usize {
    for (0..count) |i| {
        writec(port, data[i]);
    }
    return count;
}

export fn serial_init(port: u16) i8 {
    // TODO use bitmasks because the tutorial is horrible
    ports.outb(port + 1, 0x00); // Disable all interrupts
    ports.outb(port + 3, 0x80); // Enable DLAB (set baud rate divisor)
    ports.outb(port + 0, 0x03); // Set divisor to 3 (lo byte) 38400 baud
    ports.outb(port + 1, 0x00); //                  (hi byte)
    ports.outb(port + 3, 0x03); // 8 bits, no parity, one stop bit
    ports.outb(port + 2, 0xC7); // Enable FIFO, clear them, with 14-byte threshold
    ports.outb(port + 4, 0x0B); // IRQs enabled, RTS/DSR set

    ports.outb(port + 4, 0x1E); // Set in loopback mode, test the serial chip
    ports.outb(port + 0, 0xAE); // Test serial chip (send byte 0xAE and check if serial returns same byte)

    // Check if serial is faulty (i.e: not same byte as sent)
    if (ports.inb(port + 0) != 0xAE) {
        return -1;
    }

    // If serial is not faulty set it in normal operation mode
    // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
    ports.outb(port + 4, 0x0F);
    return 0;
}
