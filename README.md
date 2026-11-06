# IEEE Version: Low-Power LoRa Wireless Sensor Mesh Network for Monitoring Soil Conditions on Icelandic Turf Roofs

IEEE-format (IEEEtran, journal style) paper of the M.Sc. thesis *Design and Implementation of a Low-Power LoRa Wireless Sensor Mesh Network with Cloud Storage for Monitoring Soil Conditions on Icelandic Turf Roofs* by Jezreel V. Tan, University of Iceland.

The thesis itself lives in [JezT25/msc-thesis-lora-turf-roof-monitoring](https://github.com/JezT25/msc-thesis-lora-turf-roof-monitoring) and is included here as the git submodule `thesis/`. This repository only contains the IEEE layout. The chapters, figures, and bibliography are read directly from the submodule, so a change in the thesis shows up here after updating the submodule.

## Repository Structure

```text
.
├── main.tex                   IEEE document (the only main file)
├── ieee/
│   ├── thesis-compat.sty      Typesets the thesis chapters unchanged inside IEEEtran
│   ├── abstract.tex           IEEE abstract and keywords
│   ├── conclusion.tex         IEEE conclusion
│   └── backmatter.tex         Appendix (ThingSpeak channels) and acknowledgment
├── scripts/
│   └── make-overleaf-zip.ps1  Builds overleaf.zip and overleaf/ (generated, not committed)
└── thesis/                    Submodule: msc-thesis-lora-turf-roof-monitoring
    ├── chapters/              Used: introduction, literature review, methodology, results
    ├── figs/                  Used: figures
    └── references.bib         Used: bibliography
```

What comes from where:

| Content | Source |
| --- | --- |
| Introduction, review of related literature, methodology, results and discussion | `thesis/chapters/*.tex`, included as is |
| Figures and bibliography | `thesis/figs/`, `thesis/references.bib` |
| Title, abstract, conclusion, acknowledgment, ThingSpeak appendix | `main.tex` and `ieee/` (in the thesis these are part of its `main.tex`, which cannot be included) |

The thesis abstract, conclusion, and appendix are rewritten for the paper. If their content changes in the thesis, update `ieee/abstract.tex`, `ieee/conclusion.tex`, and `ieee/backmatter.tex` by hand.

## Getting the Source

```bash
git clone --recurse-submodules https://github.com/JezT25/ieee-msc-thesis-lora-turf-roof-monitoring.git
```

If the repository was cloned without `--recurse-submodules`:

```bash
git submodule update --init
```

## Updating from the Thesis

After changing the thesis repository, pull the new version into this one and commit the new submodule pointer:

```bash
git submodule update --remote --merge thesis
git add thesis
git commit -m "Update thesis"
```

## Building Locally

Requires a TeX distribution with `pdflatex`, `biber`, and `latexmk`:

```bash
latexmk -pdf main.tex
```

## Publishing on Overleaf

Overleaf does not support git submodules, so a project imported from this repository through GitHub sync has an empty `thesis/` folder and fails with `File 'thesis/chapters/01_introduction.tex' not found`. Fix it with a self-contained bundle:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/make-overleaf-zip.ps1
```

The script creates `overleaf.zip` and an unzipped copy in `overleaf/`. Either:

- use **New Project > Upload Project** with `overleaf.zip`, or
- if the project was imported from GitHub, delete the empty `thesis` folder (the submodule) in Overleaf and upload the `overleaf/thesis` folder in its place.

Overleaf then compiles `main.tex` as is (pdfLaTeX, Biber). To refresh the thesis content later, update the submodule, re-run the script, and replace the `thesis` folder in Overleaf. Do not push the generated `overleaf/` folder or the flattened `thesis/` back to GitHub; the repository keeps the submodule.

The bundle contains the same paths as this repository (`main.tex`, `ieee/`, `thesis/chapters/`, `thesis/figs/`, `thesis/references.bib`), but it deliberately leaves out the thesis' own `main.tex`, README, cover banner, and other files that the IEEE document does not use. The project therefore has exactly one `main.tex`, and the thesis layout cannot interfere with the IEEE output.

## How the Thesis Chapters Are Reused

The chapter files are written for a one-column report class. `ieee/thesis-compat.sty` adapts them without editing them:

- Thesis sections become IEEE subsections, subsections become sub-subsections, and so on, because each chapter becomes one IEEE section.
- Figures and tables span both columns, which keeps the `\textwidth`-based sizes of the chapters working.
- `\clearpage` is disabled inside the chapters to avoid half-empty columns.
- `\subfigure` and `longtable` are made to work in two-column mode.

Known limitations of this approach:

- Text in the chapters that says "Chapter N" is not changed to "Section N".
- The bibliography uses `biblatex` with the `ieee` style so that the thesis `references.bib` can be used as is.
- The thesis appendix (bill of materials) and the Icelandic abstract are not part of the paper.

## Copyright

Copyright © 2027 Jezreel V. Tan. This thesis may not be copied in any form without the author's permission.
