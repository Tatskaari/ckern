c_library(
    name = "stdlib",
    srcs = glob("*"),
    visibility = ["PUBLIC"],
    deps = [
        "//include/libc:stdint",
        "//include/libc:stdlib",
        "//include/libc/pdclib",
        "//src/libc/platform/functions/_PDCLIB",
        "//src/libc/platform/functions/signal",
    ],
)
