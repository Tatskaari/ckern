cmake_minimum_required(VERSION 3.27)
project(ckern C)


set(CMAKE_C_STANDARD 11)


add_executable(ckern
        kernel.c
        bootstrap.s
        src/std/string.cpp)

add_library(strings src/std/string.cpp)
add_library(include include/kernel/kernel.h include/kernel/malloc.h
        include/std/string.h
        include/std/writer.h)
