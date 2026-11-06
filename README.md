# IEEE Version: Low-Power LoRa Wireless Sensor Mesh Network for Monitoring Soil Conditions on Icelandic Turf Roofs

IEEE-format (IEEEtran, journal style) paper of the M.Sc. thesis *Design and Implementation of a Low-Power LoRa Wireless Sensor Mesh Network with Cloud Storage for Monitoring Soil Conditions on Icelandic Turf Roofs* by Jezreel V. Tan, University of Iceland.

The thesis lives in [JezT25/msc-thesis-lora-turf-roof-monitoring](https://github.com/JezT25/msc-thesis-lora-turf-roof-monitoring) and is tracked here as the git submodule `thesis-src/`. Overleaf does not import submodules, so the files the paper needs are also copied into `thesis/` as plain files, and `main.tex` builds from that copy.

## Repository Structure

```text
.
├── main.tex                   IEEE document (the only main file)
├── ieee/
│   ├── thesis-compat.sty      Typesets the thesis chapters unchanged inside IEEEtran
│   ├── abstract.tex           IEEE abstract and keywords
│   ├── conclusion.tex         IEEE conclusion
│   └── backmatter.tex         Appendix (ThingSpeak channels) and acknowledgment
├── thesis/                    Plain-file copy of what the paper uses (built by Overleaf)
│   ├── chapters/              Introduction, literature review, methodology, results
│   ├── figs/                  Only the figures the chapters use
│   ├── references.bib         Bibliography
│   └── UPSTREAM.txt           Thesis commit this copy was taken from
├── thesis-src/                Submodule: the full thesis repository (not used by the build)
└── scripts/
    └── sync-thesis.ps1        Copies thesis-src/ into thesis/
```

The thesis' own `main.tex`, README, cover banner, and appendix files are deliberately not copied into `thesis/`. The project therefore has exactly one `main.tex`.

What comes from where:

| Content | Source |
| --- | --- |
| Introduction, review of related literature, methodology, results and discussion | `thesis/chapters/*.tex`, included as is |
| Figures and bibliography | `thesis/figs/`, `thesis/references.bib` |
| Title, abstract, conclusion, acknowledgment, ThingSpeak appendix | `main.tex` and `ieee/` (in the thesis these are part of its `main.tex`, which cannot be included) |

## Getting the Source

```bash
git clone --recurse-submodules https://github.com/JezT25/ieee-msc-thesis-lora-turf-roof-monitoring.git
```

If the repository was cloned without `--recurse-submodules`:

```bash
git submodule update --init
```

## Updating from the Thesis

1. Update the submodule:

   ```bash
   git submodule update --remote --merge thesis-src
   ```

2. Copy the thesis files into `thesis/`:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/sync-thesis.ps1
   ```

3. Update the IEEE-specific text by hand if the thesis changed it: `ieee/abstract.tex`, `ieee/conclusion.tex`, `ieee/backmatter.tex`, and the title in `main.tex`. These are rewritten for the paper because in the thesis they are part of its `main.tex`, which cannot be included.
4. Commit and push:

   ```bash
   git add -A
   git commit -m "Update thesis"
   git push
   ```

Never edit `thesis/` by hand; the next copy overwrites it.

## Publishing on Overleaf

1. Create the project once with **New Project > Import from GitHub** and pick this repository. The empty `thesis-src` submodule folder is ignored by Overleaf and does no harm.
2. After pushing an update, open **Menu > GitHub** in Overleaf and **Pull GitHub changes into Overleaf**.
3. Compile `main.tex` (pdfLaTeX, the default; Biber runs automatically).

## Building Locally

Requires a TeX distribution with `pdflatex`, `biber`, and `latexmk`:

```bash
latexmk -pdf main.tex
```

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
