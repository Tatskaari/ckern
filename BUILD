subinclude("//build_defs:multiboot")

genrule(
    name = "iso",
    srcs = {
        "bin": ["//src/main"],
        "boot": ["boot"],
    },
    outs = ["ckern.iso"],
    cmd = ["mv $SRCS_BIN boot && mkdir _boot && mv boot _boot && $TOOL -o $OUT _boot"],
    tools = ["grub-mkrescue"],
)

sh_cmd(
    name = "run",
    cmd = "qemu-system-x86_64 -no-reboot -serial stdio -cdrom $(out_location //:iso) ",
    data = ["//:iso"],
)

sh_cmd(
    name = "debug",
    cmd = "(pgrep -f qemu-system-x86_64 | xargs kill -9); qemu-system-x86_64 -d int -s -S -no-reboot -serial stdio -cdrom $(out_location //:iso) &",
    data = ["//:iso"],
)
