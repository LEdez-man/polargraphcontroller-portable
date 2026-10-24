# Licensing: what may be published

This page explains which parts may be redistributed in a public GitHub repository or release, and
why the package contains a Temurin JRE instead of the Oracle JRE or the Processing IDE.
It is a summary for this project, not legal advice.

## Summary

| Part | License | Redistribute? | Decision |
|---|---|---|---|
| Polargraph Controller 2.4.2 (binaries and source) | GPL-3.0-or-later | Yes, together with the source code | Included; source in `sketchbook\`, link to upstream |
| Libraries in `controller\lib\` | LGPL-2.1, LGPL-3.0, GPL-2.0+, GPL-3.0, BSD, Apache-2.0 | Yes, with license notices | Included unchanged, see [THIRD-PARTY-NOTICES.md](../THIRD-PARTY-NOTICES.md) |
| Eclipse Temurin 8 JRE | GPL-2.0 with Classpath Exception | Yes | **Included** as `controller\jre\` |
| Oracle JRE 7u40 | Oracle Binary Code License (BCL) | Only under conditions | Not included |
| Oracle JRE 8u211 and later (e.g. 8u321) | Oracle Technology Network License | No | Not included |
| Processing 2.2.1 IDE | GPL-2.0, bundles Oracle JRE 7u40 | The IDE yes, the bundled JRE only under the BCL conditions | Not included; download link in [development.md](development.md) |
| Launchers, scripts, docs of this repository | GPL-3.0-or-later | Yes | – |

## Details

**Polargraph Controller** is GPL-3.0-or-later (see the header of `polargraphcontroller.pde`).
Anyone who distributes the binaries must also make the corresponding source code available. The
package therefore contains the unchanged sketch in `sketchbook\polargraphcontroller\` and the
library sources in `sketchbook\libraries\`, and `BUILD-INFO.txt` links to the upstream repository.

**Oracle JRE 7u40** is covered by the old Oracle Binary Code License. It allowed bundling the JRE
with an application only under supplementary conditions: unchanged and complete, only for running
that application, distributed under a license agreement that protects Oracle's interests, and with
an obligation to indemnify Oracle. In addition, Java 7u40 (2013) has many known security
vulnerabilities. That is why the Processing 2.2.1 download bundled it, but this project does not.

**Oracle JRE 8u211 and later** are covered by the Oracle Technology Network License Agreement,
which does not permit redistribution.

**Eclipse Temurin** is an OpenJDK build. GPL-2.0 with Classpath Exception allows redistribution with
an application of any license, as long as the JRE's own license and notice files are included (they
are part of `controller\jre\`).

**Processing 2.2.1** is free software (IDE GPL-2.0, core LGPL-2.1), but the Windows download contains
the Oracle JRE 7u40. The download (116 MB) is still available from the
[Processing 2.2.1 release on GitHub](https://github.com/processing/processing/releases/tag/processing-0227-2.2.1),
so the package links to it instead of bundling it.

## Practical rules for this repository

- Binaries (JRE, upstream zip, release zip) are never committed. The build script downloads them and
  GitHub Actions attaches the result to a release.
- Every release contains `LICENSE`, `THIRD-PARTY-NOTICES.md`, `BUILD-INFO.txt` and the source code of
  the controller.
- The package is built only from the official upstream release, never from a personal installation,
  so that no personal settings or paths end up in it. The build script also checks this.
