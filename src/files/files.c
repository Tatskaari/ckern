//
// Created by jpoole on 7/10/24.
//

#include "files.h"
#include <stdlib.h>
#include <string.h>

#include "../serial/serial.h"

#define MAX_HANDLES 500

#define ERR_TOO_MANY_FILES -1
#define ERR_HANDLE_TAKEN -2
#define ERR_NOT_FOUND -3

static struct FileHandle* handles[MAX_HANDLES] = {0};

struct FileHandle* get_file_handle(int fd) {
    return handles[fd];
}

int find_free_handle() {
    for(int i = 0; i < MAX_HANDLES; i++) {
        if(handles[i] == NULL) {
            return i;
        }
    }
    return ERR_TOO_MANY_FILES;
}

int register_file_handle(int fd, const char* path, ReadFunc* read, WriteFunc* write) {
    if(handles[fd] != NULL) {
        return ERR_HANDLE_TAKEN;
    }

    handles[fd] = malloc(sizeof(struct FileHandle));
    handles[fd]->read = read;
    handles[fd]->write = write;

    handles[fd]->info.path = malloc(sizeof(char) * strlen(path)+1);
    strcpy(handles[fd]->info.path, path);
    return 0;
}

void close_file_handle(int fd) {
    free(handles[fd]);
    handles[fd] = NULL;
}

int write( int fd, const char * buf, int count) {
    struct FileHandle* h = get_file_handle(fd);
    if(h == NULL) {
        // unknown FD
        return -1;
    }
    return h->write(buf, count);
}


int open( const char * filename, unsigned int mode ) {
    // TODO this is a stub. We probably want some kind of dispatch to filesystems/mounts so we can mount com0 to
    //  be opened here.
    if(strcmp("/dev/com1", filename) == 0) {
        int fd = find_free_handle();
        int err = register_file_handle(fd, filename, com1_read, com1_write);
        if(err != 0) {
            return err;
        }
        return fd;
    }
    return ERR_NOT_FOUND;
}