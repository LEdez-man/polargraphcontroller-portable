# Polargraph Controller portable 0.1.0

First release: Polargraph Controller 2.4.2 (upstream release 2017-11-01) as a portable package for
64-bit Windows, startable straight from the unpacked folder. No Java installation and no Processing
IDE are needed.

## The problem

Polargraph Controller 2.4.2 is a Processing 2.2.1 sketch from 2014–2017. The upstream Windows build
(`polargraphcontroller.exe`) has no Java of its own: it uses whatever Java 7 or 8 is installed on the
system. That causes three problems on current machines.

### 1. A Java update breaks the serial connection

The serial library jSSC 2.8 needs a native DLL that matches the Java architecture. The exe does not
tell Java where `lib\jSSC-2.8.dll` is. jSSC then looks in `%USERPROFILE%\.jssc\windows\`, and the
jSSC version shipped with Processing 2.2.1 cannot unpack the DLL there itself.

If only the 32-bit DLL is in that folder, for example from an earlier 32-bit Java, the controller
crashes with a 64-bit Java as soon as it lists the serial ports:

```
java.lang.UnsatisfiedLinkError: jssc.SerialNativeInterface.getSerialPortNames()[Ljava/lang/String;
    at processing.serial.Serial.list(Unknown Source)
    at polargraphcontroller.setup(polargraphcontroller.java:606)
```

This was reproduced with the unchanged upstream exe and Oracle Java 8u321 (64-bit). The same sketch
works when started from the Processing IDE, because the IDE adds the DLL folder to
`java.library.path`. That is why "it only works from Processing" is a typical report.

### 2. Newer Java versions are not supported

Processing 2.2.1 is built for Java 7 and 8. Java 9 and later changed things it depends on: the
version scheme, the module system (which restricts the OpenGL library JOGL 2.1), and the Applet API
that `PApplet` is built on (deprecated since Java 9, marked for removal since Java 17). As soon as only
a newer Java is installed, the exe has no supported runtime left.

### 3. Newer Processing versions cannot run the sketch unchanged

Opening the sketch in Processing 3 or 4 is not a quick way out either:

- The extra windows (serial port, machine settings, pixel drawing) put a `PApplet` into a
  `java.awt.Frame` and call `init()`. Since Processing 3, `PApplet` is no longer an AWT component, so
  this does not compile.
- `size(windowWidth, windowHeight)` with variables in `setup()` must move to `settings()`.
- controlP5 2.2.5 and the serial library would have to be replaced by newer versions; Processing 4
  also requires Java 17.

That is a port of about 10,000 lines of code, not a packaging fix. This release therefore leaves the
controller unchanged.

## What this package changes

The controller binaries are **unchanged**. The package only changes how they are started.

- **Bundled Java runtime:** `controller\jre\` contains Eclipse Temurin 8 (64-bit, OpenJDK). Java 8
  is the newest version Processing 2.2.1 runs on, and Temurin may be redistributed freely, unlike
  the Oracle JRE. The Java installed on the system is no longer used, so it can be updated or
  removed.
- **New launchers instead of the exe:**
  - `start-polargraph.cmd` starts the controller with the bundled Java and
    `-Djava.library.path=lib`, so jSSC always finds its 64-bit DLL. This is the actual fix for
    problem 1.
  - `start-polargraph-console.cmd` does the same with a console window for log output.
- **Optional fix for the original exe:** `install-jssc-dll.cmd` copies the 64-bit DLL to
  `%USERPROFILE%\.jssc\windows\jSSC-2.8_x86_64.dll`. The original exe then works again, as long as
  Java 7 or 8 is installed.
- **No personal settings in the package:** `default.properties.txt` is no longer shipped; the
  controller creates it on first start. In the example profile `Polargraphsd spec.properties.txt`
  the image path from its author's computer is cleared. The build checks the package for absolute
  user paths.
- **Source code included:** `sketchbook\` contains the unchanged sketch and the library sources,
  as required by the GPL. `start-processing.cmd` opens it in Processing 2.2.1 (not included,
  see `docs\development.md`).
- **Documentation:** `docs\troubleshooting.md`, `docs\licensing.md`, `docs\development.md`.

## Upgrading from the upstream installation

1. Unpack the package to a new folder; do not overwrite the old installation.
2. Copy your old `default.properties.txt` (next to the old `polargraphcontroller.exe`) into
   `controller\`.
3. Start `start-polargraph.cmd` and choose the serial port again.

## Known limitations

- Windows 64-bit only. The upstream release also has Linux builds; they are not repackaged.
- The serial port is stored as a position in the port list, not as a name (upstream behaviour).
- Tested on Windows 10 (64-bit) with a connected Polargraph machine. Tests on Windows 11 and with
  more machines are welcome.
