subinclude("//build_defs:multiboot")

freestanding_binary(
    name = "main",
    deps=["//src/std", "//src/kernel"],
    srcs = ["main.cpp", "boot.s"],
    linker_script = "linker.ld",
    visibility = ["PUBLIC"],
)

