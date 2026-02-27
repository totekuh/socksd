# if you want to change/override some variables, do so in a file called
# config.mak, which is gets included automatically if it exists.

prefix = /usr/local
bindir = $(prefix)/bin

version = $(cat deb/DEBIAN/control |grep Version |cut -d" " -f2)

PROG = socksd
SRCS = src/sockssrv.c src/server.c src/sblist.c src/sblist_delete.c
OBJS = $(SRCS:.c=.o)

LIBS = -lpthread

CFLAGS += -Wall -std=c99

# Windows cross-compilation
CROSS_CC = x86_64-w64-mingw32-gcc
WIN_PROG = socksd.exe
WIN_OBJS = $(SRCS:.c=.win.o)
WIN_LIBS = -lws2_32 -lpthread -static
WIN_CFLAGS = -Wall -std=c99 -O2

-include config.mak

all: $(PROG)

install: $(PROG)
	install -d $(DESTDIR)/$(bindir)
	install -D -m 755 $(PROG) $(DESTDIR)/$(bindir)/$(PROG)

clean:
	rm -f $(PROG)
	rm -f $(OBJS)
	rm -f $(WIN_PROG)
	rm -f $(WIN_OBJS)

uninstall: $(PROG)
	rm -rf $(bindir)/$(PROG)

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(PIC) -c -o $@ $<

$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

%.win.o: %.c
	$(CROSS_CC) $(WIN_CFLAGS) -c -o $@ $<

windows: $(WIN_OBJS)
	$(CROSS_CC) $(WIN_OBJS) $(WIN_LIBS) -o $(WIN_PROG)
	strip $(WIN_PROG)

.PHONY: all clean install windows
