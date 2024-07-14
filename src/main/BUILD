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
        "boot.s",
        "main.c",
    ],
    visibility = ["PUBLIC"],
    deps = [
        "//src/files",
        "//src/terminal",
        "//src/libc/stdio",
        "//src/serial",
        "//src/qemu",
    ],
)
