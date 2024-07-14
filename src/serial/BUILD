subinclude("//build_defs:multiboot")

c_library(
    name = "serial",
    srcs = ["serial.c"],
    hdrs = ["serial.h"],
    visibility = ["PUBLIC"],
    deps = [
        "//src/libc/stdio",
        "//src/asm",
    ],
)

freestanding_test(
    name = "serial_test",
    srcs = ["serial_test.c"],
    deps = [":serial", "//src/qemu"],
    expected_output = "Hello, world!",
)