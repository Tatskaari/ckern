subinclude("//build_defs:multiboot")

freestanding_binary(
    name = "main",
    srcs = [
        "boot.s",
        "main.c",
    ],
    linker_script = "linker.ld",
    visibility = ["PUBLIC"],
    deps = [
        "//src/kernel",
        "//src/libc/stdio",
        "//src/serial",
    ],
)
