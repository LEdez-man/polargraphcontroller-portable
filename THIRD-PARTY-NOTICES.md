# Third-party notices

The release package contains the following third-party components. They are distributed unchanged.
The license texts are included with each component (in `controller\jre\`, in `sketchbook\libraries\`)
or available at the linked sources.

| Component | Version | Copyright | License | Location in package | Source |
|---|---|---|---|---|---|
| Polargraph Controller | 2.4.2 | Sandy Noble | GPL-3.0-or-later | `controller\`, `sketchbook\polargraphcontroller\` | [euphy/polargraphcontroller](https://github.com/euphy/polargraphcontroller) |
| Processing core | 2.2.1 | Processing Foundation, Ben Fry, Casey Reas | LGPL-2.1 | `controller\lib\core.jar` | [processing/processing](https://github.com/processing/processing) (tag `processing-0227-2.2.1`) |
| Processing serial library | 2.2.1 | Processing Foundation | LGPL-2.1 | `controller\lib\serial.jar` | as above |
| jSSC (Java Simple Serial Connector), modified | 2.8 | Alexey Sokolov; modifications Gottfried Haider | LGPL-3.0 | `controller\lib\jssc.jar`, `jSSC-2.8.dll` | [gohai/java-simple-serial-connector](https://github.com/gohai/java-simple-serial-connector) |
| JOGL, GlueGen | 2.1.5 | JogAmp Community | BSD-style (JogAmp) | `controller\lib\jogl-*.jar`, `gluegen-*.jar` | [jogamp.org](https://jogamp.org) |
| controlP5 | 2.2.5 | Andreas Schlegel | LGPL-2.1-or-later | `controller\lib\controlP5.jar`, `sketchbook\libraries\controlP5\` | [sojamo/controlp5](https://github.com/sojamo/controlp5) |
| Geomerative | – | Ricard Marxer | GPL-3.0 (bundled `COPYING`) | `controller\lib\geomerative.jar`, `sketchbook\libraries\geomerative\` | [rikrd/geomerative](https://github.com/rikrd/geomerative) |
| Apache Batik (font subset) | – | The Apache Software Foundation | Apache-2.0 | `controller\lib\batikfont.jar` | [xmlgraphics.apache.org/batik](https://xmlgraphics.apache.org/batik/) |
| diewald_CV_kit | – | Thomas Diewald | GPL-2.0-or-later | `controller\lib\diewald_CV_kit.jar`, `sketchbook\libraries\diewald_CV_kit\` | [thomasdiewald.com](http://thomasdiewald.com) |
| Eclipse Temurin JRE | 8 (see `BUILD-INFO.txt`) | Eclipse Adoptium, Oracle and contributors | GPL-2.0 with Classpath Exception, plus third-party notices in `controller\jre\` | `controller\jre\` | [adoptium.net](https://adoptium.net) |

Versions marked "–" are the ones shipped with the upstream release 2017-11-01; they have no separate
version number in the release.

## This repository

Launchers, build scripts and documentation: Copyright (C) 2026 Samuel Peters, GPL-3.0-or-later.
Created with the help of Claude (Anthropic).
