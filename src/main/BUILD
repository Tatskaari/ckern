subinclude("//build_defs:multiboot")

freestanding_binary(
    name = "main",
    deps=["//src/libc/stdio", "//src/kernel"],
    srcs = ["main.c", "boot.s"],
    linker_script = "linker.ld",
    visibility = ["PUBLIC"],
)

