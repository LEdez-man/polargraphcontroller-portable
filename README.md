# Polargraph Controller – portable for Windows

Runs [Polargraph Controller 2.4.2](https://github.com/euphy/polargraphcontroller) by Sandy Noble on a
current 64-bit Windows **without installing Java and without the Processing IDE**. The package brings
its own Java runtime, so updating or removing the system Java no longer breaks the controller.

This is an unofficial companion project. The controller itself is unchanged: the package uses the
original binaries of the upstream release
[2017-11-01-20-30](https://github.com/euphy/polargraphcontroller/releases/tag/2017-11-01-20-30)
and only adds launchers and a Java runtime.

## Why

Polargraph Controller 2.4.2 was built with Processing 2.2.1 (2014) and needs Java 7 or 8. On current
machines it typically fails in one of these ways:

- **A Java update breaks the serial connection:** `polargraphcontroller.exe` starts with a 64-bit
  Java, but the serial library jSSC does not find its native DLL and stops with
  `UnsatisfiedLinkError: jssc.SerialNativeInterface.getSerialPortNames()`.
  Starting the sketch from the Processing IDE works, which makes the problem hard to spot.
- **Only Java 9 or later installed:** Processing 2.2.1 does not support these versions, so the exe
  has no suitable runtime.
- **Newer Processing versions** (3, 4) cannot run the sketch without porting it.

The launchers in this package start the controller with a bundled Java 8 runtime and tell Java where
the serial DLL is. What exactly went wrong and what was changed: [RELEASE-NOTES.md](RELEASE-NOTES.md).
Error messages and fixes: [docs/troubleshooting.md](docs/troubleshooting.md).

## Quick start

1. Download `Polargraph-portable-win64-<version>.zip` from the [Releases](../../releases) page.
2. Unzip it anywhere, for example to a USB stick. The path may contain spaces.
3. Double-click **`start-polargraph.cmd`**.
4. Connect the machine and choose the port under **Serial port…**, as usual.

If something does not work, use **`start-polargraph-console.cmd`**: it shows all log output and errors.

## Package contents

| Path | Purpose |
|---|---|
| `start-polargraph.cmd` | Starts the controller with the bundled Java runtime |
| `start-polargraph-console.cmd` | Same, with a console window for log output and errors |
| `install-jssc-dll.cmd` | Optional: makes the original `polargraphcontroller.exe` work again (see below) |
| `start-processing.cmd` | Opens the sketch in Processing 2.2.1, for developers (Processing not included) |
| `controller\` | Upstream Polargraph Controller 2.4.2, Windows 64-bit, unchanged |
| `controller\jre\` | Java runtime: Eclipse Temurin 8 JRE, 64-bit |
| `sketchbook\` | Source code of the controller and of the libraries it uses |
| `docs\` | Troubleshooting, licensing, development notes |
| `BUILD-INFO.txt` | Exact versions in this package |

## Settings

The controller stores its settings in `controller\default.properties.txt`. The package does not ship
this file; the controller creates it on first start. To keep the settings of an existing
installation, copy its `default.properties.txt` into `controller\` before the first start.

The controller remembers the serial port as a position in the port list ("slot"), not as a name such
as COM3. If the order of the COM ports changes, choose the port again under **Serial port…**.

## Java runtime

The bundled runtime is [Eclipse Temurin](https://adoptium.net/) 8 (OpenJDK, GPL-2.0 with Classpath
Exception), which may be redistributed freely. Java 8 is the newest version that Processing 2.2.1
runs on. It is used only by the controller and does not change the Java installed on the system.

Java 8 receives security updates, but the controller is old software: use it for the plotter, not as
a general Java installation. To update the runtime, build a new package (see below) or wait for the
next release.

## Making the original exe work again

The original `polargraphcontroller.exe` uses the Java installed on the system (7 or 8) and does not
tell jSSC where its DLL is. `install-jssc-dll.cmd` copies the 64-bit DLL to
`%USERPROFILE%\.jssc\windows\jSSC-2.8_x86_64.dll`, where jSSC looks for it. After that, the exe works
again as long as Java 7 or 8 is installed. The portable launchers do not need this step.

## Building the package

Requirements: Windows 10 or 11, Windows PowerShell 5.1 or PowerShell 7, internet access.

```powershell
.\scripts\build-package.ps1 -Version v0.1.0
```

The script downloads the upstream release and the latest Temurin 8 JRE (both verified by SHA-256),
assembles `dist\Polargraph-portable\`, checks it for personal data, runs a smoke test and creates
`dist\Polargraph-portable-win64-v0.1.0.zip`. Options for offline builds and the release process are
described in [docs/development.md](docs/development.md).

Releases are built by GitHub Actions ([.github/workflows/build.yml](.github/workflows/build.yml))
when a tag `v*` is pushed. Binaries are attached to the release and never committed to the repository.

## Firmware

The Arduino firmware is not part of this package. It is in the upstream release zip
(`arduino-source\`) and in the upstream repositories
[polargraph_server_a1](https://github.com/euphy/polargraph_server_a1) and
[polargraph_server_polarshield](https://github.com/euphy/polargraph_server_polarshield).

## Credits

- **Polargraph** and Polargraph Controller: Sandy Noble ([polargraph.co.uk](http://www.polargraph.co.uk),
  [euphy/polargraphcontroller](https://github.com/euphy/polargraphcontroller)).
- Libraries: Processing, controlP5, Geomerative, diewald_CV_kit, jSSC, JOGL – see
  [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
- Portable packaging: Samuel Peters, created with the help of Claude (Anthropic).

## License

The launchers, scripts and documentation in this repository are licensed under the
[GNU General Public License v3.0 or later](LICENSE), the same license as Polargraph Controller.
Bundled third-party components keep their own licenses; see
[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) and [docs/licensing.md](docs/licensing.md).
