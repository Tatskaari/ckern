subinclude("//build_defs:multiboot")

filegroup(
    name = "linker.ld",
    srcs = ["linker.ld"],
    visibility = ["PUBLIC"],
)

filegroup(
    name = "boot.s",
    srcs = ["boot.s"],
    visibility = ["PUBLIC"],
)

freestanding_binary(
    name = "main",
    srcs = [
        "main.c",
    ],
    visibility = ["PUBLIC"],
    deps = [
        "//src/files",
        "//src/kernel",
        "//src/libc/stdio",
        "//src/qemu",
        "//src/serial",
        "//src/terminal",
        "//zig",
    ],
)
