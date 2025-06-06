# Inertia Requirement Extension

This branch adds an optional inertia constraint to GenX.

## New Inputs
* `policies/inertia_req.csv` — a file that includes a column `MW_s`
  with 8760 rows of hourly inertia requirement values in MW·s.
  Any additional columns are ignored.
* All resource input tables may include a column `MW_s_per_MW` giving
  the inertia contribution per MW of installed capacity.

Set `InertiaRequirement: 1` in `genx_settings.yml` to activate the
constraint.

## Outputs
If enabled, the results folder will contain `inertia.csv` with the
hourly system inertia achieved by the model.
