## General Information

A SOCKS5 service that you can run on your boxes, if for some reason SSH doesn't cut it for you.

It's very lightweight, and very light on resources too.

## Installation

Compile socksd and put the binary in `/usr/bin`:

```bash
make install
```

If you wish to install socksd as a systemd service, please do the following:

```bash
cp deb/DEBIAN/socksd.systemd.service /usr/lib/systemd/system/socksd.service
chmod +x /usr/lib/systemd/system/socksd.service
systemctl daemon-reload
systemctl start socksd
```

After starting socksd as a service, the proxy becomes available at 0.0.0.0:1337.

## Cross-compile for Windows x64

```bash
sudo apt install gcc-mingw-w64-x86-64
make windows
```

Produces a static `socksd.exe` (~82KB) with no DLL dependencies.

## Usage

Bind the proxy to the specified address:

```bash
socksd -i 10.10.10.100 -p 4200
```

With authentication:

```bash
socksd -i 0.0.0.0 -p 1080 -u user -P pass
```
