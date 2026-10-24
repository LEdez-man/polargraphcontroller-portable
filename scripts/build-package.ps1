<#
SPDX-License-Identifier: GPL-3.0-or-later

.SYNOPSIS
    Builds the portable Windows package of Polargraph Controller 2.4.2.

.DESCRIPTION
    1. Gets the upstream Polargraph release 2017-11-01 (euphy/polargraphcontroller).
    2. Gets a 64-bit Java 8 runtime (Eclipse Temurin) or uses a local JRE folder.
    3. Assembles <OutDir>\Polargraph-portable\ with launchers, source, docs and licenses.
    4. Removes settings files the controller writes itself and fails if any user path is left.
    5. Runs a smoke test (Java starts, jSSC native library loads) and creates the zip.

.EXAMPLE
    ./scripts/build-package.ps1 -Version v1.0.0
    Downloads everything and builds dist\Polargraph-portable-win64-v1.0.0.zip.

.EXAMPLE
    ./scripts/build-package.ps1 -UpstreamDir 'D:\Polargraph 2017-11-01' -JreDir 'D:\jre8' -NoZip
    Builds from local folders without downloading anything.
#>
[CmdletBinding()]
param(
    [string]$Version = 'dev',
    # Local copy of Polargraph.2017-11-01.zip, instead of downloading it.
    [string]$UpstreamZip,
    # Already unpacked upstream release (folder containing controller\ and processing-source\).
    [string]$UpstreamDir,
    # Local JRE folder (must contain bin\javaw.exe), instead of downloading Temurin 8.
    [string]$JreDir,
    # Optional local Processing 2.2.1 folder. Only for personal use: it bundles an Oracle JRE
    # that must not be redistributed (see docs\licensing.md).
    [string]$ProcessingDir,
    [string]$OutDir,
    [switch]$NoZip
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # Invoke-WebRequest is very slow with the progress bar

$RepoRoot = Split-Path -Parent $PSScriptRoot
if (-not $OutDir) { $OutDir = Join-Path $RepoRoot 'dist' }
$CacheDir = Join-Path $RepoRoot 'build\cache'
$WorkDir  = Join-Path $RepoRoot 'build\work'

$UpstreamUrl    = 'https://github.com/euphy/polargraphcontroller/releases/download/2017-11-01-20-30/Polargraph.2017-11-01.zip'
$UpstreamSha256 = 'e665f1c4b2baeb1fb445be7b907970948c2b18aef5586786d0eaac9208bddb53'
$TemurinApi     = 'https://api.adoptium.net/v3/assets/latest/8/hotspot?architecture=x64&image_type=jre&os=windows&vendor=eclipse'

# Machine profiles that upstream ships as examples. Every other *.properties.txt is written by the
# controller itself (default.properties.txt) or is someone's own machine setup and is not shipped.
$KeepProperties = @('ikea.properties.txt', 'Polargraphsd spec.properties.txt')

# Absolute user paths in any spelling: C:\Users\x, C:/Users/x, C\:\\Users\\x (Java properties).
$PrivacyPatterns = @('[A-Za-z]\\?:[\\/]+Users[\\/]+', '[A-Za-z]\\?:[\\/]+Dokumente und Einstellungen', '[A-Za-z]\\?:[\\/]+Documents and Settings')

if ($Version -notmatch '^[A-Za-z0-9._-]+$') { throw "Invalid version '$Version' (allowed: letters, digits, . _ -)" }
if ($PSVersionTable.PSVersion.Major -lt 6 -and $OutDir.Length -gt 120) {
    # Library examples in the package are nested deeply; Windows PowerShell 5.1 fails beyond 260 characters.
    Write-Warning "OutDir is $($OutDir.Length) characters long. Use a shorter -OutDir or PowerShell 7 (pwsh)."
}

function Write-Step([string]$Message) { Write-Host "==> $Message" -ForegroundColor Cyan }

function Reset-Dir([string]$Path) {
    if (Test-Path -LiteralPath $Path) { Remove-Item -LiteralPath $Path -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Get-RemoteFile([string]$Url, [string]$Path) {
    if (Test-Path -LiteralPath $Path) { Write-Host "    cached: $(Split-Path -Leaf $Path)"; return }
    Write-Host "    downloading $Url"
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    Invoke-WebRequest -Uri $Url -OutFile "$Path.part" -UseBasicParsing
    Move-Item -LiteralPath "$Path.part" -Destination $Path
}

function Assert-Sha256([string]$Path, [string]$Expected) {
    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
    if ($Expected -and $actual -ne $Expected.ToLowerInvariant()) {
        throw "SHA-256 mismatch for $(Split-Path -Leaf $Path)`n  expected $Expected`n  actual   $actual"
    }
    Write-Host "    sha256 $actual"
}

function Copy-Tree([string]$Source, [string]$Dest, [string[]]$ExcludeDirs = @(), [string[]]$ExcludeFiles = @()) {
    $rc = @($Source, $Dest, '/E', '/NFL', '/NDL', '/NJH', '/NJS', '/NP', '/R:1', '/W:1')
    if ($ExcludeDirs.Count)  { $rc += '/XD'; $rc += $ExcludeDirs }
    if ($ExcludeFiles.Count) { $rc += '/XF'; $rc += $ExcludeFiles }
    & robocopy @rc | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed with code $LASTEXITCODE`: $Source -> $Dest" }
    $global:LASTEXITCODE = 0
}

function Invoke-Tool([string]$Exe, [string]$Arguments) {
    $out = [IO.Path]::GetTempFileName()
    $err = [IO.Path]::GetTempFileName()
    try {
        $p = Start-Process -FilePath $Exe -ArgumentList $Arguments -NoNewWindow -Wait -PassThru `
            -RedirectStandardOutput $out -RedirectStandardError $err
        [pscustomobject]@{ ExitCode = $p.ExitCode; Output = "$(Get-Content -Raw $out)$(Get-Content -Raw $err)".Trim() }
    }
    finally { Remove-Item -LiteralPath $out, $err -ErrorAction SilentlyContinue }
}

function Get-PackageFiles([string]$Root, [string[]]$SkipDirs, [string]$Rel = '') {
    # Walks the package without entering $SkipDirs (relative paths). Not entering controller\jre
    # avoids the 260-character path limit of Windows PowerShell 5.1 in deep JRE folders.
    foreach ($item in Get-ChildItem -LiteralPath $Root -Force) {
        $itemRel = if ($Rel) { "$Rel\$($item.Name)" } else { $item.Name }
        if ($item.PSIsContainer) {
            if ($SkipDirs -notcontains $itemRel) { Get-PackageFiles $item.FullName $SkipDirs $itemRel }
        }
        else {
            [pscustomobject]@{ File = $item; Rel = $itemRel }
        }
    }
}

function Find-Upstream([string]$Root) {
    # The release zip contains one top-level folder; accept that folder or the zip root itself.
    $candidates = @(Get-Item -LiteralPath $Root) + @(Get-ChildItem -LiteralPath $Root -Directory)
    foreach ($c in $candidates) {
        $app    = Join-Path $c.FullName 'controller\application.windows64'
        $sketch = Join-Path $c.FullName 'processing-source\polargraphcontroller'
        if ((Test-Path -LiteralPath (Join-Path $app 'lib\polargraphcontroller.jar')) -and
            (Test-Path -LiteralPath (Join-Path $sketch 'polargraphcontroller.pde'))) {
            return [pscustomobject]@{ App = $app; Sketch = $sketch }
        }
    }
    throw "No controller\application.windows64 and processing-source\polargraphcontroller found in $Root"
}

# --- 1. Upstream release ---------------------------------------------------------------------
Write-Step 'Upstream Polargraph release 2017-11-01'
if ($UpstreamDir) {
    $upstreamLabel = 'local copy of the upstream release 2017-11-01'
}
else {
    if (-not $UpstreamZip) {
        $UpstreamZip = Join-Path $CacheDir 'Polargraph.2017-11-01.zip'
        Get-RemoteFile $UpstreamUrl $UpstreamZip
    }
    Assert-Sha256 $UpstreamZip $UpstreamSha256
    $UpstreamDir = Join-Path $WorkDir 'upstream'
    Reset-Dir $UpstreamDir
    Expand-Archive -LiteralPath $UpstreamZip -DestinationPath $UpstreamDir
    $upstreamLabel = $UpstreamUrl
}
$upstream = Find-Upstream $UpstreamDir

# --- 2. Java runtime -------------------------------------------------------------------------
Write-Step 'Java runtime'
if ($JreDir) {
    $releaseFile = Join-Path $JreDir 'release'
    $jreLabel = 'local JRE'
    if (Test-Path -LiteralPath $releaseFile) {
        $v = Select-String -LiteralPath $releaseFile -Pattern '^JAVA_VERSION="(.+)"' | Select-Object -First 1
        if ($v) { $jreLabel = "local JRE $($v.Matches[0].Groups[1].Value)" }
    }
}
else {
    $assets = @(Invoke-RestMethod -Uri $TemurinApi -UseBasicParsing)
    $asset = $assets | Where-Object { $_.binary.package.name -like '*.zip' } | Select-Object -First 1
    if (-not $asset) { throw 'No Temurin 8 JRE zip for Windows x64 found via the Adoptium API.' }
    $jreZip = Join-Path $CacheDir $asset.binary.package.name
    Get-RemoteFile $asset.binary.package.link $jreZip
    Assert-Sha256 $jreZip $asset.binary.package.checksum
    $jreExtract = Join-Path $WorkDir 'jre'
    Reset-Dir $jreExtract
    Expand-Archive -LiteralPath $jreZip -DestinationPath $jreExtract
    $JreDir = (Get-ChildItem -LiteralPath $jreExtract -Directory | Select-Object -First 1).FullName
    $jreLabel = "Eclipse Temurin $($asset.release_name) JRE, Windows x64"
}
if (-not (Test-Path -LiteralPath (Join-Path $JreDir 'bin\javaw.exe'))) { throw "No bin\javaw.exe in $JreDir" }
Write-Host "    $jreLabel"

# --- 3. Assemble -----------------------------------------------------------------------------
Write-Step 'Assembling package'
$pkgDir = Join-Path $OutDir 'Polargraph-portable'
if ((Test-Path -LiteralPath $pkgDir) -and -not (Test-Path -LiteralPath (Join-Path $pkgDir 'BUILD-INFO.txt'))) {
    throw "$pkgDir exists but was not created by this script; refusing to overwrite it."
}
Reset-Dir $pkgDir

$noise = @('launch4j.log', 'Thumbs.db', 'desktop.ini')
Copy-Tree $upstream.App (Join-Path $pkgDir 'controller') -ExcludeFiles $noise
Copy-Tree $JreDir (Join-Path $pkgDir 'controller\jre')
Copy-Tree $upstream.Sketch (Join-Path $pkgDir 'sketchbook\polargraphcontroller') -ExcludeFiles $noise `
    -ExcludeDirs @('.git', 'libraries', 'application.windows32', 'application.windows64',
                   'application.linux32', 'application.linux64', 'application.macosx')
$sketchLibs = Join-Path $upstream.Sketch 'libraries'
if (Test-Path -LiteralPath $sketchLibs) { Copy-Tree $sketchLibs (Join-Path $pkgDir 'sketchbook\libraries') -ExcludeFiles $noise }
if ($ProcessingDir) { Copy-Tree $ProcessingDir (Join-Path $pkgDir 'processing-2.2.1') }

Copy-Item -Path (Join-Path $RepoRoot 'launchers\*.cmd') -Destination $pkgDir
foreach ($f in 'README.md', 'RELEASE-NOTES.md', 'CHANGELOG.md', 'LICENSE', 'THIRD-PARTY-NOTICES.md') {
    Copy-Item -LiteralPath (Join-Path $RepoRoot $f) -Destination $pkgDir
}
Copy-Tree (Join-Path $RepoRoot 'docs') (Join-Path $pkgDir 'docs')

$thirdPartyDirs = @('controller\jre', 'processing-2.2.1')
$settingsFiles = Get-PackageFiles $pkgDir $thirdPartyDirs |
    Where-Object { $_.Rel -like '*.properties.txt' -and $KeepProperties -notcontains $_.File.Name }
foreach ($s in $settingsFiles) {
    Remove-Item -LiteralPath $s.File.FullName
    Write-Host "    removed settings file: $($s.Rel)"
}
# The kept example profiles may still point to images or vectors on their author's computer.
$profiles = Get-PackageFiles $pkgDir $thirdPartyDirs | Where-Object { $KeepProperties -contains $_.File.Name }
foreach ($p in $profiles) {
    $lines = [IO.File]::ReadAllLines($p.File.FullName)
    $clean = $lines -replace '^(controller\.(image|vector)\.filename)=.+$', '$1='
    if (Compare-Object $lines $clean) {
        [IO.File]::WriteAllLines($p.File.FullName, $clean)
        Write-Host "    cleared file paths in example profile: $($p.Rel)"
    }
}

$buildInfo = @(
    'Polargraph Controller - portable package for Windows (64-bit)',
    "Package version : $Version",
    "Built (UTC)     : $((Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm'))",
    "Controller      : Polargraph Controller 2.4.2, unchanged binaries from $upstreamLabel",
    "Source code     : sketchbook\polargraphcontroller and https://github.com/euphy/polargraphcontroller",
    "Java runtime    : $jreLabel"
)
if ($ProcessingDir) { $buildInfo += 'Processing      : 2.2.1 (personal build, not for redistribution)' }
Set-Content -LiteralPath (Join-Path $pkgDir 'BUILD-INFO.txt') -Value $buildInfo -Encoding ASCII

# --- 4. Privacy check ------------------------------------------------------------------------
Write-Step 'Privacy check (user paths)'
$hits = foreach ($f in Get-PackageFiles $pkgDir $thirdPartyDirs) {
    $bytes = [IO.File]::ReadAllBytes($f.File.FullName)
    if ([Array]::IndexOf($bytes, [byte]0, 0, [Math]::Min($bytes.Length, 8192)) -ge 0) { continue }   # binary
    Select-String -LiteralPath $f.File.FullName -Pattern $PrivacyPatterns |
        ForEach-Object { '{0}:{1}' -f $f.Rel, $_.LineNumber }
}
if ($hits) { throw "Absolute user paths found in the package:`n  $($hits -join "`n  ")" }
Write-Host '    no user paths found'

# --- 5. Smoke test and zip -------------------------------------------------------------------
Write-Step 'Smoke test'
$jreBin = Join-Path $pkgDir 'controller\jre\bin'
$java = Invoke-Tool (Join-Path $jreBin 'java.exe') '-version'
if ($java.ExitCode -ne 0) { throw "java -version failed:`n$($java.Output)" }
Write-Host "    $(($java.Output -split "`n")[0].Trim())"

$jjs = Join-Path $jreBin 'jjs.exe'
if (Test-Path -LiteralPath $jjs) {
    # Point user.home to an empty folder so jSSC cannot fall back to a DLL in %USERPROFILE%\.jssc:
    # the test passes only if java.library.path=lib works, exactly as in the launchers.
    $lib = Join-Path $pkgDir 'controller\lib'
    $fakeHome = Join-Path $WorkDir 'empty-home'
    Reset-Dir $fakeHome
    $js = Join-Path $WorkDir 'jssc-test.js'
    Set-Content -LiteralPath $js -Encoding ASCII -Value "var n = Java.type('jssc.SerialPortList').getPortNames(); print('jSSC loaded, serial ports: ' + n.length);"
    $t = Invoke-Tool $jjs "-J-Djava.library.path=`"$lib`" -J-Duser.home=`"$fakeHome`" -cp `"$lib\jssc.jar`" `"$js`""
    if ($t.ExitCode -ne 0 -or $t.Output -notmatch 'jSSC loaded') { throw "jSSC smoke test failed:`n$($t.Output)" }
    Write-Host "    $($t.Output)"
}
else {
    Write-Warning 'jjs.exe not in this JRE (Java 7?), jSSC smoke test skipped.'
}

if (-not $NoZip) {
    Write-Step 'Creating zip'
    $zip = Join-Path $OutDir "Polargraph-portable-win64-$Version.zip"
    Remove-Item -LiteralPath $zip, "$zip.sha256" -ErrorAction SilentlyContinue
    Compress-Archive -Path $pkgDir -DestinationPath $zip -CompressionLevel Optimal
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $zip).Hash.ToLowerInvariant()
    Set-Content -LiteralPath "$zip.sha256" -Value "$hash  $(Split-Path -Leaf $zip)" -Encoding ASCII
    Write-Host "    $zip"
    Write-Host "    sha256 $hash"
}
Write-Step "Done: $pkgDir"
