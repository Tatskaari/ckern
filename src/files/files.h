//
// Created by jpoole on 7/10/24.
//

#ifndef CKERN_FILES_H
#define CKERN_FILES_H

typedef int (ReadFunc)(char* dest, int count);
typedef int (WriteFunc)(const char* data, int count);

struct FileInfo {
    char* path;
};

struct FileHandle {
    struct FileInfo info;
    ReadFunc* read;
    WriteFunc* write;
};

struct FileHandle* get_file_handle(int fd);
int register_file_handle(int fd, const char* path, ReadFunc* read, WriteFunc* write);
void close_file_handle(int fd);
int open( const char * const filename, unsigned int mode );

#endif //CKERN_FILES_H
