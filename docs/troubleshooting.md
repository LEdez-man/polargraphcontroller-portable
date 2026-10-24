# Troubleshooting

Start the controller with `start-polargraph-console.cmd` to see its log output. Most problems show
up there as a Java error message.

## `UnsatisfiedLinkError: jssc.SerialNativeInterface.getSerialPortNames()`

**Symptom:** the original `polargraphcontroller.exe` starts, but stops as soon as it lists the serial
ports. Starting the sketch from the Processing IDE works.

**Cause:** the serial library jSSC 2.8 needs a native DLL. It looks for it in this order:

1. On `java.library.path` (`jSSC-2.8.dll`).
2. In `%USERPROFILE%\.jssc\windows\` as `jSSC-2.8_x86.dll` (32-bit Java) or
   `jSSC-2.8_x86_64.dll` (64-bit Java).
3. It tries to unpack the DLL from `jssc.jar` into that folder. The modified jSSC shipped with
   Processing 2.2.1 contains no DLL in the jar, so this step fails.

The exe sets no `java.library.path`, so step 1 never finds `lib\jSSC-2.8.dll`. If a 32-bit Java was
used before, only the 32-bit DLL is in `%USERPROFILE%\.jssc\windows\`, and a 64-bit Java fails.
The Processing IDE adds the serial library's DLL folder to `java.library.path`, which is why it works
from there.

**Fix:** use `start-polargraph.cmd`. It sets `-Djava.library.path=lib`. Alternatively run
`install-jssc-dll.cmd`, which copies the 64-bit DLL to `%USERPROFILE%\.jssc\windows\`.

## The controller does not start after a Java update

Two causes are possible:

- The update changed the Java architecture, for example from 32-bit to 64-bit. Then the serial
  ports fail with the `UnsatisfiedLinkError` described above.
- Only Java 9 or later is left. Processing 2.2.1 supports only Java 7 and 8, and the original exe
  uses the Java installed on the system.

The portable launchers use `controller\jre\` and are not affected by either.

## "This application requires a Java Runtime Environment 1.7.0_40"

The original exe found no installed Java 7 or 8. Use the portable launchers.

To see which Java the exe picks, start it with `polargraphcontroller.exe --l4j-debug`. The launcher
(Launch4j 3.4) writes `launch4j.log` next to the exe. Registry entries of uninstalled Java versions
show up there as "not found"; they are skipped and are harmless.

## "Attempting to connect to serial port null in slot N caused an exception"

The controller saves the serial port as a position in the list, not by name. If the machine is not
connected, or the COM ports are in a different order, that position does not exist. Connect the
machine and choose the port again under **Serial port…**.

## The machine's port is not listed

- Check the USB cable and the driver. Many Arduino clones use a CH340 USB chip that needs its own
  driver.
- Close other programs that use the port, for example the serial monitor of the Arduino IDE.
- Check the port in the Windows Device Manager under "Ports (COM & LPT)".

## Reporting a problem

Open an issue with the output of `start-polargraph-console.cmd` and the content of `BUILD-INFO.txt`.
Remove personal paths (for example your user name in file paths) before posting.
