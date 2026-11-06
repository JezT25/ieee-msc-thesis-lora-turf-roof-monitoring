# Copies the files the IEEE paper needs from the thesis submodule (thesis-src/) into thesis/.
# Overleaf does not import submodules, so thesis/ holds a plain-file copy that it can compile.
# Update the submodule first: git submodule update --remote --merge thesis-src
param(
    [string]$Source = (Join-Path (Split-Path $PSScriptRoot -Parent) 'thesis-src')
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$dest = Join-Path $root 'thesis'

if (-not (Test-Path (Join-Path $Source 'chapters'))) {
    throw 'The thesis submodule is empty. Run: git submodule update --init'
}

$commit = (git -C $Source rev-parse HEAD).Trim()
$chapters = Get-ChildItem (Join-Path $Source 'chapters') -Filter *.tex -File

# Only the figures that the chapters use (skips the thesis cover banner and unused images).
$figs = $chapters |
    ForEach-Object { [regex]::Matches((Get-Content $_.FullName -Raw), 'figs/[^\s{}\\,\]]+') } |
    ForEach-Object { $_.Value } | Sort-Object -Unique
foreach ($fig in $figs) {
    if (-not (Test-Path (Join-Path $Source $fig))) { throw "Missing figure referenced by the chapters: $fig" }
}

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
New-Item -ItemType Directory -Force (Join-Path $dest 'chapters'), (Join-Path $dest 'figs') | Out-Null
$chapters | Copy-Item -Destination (Join-Path $dest 'chapters')
foreach ($fig in $figs) { Copy-Item (Join-Path $Source $fig) (Join-Path $dest 'figs') }
Copy-Item (Join-Path $Source 'references.bib') $dest

Set-Content -Path (Join-Path $dest 'UPSTREAM.txt') -Encoding ASCII -Value @(
    'Copied by scripts/sync-thesis.ps1 from the thesis-src submodule. Do not edit.',
    "Commit: $commit"
)
"Copied thesis $commit into thesis/ ($($chapters.Count) chapters, $($figs.Count) figures)"
