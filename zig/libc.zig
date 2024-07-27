// These are functions that will be available when we're linked into the C binary
pub extern fn printf(format: [*:0]const u8, ...) c_int;
