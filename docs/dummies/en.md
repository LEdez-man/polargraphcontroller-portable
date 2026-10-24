# Polargraph – Guide for dummies

**For everyone who just wants to start drawing**: teachers, parents, youth groups, art clubs.
No prior knowledge needed. This guide explains every step.

[Deutsch](de.md) · [Français](fr.md) · [Español](es.md)

---

## What is a Polargraph?

A Polargraph is a **drawing robot that hangs on the wall**. There is a small motor at the top left
and one at the top right. A cord hangs down from each motor, and together the two cords hold a pen
holder in the middle. When the motors make the cords longer or shorter, the pen travels across the
paper and draws, line by line.

A computer controls the machine. It runs the program **Polargraph Controller**, which tells the
machine over a USB cable where the pen should go.

Great for: putting your own drawings big on the wall, drawing names and patterns, turning photos
into line art, and watching how a robot "thinks".

---

## What you need

- [ ] A **fully built Polargraph machine** with its power supply
- [ ] A **Windows computer** (Windows 10 or 11). You do **not** need to install Java or any other
      program.
- [ ] The **USB cable** that fits the machine
- [ ] **Paper**, fixed to the wall or to a large board
- [ ] A **felt-tip pen** that fits the pen holder
- [ ] About **one hour** the first time; after that it takes a few minutes

---

## Overview: three steps

| Step | What happens | How often? |
|---|---|---|
| **A** | The machine's "brain" (the Arduino) gets its control software | **once only** |
| **B** | The drawing program goes onto the computer | **once only** |
| **C** | Connect, set up and draw | for every drawing |

> **Has the machine drawn before?** Then skip step A and start with step B.

---

## Step A: Load the control software onto the Arduino (once only)

Inside the machine there is a small circuit board, the **Arduino**. It is the machine's brain. To
understand the commands from the computer it needs control software, called **firmware**. You load
it once, and it stays there for good.

### A1. Find out which brain your machine has

Look at the circuit boards in the machine:

| What you see | Your firmware |
|---|---|
| A board labelled **"UNO"** with a second board from **Adafruit** ("Motor Shield") on top | **Variant 1:** `polargraph_server_a1` |
| A long board labelled **"MEGA"** with a board with a small **screen** on top (PolarShield, PolargraphSD) | **Variant 2:** `polargraph_server_polarshield` |

Variant 1 comes in two versions of the Motor Shield:
- If the board says **"v2"** (for example "Motor Shield v2.3"), it is **v2**.
- Otherwise it is almost always **v1**. You can recognise it by two large black chips labelled
  "L293D".

