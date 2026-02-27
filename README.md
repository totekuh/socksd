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

## Build Targets

### Static Linux x86_64 (musl)

```bash
sudo apt install musl-tools
make static
```

Produces a fully static `socksd-linux-amd64`.

### Static Linux ARM64

```bash
sudo apt install gcc-aarch64-linux-gnu
make arm64
```

Produces a fully static `socksd-linux-arm64`.

### Static Linux ARM

```bash
sudo apt install gcc-arm-linux-gnueabihf
make arm
```

Produces a fully static `socksd-linux-arm`.

### Windows x64

```bash
sudo apt install gcc-mingw-w64-x86-64
make windows
```

Produces a static `socksd-windows-amd64.exe` with no DLL dependencies.

### All cross targets at once

```bash
make all-targets
```

## Usage

Bind the proxy to the specified address:

```bash
socksd -i 10.10.10.100 -p 4200
```

With authentication:

```bash
socksd -i 0.0.0.0 -p 1080 -u user -P pass
```

Quiet mode (suppress all log output):

```bash
socksd -q -p 1080
```
