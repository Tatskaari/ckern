#include <std/string.h>
#include <kernel/kernel.h>

extern "C" void kernel_main(void)
{

    /* Initialize terminal interface */
    terminal::initialize();

    /* Newline support is left as an exercise. */
    terminal::writestring("Hello, main!\n");
    terminal::writestring("If you're using qemu, to get your mouse back, press ctr-alt or ctr-alt-g\n");
}