# Builds overleaf/ (a folder) and overleaf.zip, self-contained copies of this project for Overleaf.
# Overleaf does not support git submodules, so thesis/ is copied in as plain files. The thesis'
# own main.tex (and everything else not needed for the IEEE build) is left out, so the result has
# exactly one main.tex.
param(
    [string]$Output = (Join-Path (Split-Path $PSScriptRoot -Parent) 'overleaf.zip')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Split-Path $PSScriptRoot -Parent
$thesis = Join-Path $root 'thesis'
$stage = Join-Path $root 'overleaf'

if (-not (Test-Path (Join-Path $thesis 'chapters'))) {
    throw 'The thesis submodule is empty. Run: git submodule update --init'
}

# Files to ship, as paths relative to the repository root.
$files = @('main.tex') + (Get-ChildItem (Join-Path $root 'ieee') -File | ForEach-Object { "ieee/$($_.Name)" })
$files += Get-ChildItem (Join-Path $thesis 'chapters') -Filter *.tex -File | ForEach-Object { "thesis/chapters/$($_.Name)" }
$files += 'thesis/references.bib'

# Only ship the figures that the chapters actually use (skips the thesis cover banner).
$figs = Get-ChildItem (Join-Path $thesis 'chapters') -Filter *.tex -File |
    ForEach-Object { [regex]::Matches((Get-Content $_.FullName -Raw), 'figs/[^\s{}\\,\]]+') } |
    ForEach-Object { $_.Value } | Sort-Object -Unique
foreach ($fig in $figs) {
    if (-not (Test-Path (Join-Path $thesis $fig))) { throw "Missing figure referenced by the chapters: $fig" }
    $files += "thesis/$fig"
}

if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
if (Test-Path $Output) { Remove-Item $Output }

$zip = [System.IO.Compression.ZipFile]::Open($Output, 'Create')
try {
    foreach ($file in $files) {
        $source = Join-Path $root ($file -replace '/', [IO.Path]::DirectorySeparatorChar)
        $target = Join-Path $stage ($file -replace '/', [IO.Path]::DirectorySeparatorChar)
        New-Item -ItemType Directory -Force (Split-Path $target -Parent) | Out-Null
        Copy-Item $source $target
        # Entry names must use forward slashes for Overleaf to create the folders.
        [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $source, $file, 'Optimal')
    }
}
finally {
    $zip.Dispose()
}

'{0}: {1} files, {2:N1} MB' -f $Output, $files.Count, ((Get-Item $Output).Length / 1MB)
'Folder: {0}' -f $stage
