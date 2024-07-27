#include <stdio.h>

#include "../serial/serial.h"
#include "../terminal/terminal.h"
#include "../files/files.h"

extern int zig_test();

int main(void) {
    /* Initialize terminal interface */
    terminal_initialize();
    serial_init(COM1);


    // Posix expects these registered at these file handles.
    register_file_handle(0, "/dev/stdin", NULL, NULL);
    register_file_handle(1, "/dev/stdout", NULL, terminal_write);
    register_file_handle(2, "/dev/stderr", NULL, NULL);

    printf("from zig: %d\n", zig_test());
}
