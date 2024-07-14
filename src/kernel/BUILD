c_library(
    name = "kernel",
    srcs = glob("*.c"),
    visibility = ["PUBLIC"],
    deps = [
        "//include/libc:stdint",
        "//src/libc/_PDCLIB",
        "//src/libc/platform/functions/_PDCLIB",
    ],
)
