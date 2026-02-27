#ifndef COMPAT_H
#define COMPAT_H

#ifdef _WIN32

#undef _WIN32_WINNT
#define _WIN32_WINNT 0x0600
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <getopt.h>
#include <stdarg.h>
#include <stdio.h>
#include <errno.h>

/* dprintf does not exist on Windows */
static inline int compat_dprintf(int fd, const char *fmt, ...) {
	va_list ap;
	va_start(ap, fmt);
	int ret = vfprintf(fd == 1 ? stdout : stderr, fmt, ap);
	va_end(ap);
	return ret;
}
#define dprintf compat_dprintf

#define SOCK_CLOSE(fd) closesocket(fd)
#define SOCK_READ(fd, buf, len) recv(fd, (char*)(buf), len, 0)
#define SOCK_WRITE(fd, buf, len) send(fd, (const char*)(buf), len, 0)

#define usleep(x) Sleep(((x) + 999) / 1000)

static inline void platform_init(void) {
	WSADATA wsa;
	WSAStartup(MAKEWORD(2, 2), &wsa);
}

#else /* POSIX */

#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>

#define SOCK_CLOSE(fd) close(fd)
#define SOCK_READ(fd, buf, len) read(fd, buf, len)
#define SOCK_WRITE(fd, buf, len) write(fd, buf, len)

static inline void platform_init(void) {}

#endif /* _WIN32 */

#endif /* COMPAT_H */
