# Firmware: setting up the Arduino

The controller on the PC only sends commands. The machine needs the Polargraph firmware
("Polargraph server") on its Arduino. This is a one-time step; a machine that has drawn before
already has it.

A simpler, step-by-step version for beginners is in the [guide for dummies](dummies/README.md).

## Which firmware?

| Hardware | Firmware | Board in the Arduino IDE |
|---|---|---|
| Arduino Uno + Adafruit Motor Shield **v1** | `polargraph_server_a1` (default configuration) | Arduino Uno |
| Arduino Uno + Adafruit Motor Shield **v2** | `polargraph_server_a1`, switch to v2 (see below) | Arduino Uno |
| Arduino Uno with stepper drivers (EasyDriver, StepStick) or ULN2003 | `polargraph_server_a1`, switch driver and set pins in `configuration.ino` | Arduino Uno |
| Arduino Mega 2560 + PolarShield, PolargraphSD | `polargraph_server_polarshield` | Arduino Mega or Mega 2560 |

Firmware versions in the upstream release 2017-11-01: `polargraph_server_a1` 1.2.1,
`polargraph_server_polarshield` 1.4.

## Getting the firmware

The firmware is not part of the portable package. It is in the upstream release zip:

1. Download `Polargraph.2017-11-01.zip` from
   [euphy/polargraphcontroller, release 2017-11-01](https://github.com/euphy/polargraphcontroller/releases/tag/2017-11-01-20-30)
   and unpack it.
2. The folder `arduino-source\` contains:
   - `polargraph_server_a1\` and `polargraph_server_polarshield\` (the firmware sketches),
   - `libraries\` (AccelStepper, AFMotor, Adafruit_MotorShield, UTFT, UTouch).

The same sources are in the repositories
[euphy/polargraph_server_a1](https://github.com/euphy/polargraph_server_a1) and
[euphy/polargraph_server_polarshield](https://github.com/euphy/polargraph_server_polarshield).

## Uploading with the Arduino IDE

1. Install the Arduino IDE from [arduino.cc/en/software](https://www.arduino.cc/en/software).
2. Copy the folders inside `arduino-source\libraries\` into the Arduino libraries folder,
   usually `Documents\Arduino\libraries\` (create it if it does not exist). Use these versions:
   they are the ones the firmware was written for. If newer versions of AccelStepper or
   Adafruit_MotorShield are already installed through the Library Manager, the IDE may pick those.
3. Open the sketch: `polargraph_server_a1\polargraph_server_a1.ino` or
   `polargraph_server_polarshield\polargraph_server_polarshield.ino`.
4. Only for Adafruit Motor Shield v2: near the top of `polargraph_server_a1.ino`, comment out the v1
   lines and enable the v2 lines:

   ```cpp
   //#define ADAFRUIT_MOTORSHIELD_V1
   //#include <AFMotor.h>

   #define ADAFRUIT_MOTORSHIELD_V2
   #include <Wire.h>
   #include <Adafruit_MotorShield.h>
   #include "utility/Adafruit_PWMServoDriver.h"
   ```

5. Select the board (**Tools > Board**) and the port (**Tools > Port**), then click **Upload**.
6. Close the Arduino IDE (or at least its Serial Monitor) before starting the controller: only one
   program can use the serial port at a time.

Tested compile results (Arduino IDE 1.8.9, AVR core 1.6.23), unchanged upstream sources:

| Variant | Board | Program storage | Dynamic memory |
|---|---|---|---|
| `polargraph_server_a1`, Motor Shield v1 | Uno | 23,700 bytes (73 %) | 921 bytes (44 %) |
| `polargraph_server_a1`, Motor Shield v2 | Uno | 25,660 bytes (79 %) | 1,233 bytes (60 %) |
| `polargraph_server_polarshield` | Mega 2560 | 96,282 bytes (37 %) | 5,294 bytes (64 %) |

Arduino IDE 2.x has not been tested yet. Upstream tested the firmware with Arduino IDE 1.6.7.

## Alternative: precompiled hex files

The upstream release contains precompiled files that can be uploaded without compiling:

- `polargraph_server_a1\polargraph_server_a1_adafruit_v1.cpp.hex` (Uno, Motor Shield v1)
- `polargraph_server_a1\polargraph_server_a1_adafruit_v2.cpp.hex` (Uno, Motor Shield v2)
- `polargraph_server_polarshield\polargraph_server_polarshield.ino.hex` (PolarShield or
  PolargraphSD shipped after August 2014; machines with a 2.2-inch screen need a custom compile)

Upstream describes how to upload them, for example with XLoader, in the wiki page
[Uploading precompiled binary hex files](https://github.com/euphy/polargraph/wiki/Uploading-precompiled-binary-hex-files).

## Checking the connection

Start the controller (`start-polargraph.cmd`) and choose the port under **Serial port…**. The status
line at the top of the window shows:

| Status | Meaning |
|---|---|
| green: `Polargraph READY! (Uno)` (or `Mega`, `PolargraphSD`) | Firmware found, machine ready |
| yellow: `BUSY: …` | The machine is executing a command |
| red: `Polargraph is not connected.` | Wrong port, firmware missing, or the port is used by another program |

## Further reading

- [Polargraph wiki](https://github.com/euphy/polargraph/wiki) (upstream): hardware, calibration,
  drawing styles.
- `README.md` in each firmware folder: driver options and configuration sections.
