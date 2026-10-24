# Polargraph – Anleitung für Dummies

**Für alle, die einfach loszeichnen wollen**: Lehrkräfte, Eltern, Jugendgruppen, Kunst-AGs.
Vorwissen ist nicht nötig. Diese Anleitung erklärt jeden Schritt.

[English](en.md) · [Français](fr.md) · [Español](es.md)

---

## Was ist ein Polargraph?

Ein Polargraph ist ein **Zeichenroboter, der an der Wand hängt**. Oben links und oben rechts sitzt
je ein kleiner Motor. Von jedem Motor hängt eine Schnur herab, und beide Schnüre halten in der
Mitte einen Stifthalter. Wenn die Motoren die Schnüre länger oder kürzer machen, wandert der Stift
über das Papier und zeichnet, Strich für Strich.

Gesteuert wird das Ganze von einem Computer. Darauf läuft das Programm **Polargraph Controller**.
Es schickt der Maschine über ein USB-Kabel, wohin der Stift fahren soll.

Gut geeignet für: eigene Zeichnungen groß an die Wand bringen, Namen und Muster zeichnen lassen,
Fotos als Strichbild, und zusehen, wie ein Roboter „denkt“.

---

## Das brauchen Sie

- [ ] Eine **fertig gebaute Polargraph-Maschine** mit Netzteil
- [ ] Einen **Windows-Computer** (Windows 10 oder 11). Java oder andere Programme müssen Sie
      **nicht** installieren.
- [ ] Das **USB-Kabel**, das zur Maschine passt
- [ ] **Papier**, an der Wand oder auf einer großen Platte befestigt
- [ ] Einen **Filzstift**, der in den Stifthalter passt
- [ ] Etwa **eine Stunde** Zeit beim ersten Mal, danach geht es in wenigen Minuten

---

## Übersicht: drei Schritte

| Schritt | Was passiert | Wie oft? |
|---|---|---|
| **A** | Das „Gehirn“ der Maschine (der Arduino) bekommt seine Steuerung | **nur einmal** |
| **B** | Das Zeichenprogramm kommt auf den Computer | **nur einmal** |
| **C** | Verbinden, einstellen und zeichnen | bei jeder Zeichnung |

> **Hat die Maschine schon einmal gezeichnet?** Dann überspringen Sie Schritt A und beginnen
> mit Schritt B.

---

## Schritt A: Steuerung auf den Arduino laden (nur einmal)

In der Maschine steckt eine kleine Platine, der **Arduino**. Er ist das Gehirn der Maschine. Damit
er die Befehle vom Computer versteht, braucht er eine Steuerung, die sogenannte **Firmware**. Die
laden Sie einmal auf, danach bleibt sie für immer darauf.

### A1. Herausfinden, welches Gehirn Ihre Maschine hat

Schauen Sie sich die Platinen in der Maschine an:

| Was Sie sehen | Ihre Steuerung |
|---|---|
| Eine Platine mit der Aufschrift **„UNO“**, darauf eine zweite Platine von **Adafruit** („Motor Shield“) | **Variante 1:** `polargraph_server_a1` |
| Eine lange Platine mit der Aufschrift **„MEGA“**, darauf eine Platine mit kleinem **Bildschirm** (PolarShield, PolargraphSD) | **Variante 2:** `polargraph_server_polarshield` |

Bei Variante 1 gibt es zwei Ausführungen des Motor Shields:
- Steht auf der Platine **„v2“** (zum Beispiel „Motor Shield v2.3“), ist es **v2**.
- Sonst ist es fast immer **v1**. Erkennungszeichen: zwei große schwarze Chips mit der Aufschrift
  „L293D“.

