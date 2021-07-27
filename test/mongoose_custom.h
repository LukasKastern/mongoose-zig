// Required by the test ARM build
#pragma once

#define _GNU_SOURCE  // For fopencookie()

#include <errno.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define MG_DIRSEP '/'
#define MG_INT64_FMT "%lld"
#undef MG_PATH_MAX
#define MG_PATH_MAX 100
#undef MG_ENABLE_SOCKET
#define MG_ENABLE_SOCKET 0

#define realpath(a, b) (a)

int clock_gettime(clockid_t clock_id, struct timespec *tp);
