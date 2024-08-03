subinclude("//build_defs:zig")

zig_kernel(
    name = "main",
    srcs = glob("**.zig"),
    root = "main.zig",
    linker = "linker.ld",
    boot = "boot.s",
    visibility = ["PUBLIC"],
)
