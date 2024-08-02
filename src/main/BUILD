subinclude("//build_defs:zig")

c_object(
    name = "boot",
    src = "boot.s",
)

zig_library(
    name = "main",
    srcs = glob("**.zig"),
    root = "root.zig",
    linker = "linker.ld",
    visibility = ["PUBLIC"],
    deps = [":boot"],
)
