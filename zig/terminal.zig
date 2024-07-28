const libc = @import("libc.zig");

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
    row: u16,
    col: u16,
    colour: VGAEntryColour,
    buf: []volatile u16,

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

    pub fn write(self: *VGATerminal, buffer: [*]const u8, count: usize) !usize {
        _ = self;
        _ = buffer;
        _ = count;

        return 0;
    }

    pub fn clear(self: *VGATerminal) void {
        @memset(self.buf, vgaEntry(' ', self.colour));
    }
};

pub fn entry_colour(fg: VGAColor, bg: VGAColor) VGAEntryColour {
    return @intFromEnum(fg) | (@intFromEnum(bg) << 4);
}

fn vgaEntry(char: u8, colour: u8) u16 {
    const c : u16 = colour;
    return char | (c << 8);
}
