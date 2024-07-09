c_library(
    name = "stdio",
    srcs = glob(["*.c"]),
    visibility = ["PUBLIC"],
    deps = [
        "//include/libc",
        "//src/libc/_PDCLIB",
        "//src/libc/_dlmalloc",
        "//src/libc/platform/functions/_PDCLIB",
        "//src/libc/platform/include",
    ],
)
