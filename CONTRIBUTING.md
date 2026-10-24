# Contributing

Thanks for helping. This project packages Polargraph Controller; it does not change the controller
itself.

- **Bugs in the package** (launchers, bundled Java, build script, documentation): open an issue or a
  pull request here. The issue template asks for the console output and `BUILD-INFO.txt`.
- **Bugs or features in the controller or the firmware:** please report them upstream at
  [euphy/polargraphcontroller](https://github.com/euphy/polargraphcontroller).

## Pull requests

1. Keep changes small and focused; one topic per pull request.
2. Run `.\scripts\build-package.ps1` locally; the privacy check and the smoke test must pass.
3. Test the package with the checklist in [docs/development.md](docs/development.md), ideally on a
   real machine.
4. Add an entry to `CHANGELOG.md` under "Unreleased".

## Rules

- Never commit binaries (JRE, zip files, Processing) or personal settings files
  (`default.properties.txt`). `.gitignore` covers the usual cases.
- Batch files use CRLF line endings and ASCII only (`.gitattributes` enforces the line endings).
- Do not put absolute user paths into files that end up in the package.
- By contributing you agree that your contribution is licensed under GPL-3.0-or-later.
