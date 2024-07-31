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
        "//src/libc/stdio",
        "//src/serial",
        "//src/terminal",
        "//zig",
    ],
)
