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
    cmd = "qemu-system-i386 -d int -no-reboot -serial stdio -kernel $(out_location //src/main) ",
    data = ["//src/main"],
)

sh_cmd(
    name = "debug",
    cmd = "(pgrep -f qemu-system-i386 | xargs kill -9); qemu-system-i386 -d int -s -S -no-reboot -serial stdio -kernel $(out_location //src/main) &",
    data = ["//src/main"],
)
