# GEMINI.md

## Directory Overview

This directory contains a Computational Fluid Dynamics (CFD) project that simulates and analyzes the airflow in a bathroom under different ventilation conditions. The primary goal is to determine the most effective setup (combinations of door and window being open or closed) for exhausting air from the room.

The project leverages a suite of open-source tools:
*   **OpenFOAM:** For the core CFD simulations.
*   **FreeCAD with the CfdOF workbench:** For creating the 3D model of the bathroom and setting up the simulation cases.
*   **ParaView:** For post-processing and visualizing the simulation results.

The directory is organized into specific simulation cases and supporting files.

## Key Files and Directories

*   `README.md`: The main documentation for the project, providing a detailed walkthrough of the setup, execution, and results.
*   `models/`: This directory contains the 3D models of the bathroom used for the simulations.
    *   `bathroom.FCStd`: The main FreeCAD model of the bathroom.
    *   `bathroom-half.FCStd`: A halved model of the bathroom used for more efficient simulation, taking advantage of symmetry.
    *   `.step` and `.stl` files: Exported model files for compatibility with other software.
*   `all_open/`, `door_open/`, `window_open/`: These directories represent the three primary simulation cases. Each contains the necessary OpenFOAM files (`0/`, `constant/`, `system/` subdirectories) that define the specific conditions for that scenario.
*   `*.pvsm` files: ParaView state files. These files save the visualization settings (camera angles, color maps, etc.) so that the results can be consistently and easily viewed.
*   `*.png`: Image files showing the results of the simulations.

## Usage

This project is intended for users interested in CFD and fluid dynamics, specifically using OpenFOAM. To work with this project, you would typically follow these steps:

1.  **Prerequisites:** Ensure you have installed FreeCAD (with the CfdOF addon), OpenFOAM, and ParaView. The `README.md` file has detailed installation instructions.
2.  **Running a Simulation:**
    *   Open the desired FreeCAD file from one of the case directories (e.g., `all_open/all_open.FCStd`).
    *   Use the CfdOF workbench in FreeCAD to configure and run the simulation. The `README.md` provides a step-by-step guide.
3.  **Visualizing Results:**
    *   After a simulation is complete, the results can be loaded into ParaView.
    *   The provided `.pvsm` files can be used to quickly apply the same visualization settings used by the project author.

This is not a code project with a build process, but rather a scientific simulation project. The "building" is the process of running the CFD simulation, and "running" involves analyzing the results.
