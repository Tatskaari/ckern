/* Stack goes in the .bss section which is a read/writeable section in our binary */
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/* Call the main function of the binary after setting the stack pointer */
.section .text
.global _start
.type _start, @function
_start:
	mov $stack_top, %esp
	call main
	cli
1:	hlt
	jmp 1b

/*
Set the size of the _start symbol to the current location '.' minus its start.
This is useful when debugging or when you implement call tracing.
*/
.size _start, . - _start