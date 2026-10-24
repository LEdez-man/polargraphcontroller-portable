# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/). Detailed notes for the current release are in
[RELEASE-NOTES.md](RELEASE-NOTES.md).

## [Unreleased]

## [0.1.0] – unreleased

### Added

- Portable package of Polargraph Controller 2.4.2 (upstream release 2017-11-01) for Windows 64-bit.
- Bundled Eclipse Temurin 8 JRE in `controller\jre\`, so the system Java is no longer used.
- `start-polargraph.cmd` and `start-polargraph-console.cmd`: start the controller with the bundled
  Java and `-Djava.library.path=lib`.
- `install-jssc-dll.cmd`: optional fix for the original `polargraphcontroller.exe`.
- `start-processing.cmd`: opens the sketch in Processing 2.2.1 for development.
- Build script `scripts/build-package.ps1` with SHA-256 checks, privacy check and smoke test.
- GitHub Actions workflow that builds the package and attaches it to releases.
- Documentation: README, release notes, troubleshooting, licensing, development.

### Fixed

- `UnsatisfiedLinkError: jssc.SerialNativeInterface.getSerialPortNames()` when the controller runs on
  a 64-bit Java and jSSC finds only a 32-bit DLL, for example after a Java update.

### Removed

- `default.properties.txt` is no longer shipped; the controller creates it on first start.
- File paths from their authors' computers in the upstream example profiles (`controller.image.filename`,
  `controller.vector.filename`).
