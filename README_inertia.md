# Inertia Branch Usage

This branch introduces an optional system inertia constraint. To use it you need to provide new input data and settings beyond those required in the main GenX branch.

## New Settings

- `InertiaRequirement`: set to `1` in `genx_settings.yml` to activate the inertia constraint.
- `WriteInertia`: set in the output settings to write hourly inertia values to the outputs folder.

## New Input Data

1. **Resource tables** – every resource file must include a column `MW_s_per_MW` specifying the amount of inertia (in MW‑s) contributed per MW of online capacity.
2. **inertia_req.csv** – inside each period's `policies` folder (`inputs/inputs_pX/policies`). This file contains one column `MW_s` listing the required system inertia for each modeled hour. When using Time Domain Reduction, the reduction routine writes a shortened version of this file to `TDR_results/inertia_req.csv`.

## Outputs

When `WriteInertia` is enabled the model writes `inertia.csv` in the standard output directory. The file records the hourly inertia provided by each resource, scaled to match the full time series if `OutputFullTimeSeries` is used.

These additions are the only differences from the original GenX repository.