Not sure? Ask the person who built the machine, or take a photo of the board and look it up in the
[Polargraph wiki](https://github.com/euphy/polargraph/wiki).

### A2. Install the Arduino program

1. Open [arduino.cc/en/software](https://www.arduino.cc/en/software).
2. Download the **Arduino IDE for Windows** and install it. When it asks about drivers, click
   "Install".

### A3. Download the firmware

1. Open the
   [Polargraph download page](https://github.com/euphy/polargraphcontroller/releases/tag/2017-11-01-20-30)
   and click **`Polargraph.2017-11-01.zip`**.
2. Right-click the downloaded file, choose **"Extract All…"**, then **"Extract"**.
3. In the extracted folder you will find the subfolder **`arduino-source`**. You need it now.

### A4. Copy the add-ons to the right place

The firmware needs a few add-ons, called libraries.

1. In the `arduino-source` folder, open the folder **`libraries`**. It contains five folders
   (AccelStepper, AFMotor, Adafruit_MotorShield, UTFT, UTouch).
2. Select all five and copy them (Ctrl + C).
3. Open your **Documents** folder, then **`Arduino`**, then **`libraries`**. If there is no
   `libraries` folder, create it (right-click → New → Folder).
4. Paste the five folders there (Ctrl + V).
5. If the Arduino IDE was already open, restart it.

### A5. Open the firmware

- **Variant 1 (UNO):** double-click
  `arduino-source\polargraph_server_a1\polargraph_server_a1.ino`
- **Variant 2 (MEGA):** double-click
  `arduino-source\polargraph_server_polarshield\polargraph_server_polarshield.ino`

The Arduino IDE opens and shows a lot of text (program code). Don't worry, you don't need to
understand it.

### A6. Motor Shield v2 only: two small changes

**For v1 and for variant 2, skip this step.**

Near the top of the text you will find these lines:

```cpp
#define ADAFRUIT_MOTORSHIELD_V1
#include <AFMotor.h>
```

and below them:

```cpp
//#define ADAFRUIT_MOTORSHIELD_V2
//#include <Wire.h>
//#include <Adafruit_MotorShield.h>
//#include "utility/Adafruit_PWMServoDriver.h"
```

Two slashes `//` at the start of a line mean "switch this line off". Change it like this:

- Type `//` **in front of** the two v1 lines.
- Delete the `//` **in front of** the four v2 lines.

Afterwards it looks like this:

```cpp
//#define ADAFRUIT_MOTORSHIELD_V1
//#include <AFMotor.h>

#define ADAFRUIT_MOTORSHIELD_V2
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"
```

### A7. Upload

1. Connect the machine to the computer with the USB cable.
2. Menu **Tools → Board**: choose **"Arduino Uno"** (variant 1) or
   **"Arduino Mega or Mega 2560"** (variant 2).
3. Menu **Tools → Port**: choose the entry with **COM** and a number, for example `COM3`. If there
   are several, unplug the USB cable for a moment. The entry that disappears is the right one.
4. Click the **right arrow** at the top ("Upload").
5. Wait until **"Done uploading"** appears at the bottom. This takes about a minute.
6. **Close the Arduino IDE.** Otherwise it blocks the connection to the machine.

Done! You never have to do this step again.

---

## Step B: The drawing program on the computer (once only)

1. Open the
   [download page of this package](https://github.com/LEdez-man/polargraphcontroller-portable/releases)
   and click **`Polargraph-portable-win64-…zip`**.
2. Right-click the downloaded file → **"Extract All…"** → **"Extract"**. Choose a place you can
   find again, for example the desktop or a USB stick.
3. **Important:** never start anything directly from the zip file, always from the extracted
   folder.

Nothing gets installed. To remove it later, simply delete the folder.

---

## Step C: Connect, set up, draw

### C1. Start the program

1. Open the folder **`Polargraph-portable`**.
2. Double-click **`start-polargraph.cmd`**.
3. If Windows shows **"Windows protected your PC"**: click **"More info"**, then
   **"Run anyway"**. This happens because the program comes from the internet and has no paid
   signature.

After a few seconds the **Polargraph Controller** window opens. In the middle you see a picture of
your machine.

### C2. Connect the machine

1. Plug in the machine's **power supply** and connect the **USB cable**.
2. In the program, click **"Serial port…"** and choose the same COM port as in step A7.
3. Look at the status line at the top:
   - **Green "Polargraph READY!"**: everything is connected.
   - **Red "Polargraph is not connected."**: see "If it doesn't work" below.
4. Further up there is a red line **"CommandQueue: QUEUE PAUSED - click to start"**. Click it until
   it shows a green **"QUEUE RUNNING"**. Only then does the machine carry out commands.

### C3. Enter the machine's size (the first time)

The program needs to know how big your machine is. Click the **"Setup"** tab at the top.

| Field | What to enter |
|---|---|
| **Machine Width** | Distance between the two motors in millimetres, from shaft to shaft |
| **Machine Height** | How far down the paper reaches, in millimetres from the motors |
| **MM Per Rev** | How much cord one motor turn winds up. The person who built the machine knows this value. |
| **Steps Per Rev** | Usually **200** |

Then click **"Upload machine spec"** so the machine learns the values, and **"Save"** so the
program remembers them. Next time they are already there.

### C4. Set the starting point (before every drawing)

After switching on, the machine does not know where the pen is. That is why there is a fixed
**starting point** ("Home"). On the screen it is shown as **crosshairs**; the numbers next to it
tell you where it is (in mm from the left and from the line between the motors). It is often marked
on the machine.

1. Carefully move the pen holder to this point by hand.
2. In the **"input"** tab, click **"Set home"**.

With **"Pen lift"** and **"Pen drop"** you can test whether the pen moves.

### C5. Load a drawing and draw it

The machine draws **line drawings** in **SVG** format best.

1. In the **"input"** tab, click **"Load vector"** and choose an SVG file.
   (Clicking "Load vector" again removes the drawing, so you can load another one.)
2. The drawing appears on the picture of the machine. Use **"Move vector"** and
   **"Resize vector"** to adjust its position and size.
3. Click **"Draw vectors"**. The machine starts drawing.
4. To pause, click **"QUEUE RUNNING - click to pause"** at the top.
5. When it has finished: **"Return to home"** moves the pen back to the starting point.

**Where do I get SVG files?**
- Draw them yourself with the free program [Inkscape](https://inkscape.org).
- **Children's drawings**: scan or photograph them, open them in Inkscape and turn them into lines
  with **Path → Trace Bitmap**. This works best with thick, dark lines on white paper.
- Lots of free line drawings are available at [openclipart.org](https://openclipart.org).

Photos work too: with **"Load image file"**, then choose an area with **"Select Area"** and click
**"Render pixels…"**. Save that for later, once the first drawings work.

---

## Tips for working with children

- **Hang it securely:** the machine must be firmly attached to the wall or board and must not be
  able to fall.
- **Hands off while it draws:** fingers can get caught in the motors and cords. Keeping one step
  away from the wall is a good rule.
- **Power supply:** only use the machine's own power supply. Unplug it after the session.
- **Pens:** washable felt-tip pens are ideal. Only change the pen while the pen holder is lifted.
- **Start small:** a postcard-sized drawing is done in a few minutes. Large pictures can take more
  than an hour, which is perfect for watching and guessing what it will become.
- **Group idea:** each child draws one part, and the machine combines them into one big shared
  picture.

---

## If it doesn't work

| Problem | Solution |
|---|---|
| No COM port under "Serial port…" | Check the USB cable; some cables only charge and do not transfer data. Many low-cost Arduinos need the **CH340** driver once (search for "CH340 driver Windows"). |
| Red "Polargraph is not connected." | Choose another COM port. Close the Arduino IDE. Was step A done? |
| Connected, but the machine does not move | Does it say "QUEUE PAUSED" at the top? Click it. Is the power supply plugged in? |
| The drawing is distorted or too big | Check the sizes in the "Setup" tab (step C3) and set the starting point again (step C4). |
| The program does not start | Start `start-polargraph-console.cmd`. It shows error messages you can include when asking others for help. |

More help: [Troubleshooting](../troubleshooting.md), [Firmware in detail](../firmware.md),
[Polargraph wiki](https://github.com/euphy/polargraph/wiki).

---

## Small glossary

| Word | Meaning |
|---|---|
| **Arduino** | Small computer board, the machine's "brain" |
| **Firmware** | The control software that runs on the Arduino |
| **COM port** | What Windows calls the USB connection to the machine, for example `COM3` |
| **SVG** | File format for line drawings |
| **Zip file** | A packed folder; it must be "extracted" before use |
| **Home** | The fixed starting point of the pen |
| **Queue** | The list of commands that are sent to the machine one after another |

---

*Polargraph was created by Sandy Noble ([polargraph.co.uk](http://www.polargraph.co.uk)).
This portable package and the guide: Samuel Peters, created with the help of Claude (Anthropic).*
