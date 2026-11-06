# Copies what the IEEE paper needs from the thesis submodule (thesis-src/) into thesis/:
# the bibliography and only the figures that main.tex or ieee/*.tex include.
# Overleaf does not import submodules, so thesis/ holds a plain-file copy that it can compile.
# Update the submodule first: git submodule update --remote --merge thesis-src
param(
    [string]$Source = (Join-Path (Split-Path $PSScriptRoot -Parent) 'thesis-src')
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$dest = Join-Path $root 'thesis'

if (-not (Test-Path (Join-Path $Source 'figs'))) {
    throw 'The thesis submodule is empty. Run: git submodule update --init'
}

$commit = (git -C $Source rev-parse HEAD).Trim()

# Figure file names used by the paper, e.g. \includegraphics{method-image1.png}.
$texFiles = @(Get-Item (Join-Path $root 'main.tex')) + @(Get-ChildItem (Join-Path $root 'ieee') -Filter *.tex -File)
$figs = $texFiles |
    ForEach-Object { [regex]::Matches((Get-Content $_.FullName -Raw), '(?<=\{)[A-Za-z0-9_-]+\.(?:png|jpe?g)(?=\})') } |
    ForEach-Object { $_.Value } | Sort-Object -Unique
foreach ($fig in $figs) {
    if (-not (Test-Path (Join-Path $Source "figs/$fig"))) { throw "Figure not found in the thesis: $fig" }
}

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
New-Item -ItemType Directory -Force (Join-Path $dest 'figs') | Out-Null
foreach ($fig in $figs) { Copy-Item (Join-Path $Source "figs/$fig") (Join-Path $dest 'figs') }
Copy-Item (Join-Path $Source 'references.bib') $dest

Set-Content -Path (Join-Path $dest 'UPSTREAM.txt') -Encoding ASCII -Value @(
    'Copied by scripts/sync-thesis.ps1 from the thesis-src submodule. Do not edit.',
    "Commit: $commit"
)
"Copied thesis $commit into thesis/ ($($figs.Count) figures + references.bib)"
