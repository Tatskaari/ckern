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

extern fn serial_write(port: u16, data: [*]const u8, count: usize) usize;
extern fn serial_init(port: u16) usize;

pub const SerialPortFile = struct {
    Port: u16,

    pub fn init(self: *SerialPortFile) !void {
        const result = serial_init(self.Port);
        if (result != 0) {
            return SerialError.InitFailed;
        }
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

pub fn serial_read(port: u16, dest: []u8, count: u32 ) u32 {
    for(0..count) |i| {
        dest[i] = sgetc(port);
    }
    // We always read count, but this conforms to the file writing signature which makes posix-ing more easier
    // We can monkey patch this into a file descriptor later.
    return count;
}