Unsicher? Fragen Sie die Person, die die Maschine gebaut hat, oder machen Sie ein Foto der
Platine und schauen Sie im [Polargraph-Wiki](https://github.com/euphy/polargraph/wiki) nach.

### A2. Arduino-Programm installieren

1. Öffnen Sie [arduino.cc/en/software](https://www.arduino.cc/en/software).
2. Laden Sie die **Arduino IDE für Windows** herunter und installieren Sie sie. Bestätigen Sie
   dabei die Frage nach den Treibern mit „Installieren“.

### A3. Die Steuerung herunterladen

1. Öffnen Sie die
   [Download-Seite von Polargraph](https://github.com/euphy/polargraphcontroller/releases/tag/2017-11-01-20-30)
   und klicken Sie auf **`Polargraph.2017-11-01.zip`**.
2. Klicken Sie mit der rechten Maustaste auf die heruntergeladene Datei und wählen Sie
   **„Alle extrahieren…“**, dann **„Extrahieren“**.
3. Im entpackten Ordner finden Sie den Unterordner **`arduino-source`**. Den brauchen Sie jetzt.

### A4. Zusatzteile an die richtige Stelle kopieren

Die Steuerung braucht ein paar Zusatzteile, sogenannte Bibliotheken.

1. Öffnen Sie im Ordner `arduino-source` den Ordner **`libraries`**. Darin liegen fünf Ordner
   (AccelStepper, AFMotor, Adafruit_MotorShield, UTFT, UTouch).
2. Markieren Sie alle fünf und kopieren Sie sie (Strg + C).
3. Öffnen Sie Ihren Ordner **Dokumente**, darin **`Arduino`** und darin **`libraries`**. Fehlt
   der Ordner `libraries`, legen Sie ihn an (Rechtsklick → Neu → Ordner).
4. Fügen Sie die fünf Ordner dort ein (Strg + V).
5. Starten Sie die Arduino IDE neu, falls sie schon offen war.

### A5. Steuerung öffnen

- **Variante 1 (UNO):** Doppelklick auf
  `arduino-source\polargraph_server_a1\polargraph_server_a1.ino`
- **Variante 2 (MEGA):** Doppelklick auf
  `arduino-source\polargraph_server_polarshield\polargraph_server_polarshield.ino`

Die Arduino IDE öffnet sich und zeigt viel Text (Programmcode). Keine Sorge, Sie müssen ihn nicht
verstehen.

### A6. Nur bei Motor Shield v2: zwei kleine Änderungen

**Bei v1 und bei Variante 2 überspringen Sie diesen Schritt.**

Weiter oben im Text finden Sie diese Zeilen:

```cpp
#define ADAFRUIT_MOTORSHIELD_V1
#include <AFMotor.h>
```

und darunter:

```cpp
//#define ADAFRUIT_MOTORSHIELD_V2
//#include <Wire.h>
//#include <Adafruit_MotorShield.h>
//#include "utility/Adafruit_PWMServoDriver.h"
```

Zwei Schrägstriche `//` am Zeilenanfang bedeuten „diese Zeile ausschalten“. Ändern Sie es so:

- Schreiben Sie `//` **vor** die beiden v1-Zeilen.
- Löschen Sie das `//` **vor** den vier v2-Zeilen.

So sieht es danach aus:

```cpp
//#define ADAFRUIT_MOTORSHIELD_V1
//#include <AFMotor.h>

#define ADAFRUIT_MOTORSHIELD_V2
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"
```

### A7. Hochladen

1. Verbinden Sie die Maschine per USB mit dem Computer.
2. Menü **Werkzeuge → Board**: Wählen Sie **„Arduino Uno“** (Variante 1) oder
   **„Arduino Mega or Mega 2560“** (Variante 2).
3. Menü **Werkzeuge → Port**: Wählen Sie den Eintrag mit **COM** und einer Zahl, zum Beispiel
   `COM3`. Gibt es mehrere, ziehen Sie das USB-Kabel kurz ab. Der Eintrag, der dabei verschwindet,
   ist der richtige.
4. Klicken Sie oben auf den **Pfeil nach rechts** („Hochladen“).
5. Warten Sie, bis unten **„Hochladen abgeschlossen“** steht. Das dauert etwa eine Minute.
6. **Schließen Sie die Arduino IDE.** Sonst blockiert sie die Verbindung zur Maschine.

Geschafft! Diesen Schritt müssen Sie nie wieder machen.

---

## Schritt B: Zeichenprogramm auf den Computer (nur einmal)

1. Öffnen Sie die
   [Download-Seite dieses Pakets](https://github.com/LEdez-man/polargraphcontroller-portable/releases)
   und klicken Sie auf **`Polargraph-portable-win64-…zip`**.
2. Rechtsklick auf die heruntergeladene Datei → **„Alle extrahieren…“** → **„Extrahieren“**.
   Wählen Sie einen Ort, den Sie wiederfinden, zum Beispiel den Desktop oder einen USB-Stick.
3. **Wichtig:** Starten Sie nichts direkt aus der Zip-Datei, sondern immer aus dem entpackten
   Ordner.

Installiert wird nichts. Zum Entfernen löschen Sie später einfach den Ordner.

---

## Schritt C: Verbinden, einstellen, zeichnen

### C1. Programm starten

1. Öffnen Sie den Ordner **`Polargraph-portable`**.
2. Doppelklick auf **`start-polargraph.cmd`**.
3. Zeigt Windows **„Der Computer wurde durch Windows geschützt“**: Klicken Sie auf
   **„Weitere Informationen“** und dann **„Trotzdem ausführen“**. Das passiert, weil das Programm
   aus dem Internet stammt und keine kostenpflichtige Unterschrift hat.

Nach einigen Sekunden öffnet sich das Fenster **Polargraph Controller**. In der Mitte sehen Sie
ein Bild Ihrer Maschine.

### C2. Maschine verbinden

1. Stecken Sie das **Netzteil** der Maschine ein und verbinden Sie das **USB-Kabel**.
2. Klicken Sie im Programm auf **„Serial port…“** (Anschluss) und wählen Sie denselben
   COM-Anschluss wie in Schritt A7.
3. Schauen Sie auf die Statuszeile oben:
   - **Grün „Polargraph READY!“**: Alles verbunden.
   - **Rot „Polargraph is not connected.“**: Siehe „Wenn es nicht klappt“ unten.
4. Weiter oben steht in Rot **„CommandQueue: QUEUE PAUSED - click to start“**. Klicken Sie
   darauf, bis es grün **„QUEUE RUNNING“** zeigt. Erst dann führt die Maschine Befehle aus.

### C3. Maße der Maschine eintragen (beim ersten Mal)

Das Programm muss wissen, wie groß Ihre Maschine ist. Klicken Sie oben auf den Reiter **„Setup“**.

| Feld | Was eintragen? |
|---|---|
| **Machine Width** (Maschinenbreite) | Abstand zwischen den beiden Motoren in Millimetern, gemessen von Achse zu Achse |
| **Machine Height** (Maschinenhöhe) | Wie weit das Papier nach unten reicht, in Millimetern ab den Motoren |
| **MM Per Rev** (mm pro Umdrehung) | Wie viel Schnur eine Motorumdrehung aufwickelt. Wer die Maschine gebaut hat, kennt den Wert. |
| **Steps Per Rev** (Schritte pro Umdrehung) | Meist **200** |

Klicken Sie danach auf **„Upload machine spec“**, damit die Maschine die Werte erfährt, und auf
**„Save“**, damit das Programm sie sich merkt. Beim nächsten Mal sind sie schon da.

### C4. Startpunkt festlegen (vor jeder Zeichnung)

Die Maschine weiß nach dem Einschalten nicht, wo der Stift gerade ist. Deshalb gibt es einen
festen **Startpunkt** („Home“). Auf dem Bildschirm ist er als **Fadenkreuz** eingezeichnet, die
Zahlen daneben sagen, wo er liegt (in mm von links und von der Linie zwischen den Motoren).
Oft ist er an der Maschine markiert.

1. Ziehen Sie den Stifthalter vorsichtig von Hand an diesen Punkt.
2. Klicken Sie im Reiter **„input“** auf **„Set home“**.

Mit **„Pen lift“** (Stift heben) und **„Pen drop“** (Stift senken) können Sie testen, ob sich der
Stift bewegt.

### C5. Eine Zeichnung laden und zeichnen

Die Maschine zeichnet am besten **Strichzeichnungen** im Format **SVG**.

1. Klicken Sie im Reiter **„input“** auf **„Load vector“** und wählen Sie eine SVG-Datei.
   (Ein zweiter Klick auf „Load vector“ entfernt die Zeichnung wieder, um eine andere zu laden.)
2. Die Zeichnung erscheint auf dem Bild der Maschine. Mit **„Move vector“** (verschieben) und
   **„Resize vector“** (Größe ändern) passen Sie Lage und Größe an.
3. Klicken Sie auf **„Draw vectors“**. Die Maschine beginnt zu zeichnen.
4. Zum Anhalten klicken Sie oben auf **„QUEUE RUNNING - click to pause“**.
5. Wenn sie fertig ist: **„Return to home“** fährt den Stift zurück zum Startpunkt.

**Woher bekomme ich SVG-Dateien?**
- Selbst zeichnen mit dem kostenlosen Programm [Inkscape](https://inkscape.org).
- **Kinderzeichnungen**: einscannen oder abfotografieren, in Inkscape öffnen und über
  **Pfad → Bitmap vektorisieren** in Striche umwandeln. Am besten klappt das mit dicken, dunklen
  Linien auf weißem Papier.
- Viele freie Strichzeichnungen gibt es auf [openclipart.org](https://openclipart.org).

Fotos gehen auch: über **„Load image file“**, dann mit **„Select Area“** einen Bereich wählen und
**„Render pixels…“**. Das ist etwas für später, wenn die ersten Zeichnungen klappen.

---

## Tipps für die Arbeit mit Kindern

- **Sicher aufhängen:** Die Maschine muss fest an Wand oder Platte hängen und darf nicht
  herunterfallen können.
- **Finger weg, solange sie zeichnet:** An Motoren und Schnüren kann man sich einklemmen. Ein
  Abstand von einem Schritt vor der Wand ist eine gute Regel.
- **Netzteil:** Nur das Netzteil der Maschine verwenden. Nach der Arbeit ausstecken.
- **Stifte:** Wasserlösliche Filzstifte sind ideal. Den Stift nur bei angehobenem Stifthalter
  wechseln.
- **Klein anfangen:** Eine Zeichnung in Postkartengröße ist in wenigen Minuten fertig. Große Bilder
  können über eine Stunde dauern. Ideal zum Zuschauen und Raten, was entsteht.
- **Idee für die Gruppe:** Jedes Kind zeichnet einen Teil, und die Maschine setzt alles zu einem
  großen Gemeinschaftsbild zusammen.

---

## Wenn es nicht klappt

| Problem | Lösung |
|---|---|
| Unter „Serial port…“ steht kein COM-Anschluss | USB-Kabel prüfen; manche Kabel laden nur und übertragen nichts. Viele günstige Arduinos brauchen einmalig den Treiber **CH340** (nach „CH340 Treiber Windows“ suchen). |
| Rot „Polargraph is not connected.“ | Anderen COM-Anschluss wählen. Arduino IDE schließen. Wurde Schritt A gemacht? |
| Verbunden, aber die Maschine bewegt sich nicht | Steht oben „QUEUE PAUSED“? Draufklicken. Ist das Netzteil eingesteckt? |
| Die Zeichnung ist verzerrt oder zu groß | Maße im Reiter „Setup“ prüfen (Schritt C3) und den Startpunkt neu setzen (Schritt C4). |
| Das Programm startet nicht | `start-polargraph-console.cmd` starten. Es zeigt Fehlermeldungen, die Sie bei einer Frage an andere mitschicken können. |

Weitere Hilfe: [Fehlersuche (englisch)](../troubleshooting.md),
[Firmware im Detail (englisch)](../firmware.md),
[Polargraph-Wiki (englisch)](https://github.com/euphy/polargraph/wiki).

---

## Kleines Wörterbuch

| Wort | Bedeutung |
|---|---|
| **Arduino** | Kleine Computerplatine, das „Gehirn“ der Maschine |
| **Firmware** | Die Steuerung, die auf dem Arduino läuft |
| **COM-Anschluss** | So nennt Windows die USB-Verbindung zur Maschine, zum Beispiel `COM3` |
| **SVG** | Dateiformat für Strichzeichnungen |
| **Zip-Datei** | Gepackter Ordner; muss vor dem Benutzen „extrahiert“ (entpackt) werden |
| **Home** | Der feste Startpunkt des Stifts |
| **Queue** | Warteschlange der Befehle, die nacheinander an die Maschine gehen |

---

*Polargraph wurde von Sandy Noble entwickelt ([polargraph.co.uk](http://www.polargraph.co.uk)).
Dieses portable Paket und die Anleitung: Samuel Peters, erstellt mit Hilfe von Claude (Anthropic).*
