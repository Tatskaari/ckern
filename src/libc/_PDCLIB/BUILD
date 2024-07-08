c_library(
    name = "_PDCLIB",
    srcs = glob("*.c"),
    visibility = ["PUBLIC"],
    deps = [
        "//include/libc",
        "//src/libc/platform/include",
        "//src/libc/locale",
        "//src/libc/stdlib",
        "//src/libc/inttypes",
        "//src/libc/string",
        "//src/libc/ctype",
    ],
)