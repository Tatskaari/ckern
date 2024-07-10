c_library(
    name = "_PDCLIB",
    srcs = glob("*.c"),
    visibility = ["PUBLIC"],
    deps = [
        "//include/libc:errno",
        "//include/libc:locale",
        "//include/libc:stdlib",
        "//include/libc:stdio",
        "//include/libc:string",
        "//include/libc:time",
        "//include/libc/pdclib",
        "//src/libc/platform/include",
    ],
)
