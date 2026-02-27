# if you want to change/override some variables, do so in a file called
# config.mak, which is gets included automatically if it exists.

prefix = /usr/local
bindir = $(prefix)/bin

version = $(shell cat deb/DEBIAN/control | grep Version | cut -d" " -f2)

PROG = socksd
SRCS = src/sockssrv.c src/server.c src/sblist.c src/sblist_delete.c
OBJS = $(SRCS:.c=.o)

LIBS = -lpthread

CFLAGS += -Wall -std=c99

# Windows cross-compilation
WIN_CC = x86_64-w64-mingw32-gcc
WIN_PROG = socksd-windows-amd64.exe
WIN_OBJS = $(SRCS:.c=.win.o)
WIN_LIBS = -lws2_32 -lpthread -static
WIN_CFLAGS = -Wall -std=c99 -O2

# Static Linux x86_64 (musl)
MUSL_CC = musl-gcc
STATIC_PROG = socksd-linux-amd64
STATIC_OBJS = $(SRCS:.c=.static.o)
STATIC_CFLAGS = -Wall -std=c99 -O2
STATIC_LIBS = -lpthread -static

# ARM64 cross-compilation
ARM64_CC = aarch64-linux-gnu-gcc
ARM64_PROG = socksd-linux-arm64
ARM64_OBJS = $(SRCS:.c=.arm64.o)
ARM64_CFLAGS = -Wall -std=c99 -O2
ARM64_LIBS = -lpthread -static

# ARM cross-compilation
ARM_CC = arm-linux-gnueabihf-gcc
ARM_PROG = socksd-linux-arm
ARM_OBJS = $(SRCS:.c=.arm.o)
ARM_CFLAGS = -Wall -std=c99 -O2
ARM_LIBS = -lpthread -static

-include config.mak

all: $(PROG)

install: $(PROG)
	install -d $(DESTDIR)/$(bindir)
	install -D -m 755 $(PROG) $(DESTDIR)/$(bindir)/$(PROG)

uninstall:
	rm -f $(DESTDIR)/$(bindir)/$(PROG)

clean:
	rm -f $(PROG) $(OBJS)
	rm -f $(WIN_PROG) $(WIN_OBJS)
	rm -f $(STATIC_PROG) $(STATIC_OBJS)
	rm -f $(ARM64_PROG) $(ARM64_OBJS)
	rm -f $(ARM_PROG) $(ARM_OBJS)

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(PIC) -c -o $@ $<

$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

# Windows
%.win.o: %.c
	$(WIN_CC) $(WIN_CFLAGS) -c -o $@ $<

windows: $(WIN_OBJS)
	$(WIN_CC) $(WIN_OBJS) $(WIN_LIBS) -o $(WIN_PROG)
	strip $(WIN_PROG)

# Static Linux x86_64
%.static.o: %.c
	$(MUSL_CC) $(STATIC_CFLAGS) -c -o $@ $<

static: $(STATIC_OBJS)
	$(MUSL_CC) $(STATIC_OBJS) $(STATIC_LIBS) -o $(STATIC_PROG)
	strip $(STATIC_PROG)

# ARM64
%.arm64.o: %.c
	$(ARM64_CC) $(ARM64_CFLAGS) -c -o $@ $<

arm64: $(ARM64_OBJS)
	$(ARM64_CC) $(ARM64_OBJS) $(ARM64_LIBS) -o $(ARM64_PROG)
	$(ARM64_CC:gcc=strip) $(ARM64_PROG)

# ARM
%.arm.o: %.c
	$(ARM_CC) $(ARM_CFLAGS) -c -o $@ $<

arm: $(ARM_OBJS)
	$(ARM_CC) $(ARM_OBJS) $(ARM_LIBS) -o $(ARM_PROG)
	$(ARM_CC:gcc=strip) $(ARM_PROG)

all-targets: static arm64 arm windows

.PHONY: all clean install uninstall windows static arm64 arm all-targets
