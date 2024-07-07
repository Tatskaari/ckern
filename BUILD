subinclude("//build_defs:multiboot")

genrule(
    name = "iso",
    srcs = {
        "bin": ["//src/main"],
        "boot": ["boot"],
    },
    cmd = ["mv $SRCS_BIN $SRCS_BOOT && $TOOL -o $OUT $SRCS_BOOT"],
    outs = ["ckern.iso"],
    tools = ["grub-mkrescue"],
)

sh_cmd(
    name = "run",
    data = ["//src/main"],
    cmd = "qemu-system-i386 -kernel $(out_location //src/main)",
)
