c_library(
    name = "_PDCLIB",
    srcs = glob("*.c"),
    visibility = ["PUBLIC"],
    deps = [
        "//include/libc:assert",
        "//include/libc/pdclib",
        "//src/libc/ctype",
        "//src/libc/inttypes",
        "//src/libc/locale",
        "//src/libc/platform/functions/_PDCLIB",
        "//src/libc/stdlib",
        "//src/libc/string",
    ],
)
