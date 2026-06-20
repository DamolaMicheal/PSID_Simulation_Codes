#PSID Simulation Codes

Balanced dq0 EMT (electromagnetic-transient) simulation and Small Signal Stability Analysis 
 for inverter-dominated power systems (IEEE 39-bus and a 3-bus test
case), built on the open-source **Sienna / PowerSimulationsDynamics.jl**
toolbox.

> **Note** This repository does **not** reimplement a simulation
> engine. It *uses* the PowerSimulationsDynamics.jl (PSID.jl) modeling and
> simulation toolbox developed by the NREL Sienna team to build and study
> specific IEEE 39-bus and 3-bus cases. Credit for the underlying Toolbox used to
> develop these test cases belongs to the PSID.JL developers (see
> **Citing** below).

## Built with PowerSimulationsDynamics.jl

- PowerSimulationsDynamics.jl documentation:
  https://sienna-platform.github.io/PowerSimulationsDynamics.jl/stable/

If you use this repository, please cite the PSID.jl paper:

```bibtex
@article{lara2023powersimulationsdynamics,
  title={PowerSimulationsDynamics.jl--An Open Source Modeling Package for Modern Power Systems with Inverter-Based Resources},
  author={Lara, Jose Daniel and Henriquez-Auba, Rodrigo and Bossart, Matthew and Callaway, Duncan S and Barrows, Clayton},
  journal={arXiv preprint arXiv:2308.02921},
  year={2023}
}
```

## Repository contents

- **`3bus_TestCase/`** — a 3-bus balance dq0 EMT case
- **`IEEE39Case_Simulations/`** — the IEEE 39-bus system partitioned into
  synchronous-generator (SG), grid-forming (GFM), and grid-following (GFL)
  units, with fault / line-trip and load-change disturbances

## Julia, VSCode, and PSID.jl setup

1. Install Julia: https://julialang.org/downloads/
2. Install VS Code: https://code.visualstudio.com/download
3. In VS Code, install the Julia extension:
   https://code.visualstudio.com/docs/languages/julia
4. Open the project folder in VS Code, then open **Terminal → New Terminal**.
5. Start Julia in the project folder:

   ```powershell
   julia --project=.
   ```

6. Install the required packages:

   ```julia
   import Pkg
   Pkg.add([
       "PowerSystems",
       "PowerSimulationsDynamics",
       "PowerFlows",
       "Sundials",
       "OrdinaryDiffEq",
       "Plots",
       "CSV",
       "DataFrames"
   ])
   Pkg.precompile()
   ```

7. Run a script — from the Julia REPL:

   ```julia
   include("whatever_you_name_your_script.jl")
   ```

   or from the terminal:

   ```powershell
   julia --project=. whatever_you_name_your_sctipt.jl
   ```

### Running the included cases

IEEE 39-bus:
```powershell
cd IEEE39Case_Simulations
julia --project=. ieee39_main_run.jl
```
Outputs are written to `IEEE39Case_Simulations/plots/`.

3-bus:
```powershell
cd 3bus_TestCase
julia --project=. 3bus_main_run.jl
```
Outputs are written to `3bus_TestCase/3bus_plots/`.

Disturbance type, bus partitions, and fault location are set via
the constants near the top of each `*_main_run.jl` file.

## Dynamic power-system simulation code  (IEEE 39-bus and 3-bus)

This Julia code builds and simulates Balance dq0 EMT power-system models using
`PowerSystems.jl`, `PowerSimulationsDynamics.jl`, `PowerFlows.jl`, and
`Sundials.jl`. It starts from a MATPOWER case, which is imported into a `PowerSystems.jl` `System` object and solved to obtain the steady-state AC power-flow operating point. 
The converged bus quantities are used to initialize the dynamic simulation. SG, GFM, and GFL dynamic models are then attached to their respective generation buses, 
transmission lines are converted into `DynamicBranch` components, and disturbances are applied through PSID.jl `Perturbation` objects such as 
`LoadChange`, `BranchTrip`. The time-domain simulation is then executed.
.

Each case is organised into three files:

- a **MATPOWER case file** (`case*_matpower.jl` ) containing the
  bus, generator, branch, and cost data;
- a **parameter file** (`*_parameters.jl`)
  storing solver settings, bus partitions, generator bases, damping gains, droop gains, 
  governor settings, inverter gains, PLL gains,  etc.  
- a **main run script** (`*_main_run.jl`) is the primary script to execute for each simulation case. The case file and parameter file scripts should be kept in the same folder

The code supports load steps and fault /line-trip. It uses Sundials IDA, an adaptive implicit DAE solver, for the
nonlinear time-domain (dq0 balanced EMT) transient-stability analysis.

It also supports small-signal stability analysis (SSA): SSA linearizes the
initialized operating point and checks eigenvalues to confirm local stability
before the disturbance.

## Acknowledgements & citing

This work is built on the **Sienna** modeling ecosystem and would not be possible
without it. Please cite **PowerSimulationsDynamics.jl** (Lara et al., 2023, above)
when using this repository. To cite this repository itself, use the “Cite this repository” button on GitHub, generated from CITATION.cff, or use its Zenodo DOI once a release has been archived.
