# IEEE Paper: Low-Power LoRa Wireless Sensor Mesh Network for Monitoring Soil Conditions on Icelandic Turf Roofs

Condensed IEEE-format research paper (IEEEtran, journal style) based on the M.Sc. thesis *Design and Implementation of a Low-Power LoRa Wireless Sensor Mesh Network with Cloud Storage for Monitoring Soil Conditions on Icelandic Turf Roofs* by Jezreel V. Tan, University of Iceland.

The paper is a short version of the thesis: the system design, methodology, and main results, without the background chapters, derivations, per-node plots, and appendices. The text is written for the paper in `ieee/`. The thesis itself lives in [JezT25/msc-thesis-lora-turf-roof-monitoring](https://github.com/JezT25/msc-thesis-lora-turf-roof-monitoring) and is tracked here as the git submodule `thesis-src/`, which serves as the source for facts, figures, and references. Overleaf does not import submodules, so the figures and bibliography the paper uses are copied into `thesis/` as plain files, and `main.tex` builds from that copy.

## Repository Structure

```text
.
├── main.tex                   Paper preamble, title, and section includes (the only main file)
├── ieee/
│   ├── abstract.tex           Abstract and keywords
│   ├── introduction.tex       I. Introduction
│   ├── related-work.tex       II. Related Work
│   ├── system-design.tex      III. System Design
│   ├── methodology.tex        IV. Experimental Methodology
│   ├── results.tex            V. Results and Discussion
│   ├── conclusion.tex         VI. Conclusion and Future Work
│   └── backmatter.tex         Data and code availability, acknowledgment
├── thesis/                    Plain-file copy used by the build (do not edit)
│   ├── figs/                  Only the figures the paper includes
│   ├── references.bib         Bibliography
│   └── UPSTREAM.txt           Thesis commit this copy was taken from
├── thesis-src/                Submodule: the full thesis repository (not used by the build)
└── scripts/
    └── sync-thesis.ps1        Copies the paper's figures and bibliography from thesis-src/ into thesis/
```

Only `references.bib` and the figures named in `main.tex` and `ieee/*.tex` are copied into `thesis/`, so the project contains no thesis `main.tex` and no unused files.

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

2. Compare the changes with the paper (`git -C thesis-src log -p`) and edit the matching text in `ieee/` by hand. Numbers, claims, and limitations in the paper must stay consistent with the thesis. The abstract, conclusion, and title also come from the thesis' own `main.tex`.
3. If you add or change a figure or a citation in the paper, use the figure file name from `thesis-src/figs/` and a key from `thesis-src/references.bib`. The next step copies them.
4. Copy the figures and bibliography into `thesis/`:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/sync-thesis.ps1
   ```

5. Commit and push:

   ```bash
   git add -A
   git commit -m "Update paper"
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

## Notes on the Paper

- The bibliography uses `biblatex` with the `ieee` style so that the thesis `references.bib` can be used as is. Only cited entries appear in the paper.
- Claims keep the thesis' wording on limits: the mesh relay was observed qualitatively, the soil-moisture RMSE is in-sample, and the Keldur record spans are not confirmed battery lifetimes.
- The comparison with the Turf-House Monitoring Project dataset (Section V) is a non-co-located consistency check: its soil-moisture offset adjustment is exploratory and does not establish absolute accuracy.
- The paper follows the thesis terminology "Keldur turf site" and the 110~mm design burial depth. The paper is in sync with thesis commit `d04716a` (see `thesis/UPSTREAM.txt`).

## Copyright

Copyright © 2027 Jezreel V. Tan. This thesis may not be copied in any form without the author's permission.
