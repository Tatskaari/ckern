subinclude("//build_defs:multiboot")

genrule(
    name = "iso",
    srcs = {
        "bin": ["//src/main"],
        "boot": ["boot"],
    },
    outs = ["ckern.iso"],
    cmd = ["mv $SRCS_BIN $SRCS_BOOT && $TOOL -o $OUT $SRCS_BOOT"],
    tools = ["grub-mkrescue"],
)

sh_cmd(
    name = "run",
    cmd = "qemu-system-i386 -no-reboot -serial stdio -kernel $(out_location //src/main) ",
    data = ["//src/main"],
)
