subinclude("//build_defs:multiboot")

c_library(
    name = "files",
    srcs = ["files.c"],
    hdrs = ["files.h"],
    visibility = ["PUBLIC"],
    deps = [
        "//src/libc/stdlib",
        "//src/libc/string",
        "//src/serial",
    ],
)

freestanding_test(
    name = "serial_test",
    srcs = ["files_test.c"],
    deps = [
        "//src/kernel",
        ":files",
        "//src/qemu",
    ],
    expected_output = "This should print to com0!",
)