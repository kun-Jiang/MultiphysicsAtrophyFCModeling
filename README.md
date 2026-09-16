# Code for Review – Manuscript

## Regional atrophy rates and functional connectivity degradation covary across brain regions in Alzheimer’s disease

**Authors:** Kun Jiang, Can Liao, Sujin Jiang, Jixin Hou, Tianming Liu, Gang Li, Taotao Wu, Ellen Kuhl, Xianqiao Wang, Xianyan Chen
**Corresponding author:** Xianqiao Wang

**Earlier preprint version:** [arXiv:2603.13598](https://doi.org/10.48550/arXiv.2603.13598)

---

## Overview

This repository contains the **simulation and figure-generation code** supporting the above manuscript.

The study presents a multiphysics framework integrating:

- Longitudinal structural MRI and cross-sectional resting-state functional MRI analysis
- Anisotropic tau reaction–diffusion modeling
- Finite-deformation brain atrophy simulations in Abaqus
- Region-wise comparison of simulated and imaging-derived atrophy
- Atrophy-informed neural-oscillation modeling of functional connectivity

---

## Repository Structure

```text
public_release/
├── README.md
├── Source_Data.xlsx
├── FEM/
│   ├── Umat.for
│   ├── iso160.inp
│   └── Model/
│       └── *.inp
├── Figure_*/
│   └── plot_*.m
└── Supplementary_Figure_*/
    └── plot_*.m
```

## Source Data and FEM Input Files

`Source_Data.xlsx` contains the source data used by the MATLAB plotting scripts.
The complete Abaqus input deck for the `iso160` finite-element case is included
under `FEM`, together with the `Umat.for` user subroutine.

Generated MATLAB figures and Abaqus output files are not included in the
repository.

---

## Software Requirements

- **MATLAB:** R2024a or later
- **Abaqus:** 2024 or later (Abaqus/Standard)

---

## Data Availability

Participant imaging data are not redistributed in this repository. The MRI,
fMRI, diffusion MRI, and tau-PET data used in the study were obtained from the
[Alzheimer’s Disease Neuroimaging Initiative (ADNI)](https://adni.loni.usc.edu/)
and remain subject to ADNI access requirements.

Subject-level data are not provided. Where applicable, `Source_Data.xlsx`
contains aggregate distribution summaries, sample sizes, and ROI-level results
instead. The group-averaged structural-connectivity matrix shown in Figure 8a
was reconstructed from dMRI in 26 cognitively normal ADNI participants and is
not redistributed here because the underlying participant data are controlled
access.

Processed source data supporting the figures are included in
`Source_Data.xlsx`. The `iso160` finite-element input deck is included under
`FEM`.
