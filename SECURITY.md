# Security

## What to keep in mind

- The package runs Polargraph Controller 2.4.2 (2017) with a bundled Java 8 runtime. Java 8 still
  receives security updates from Eclipse Adoptium; each release uses the newest Temurin 8 build
  available at build time (see `BUILD-INFO.txt`). Install new releases to get runtime updates.
- The bundled runtime is meant only for the controller. It is not registered with Windows and is not
  used by browsers or other programs.
- The controller opens no network connections; it talks to the machine over the serial port.
- Downloads in the build script are verified by SHA-256.

## Supported versions

Only the latest release receives fixes.

## Reporting a vulnerability

Please use GitHub's private vulnerability reporting ("Security" tab, "Report a vulnerability")
instead of a public issue. Problems in the controller itself belong upstream at
[euphy/polargraphcontroller](https://github.com/euphy/polargraphcontroller).
