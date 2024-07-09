/* _PDCLIB_Exit( int )

   This file is part of the Public Domain C Library (PDCLib).
   Permission is granted to use, modify, and / or redistribute at will.
*/

/* This is an example implementation of _PDCLIB_Exit() fit for use with POSIX
   kernels.
*/

#include <stdlib.h>
#include <stdio.h>

#ifndef REGTEST

#include "pdclib/_PDCLIB_glue.h"

#ifdef __cplusplus
extern "C" {
#endif

_PDCLIB_Noreturn void _exit( int status ) {
    printf("exit %d. Halting.\n", status);
    __asm__("hlt");
}

#ifdef __cplusplus
}
#endif

void _PDCLIB_Exit( int status )
{
    _exit( status );
}

#endif

#ifdef TEST

#include "_PDCLIB_test.h"

int main( void )
{
#ifndef REGTEST
    int UNEXPECTED_RETURN = 0;
    _PDCLIB_Exit( 0 );
    TESTCASE( UNEXPECTED_RETURN );
#endif
    return TEST_RESULTS;
}

#endif
