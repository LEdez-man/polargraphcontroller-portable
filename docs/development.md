# Development

## Repository layout

| Path | Purpose |
|---|---|
| `launchers\` | Batch files copied into the package root |
| `scripts\build-package.ps1` | Builds the package and the release zip |
| `docs\` | Documentation, also copied into the package |
| `.github\workflows\build.yml` | CI build; attaches the zip to releases |

Build output goes to `build\` (downloads, temporary files) and `dist\` (package and zip). Both are
ignored by git.

## Build options

```powershell
# Full build, downloads upstream release and Temurin 8 JRE
.\scripts\build-package.ps1 -Version v0.1.0

# Offline build from local folders, no zip
.\scripts\build-package.ps1 -UpstreamZip .\Polargraph.2017-11-01.zip -JreDir D:\jre8 -NoZip
.\scripts\build-package.ps1 -UpstreamDir 'D:\Polargraph 2017-11-01' -JreDir D:\jre8 -NoZip

# Personal package including Processing 2.2.1 (do not publish, see licensing.md)
.\scripts\build-package.ps1 -ProcessingDir D:\processing-2.2.1 -NoZip
```

If Windows PowerShell refuses to run the script, start it with
`powershell -ExecutionPolicy Bypass -File .\scripts\build-package.ps1`.

The script:

1. downloads `Polargraph.2017-11-01.zip` from the upstream release and checks its SHA-256,
2. asks the Adoptium API for the latest Temurin 8 JRE (Windows x64), downloads it and checks the
   SHA-256 published by Adoptium,
3. assembles `dist\Polargraph-portable\`,
4. deletes settings files the controller writes itself (`*.properties.txt` except the upstream
   example profiles), clears image and vector file paths in the example profiles, and fails if any
   text file still contains an absolute user path,
5. runs `java -version` and loads jSSC with an empty `user.home`, so the test passes only if the
   DLL is found through `java.library.path`, exactly as in the launchers,
6. creates `dist\Polargraph-portable-win64-<version>.zip` and a `.sha256` file.

## Release process

1. Update `CHANGELOG.md`.
2. Test the package on a real machine (checklist below).
3. Tag and push: `git tag v0.1.0` and `git push origin v0.1.0`.
4. GitHub Actions builds the package and attaches the zip and its checksum to the release.

## Test checklist

- [ ] `start-polargraph.cmd` opens the controller window.
- [ ] Serial ports are listed; the machine connects and reports `READY`.
- [ ] A small vector drawing runs to the end.
- [ ] The package works from a path with spaces and from a USB stick.
- [ ] The package works on a PC without any installed Java.

## Working on the controller source

Polargraph Controller is a Processing 2.2.1 sketch. Newer Processing versions do not run it without
porting.

1. Download Processing 2.2.1 for Windows from the
   [Processing 2.2.1 release on GitHub](https://github.com/processing/processing/releases/tag/processing-0227-2.2.1)
   (`processing-2.2.1-windows64.zip`, 116 MB) and unpack it so that `processing.exe` is in
   `processing-2.2.1\` next to the launchers.
2. Start `start-processing.cmd`.
3. In Processing, set **File > Preferences > Sketchbook location** to the `sketchbook\` folder of the
   package, so that controlP5, Geomerative and diewald_CV_kit are found. Restart Processing.
4. Changes to the controller itself belong upstream: [euphy/polargraphcontroller](https://github.com/euphy/polargraphcontroller).

## Coding conventions

- Batch files: CRLF line endings, ASCII only, `setlocal`, no paths inside parenthesised blocks
  (a `)` in a folder name such as `Program Files (x86)` would end the block); use `goto` labels.
- PowerShell: must run on Windows PowerShell 5.1 and PowerShell 7; `Set-StrictMode -Version Latest`.
- Never commit binaries or personal settings files.
