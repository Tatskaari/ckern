subinclude("//build_defs:multiboot")

c_library(
    name = "serial",
    srcs = ["serial.c"],
    hdrs = ["serial.h"],
    visibility = ["PUBLIC"],
    deps = [
        "//src/asm",
        "//src/libc/stdio",
        "//zig",
    ],
)

freestanding_test(
    name = "serial_test",
    srcs = ["serial_test.c"],
    expected_output = "Hello, world!",
    # TODO this is all grungy because serial is actually implemented in zig, but zig doesn't export its deps properly.
    # Everything will be fine once we migrate more to zig though.
    deps = [
        ":serial",
        "//src/files",
        "//src/kernel",
        "//src/qemu",
        "//zig",
    ],
)
