const std = @import("std");

const WriteError = error{};

pub const VGAColor = enum(u8) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGrey = 7,
    DarkGrey = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

pub const VGAEntryColour = u8;

pub var Terminal1 = VGATerminal{
    .width = 0,
    .height = 0,
    .row = 0,
    .col = 0,
    .buf = undefined,
    .colour = undefined,
};

pub const VGATerminal = struct {
    width: u16,
    height: u16,
    row: u8,
    col: u8,
    colour: VGAEntryColour,
    buf: []volatile u16,

    const Writer = std.io.Writer(
        *VGATerminal,
        WriteError,
        writeAll,
    );

    pub fn writer(self: *VGATerminal) Writer {
        return .{ .context = self };
    }

    pub fn init(self: *VGATerminal, width: u16, height: u16, colour: VGAEntryColour) void {
        var buf = @as([*]volatile u16, @ptrFromInt(0xB8000));
        self.buf = buf[0..width*height];

        self.width = width;
        self.height = height;
        self.col = 0;
        self.row = 0;

        self.colour = colour;

        self.clear();
    }

    fn putentryat(self: *VGATerminal, c: u8, color: VGAEntryColour, x: u8, y: u8) void {
        const index = y * self.width + x;
        self.buf[index] = vgaEntry(c, color);
    }

    pub fn write(self: *VGATerminal, char: u8) void {
        if (char == '\n') {
            self.row = self.row+1;
            self.col = 0;
            return;
        }
        self.putentryat(char, self.colour, self.col, self.row);
        self.col = self.col+1;
        if (self.col > self.width) {
            self.col = 0;
            self.row = self.row+1;
            // Just wrap around from the top. We could try and shuffle everythign up one column but meh.
            if (self.row > self.height) {
                self.row = 0;
            }
        }
    }

    pub fn writeAll(self: *VGATerminal, bytes: []const u8) WriteError!usize {
        for(bytes) |c| {
            self.write(c);
        }
        return bytes.len;
    }

    pub fn clear(self: *VGATerminal) void {
        @memset(self.buf, vgaEntry(' ', self.colour));
    }
};

pub fn entryColour(fg: VGAColor, bg: VGAColor) VGAEntryColour {
    return @intFromEnum(fg) | (@intFromEnum(bg) << 4);
}

fn vgaEntry(char: u8, colour: VGAEntryColour) u16 {
    const c : u16 = @intCast(colour);
    return char | (c << 8);
}

pub fn init() void {
    Terminal1.init(80, 25, entryColour(VGAColor.LightGreen, VGAColor.Black));
}

pub fn print(comptime format: []const u8, args: anytype) void {
    const w = Terminal1.writer();

    std.fmt.format(w, format, args) catch unreachable;
}