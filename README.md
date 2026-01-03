# Room Exhaust CFD Simulation

This project contains a Computational Fluid Dynamics (CFD) simulation of room exhaust scenarios. It uses [OpenFOAM](https://www.openfoam.com/), an open-source CFD software, to simulate the airflow in a room with different ventilation configurations. All tools used in this simulation are free and open-source. This is my first time doing anything CFD-related, so there may be areas for improvement.


## Getting Started

### Prerequisites

*   [OpenFOAM](https://www.openfoam.com/): Required to run the simulations
*   [ParaView](https://www.paraview.org/): Used for post-processing and visualization of the results
*   [FreeCAD](https://www.freecadweb.org/) with the [CfdOF Addon](https://github.com/jaheyns/CfdOF)

## Simulation Scenarios

The project is structured into three main simulation cases:
- `all_open`: A case with both the door and window open.
- `door_open`: A case with only the door open.
- `window_open`: A case with only the window open.

The simulations are set up to be run in parallel, and the results are stored in the respective case directories.

### Model Structure

![FreeCAD Tree](./misc/fc-tree.png)

- **Pad002** is the 3d model of room. Actually, it's a model of the room cut in half.
- **fan** is a uniform velocity `outlet`. The velocity has been set to $1.14 m/s$, which roughly matches the velocity of a typical exhaust fan
- **window** and **fan** are two special (self-explanatory) faces of the room. They are configured as an `open` constraint at atmospheric pressure $101 kPa$ when open. While closed, they are defined as a `wall` constraint (with no-slip condition)
- **wall** is all the remaining faces of the model. They are all defined as a `wall` constraint (no-slip)
- **constraint** is the face along the plane which cuts the room into 2 halves. This has been defined as a `symmetry` constraint to allow faster convergence and facilitate analysis of the CFD results
- **Pad002_Mesh** is the mesh generated using `cfMesh` with a base element size of 50 mm.
- **PhysicsModel**, **Air** and **InitialiseFields** contain the physics rules, fluid properties and the initial state respectively

### Usage

The simulation can be run as follows:

1. Load the `FCStd` file from one of the three simulation folders in FreeCAD.
2. Double-click on the **CfdSolver** to open the Analysis control task pane
3. Change the `Parallel Cores` property in Data pane to the number of cores on your system
4. Click on `Write` in the Task pane to write the case setup
5. Click on `Run` to start running the simulation. This should open the residuals pane, which will plot the CFD residuals vs iteration on a logarithmic scale
6. Once the simulation is complete, click on `ParaView` in the tasks pane to load the results in ParaView
7. (Optional) `File > Load State...` and select the corresponding `.pvsm` file to visualize the results in the exact fashion that I loaded them

## Project Background

I started this project because I wanted to figure out the quickest and most efficient way of freshening up the air in my bathroom. More specifically, I wanted to find out how much of a difference it makes when I open the door, versus when it's closed. Is there any risk of the air flowing out of the door instead of the exhaust? Do I need to keep the window open, or does it only disrupt the airflow? I wanted to find out the answers to these questions

My bathroom itself looks something like below:

![Bathroom Image](./misc/bathroom-full.png)

It has a single door on the south wall. It has an exhaust fan right above a window on the north wall.  
The room is completely symmetric along the YZ-plane, which allowed me to use the following model instead for simulation:

![Sliced bathroom image](./misc/bathroom-half.png)

Both of these models were made using FreeCAD and the model files are provided in the `models/` directory.

This allows me to define the XZ-sectional plane as a `symmetry` constraint which drastically reduces the simulation runtime. This also offers the advantage of facilitating the study of airflow within the room once simulation results are obtained. In the full bathroom case, a manual slice at the center was required for the same analysis.

Next, I needed a CFD simulator. OpenFOAM is a highly capable, free and open-source CFD simulator, which fits perfectly with my requirements, budget, and philosophy. However, it does not align with the desire for simplicity, lacking an easy-to-use GUI and requiring significant time to learn for new users.

The CfdOF workbench for FreeCAD proved to be a savior here. It streamlines the entire process of installation, case setup, constraint definitions, choices of physics models, solvers, and initial conditions. I highly recommend this project for beginners like myself.

For Finite Volume Method meshing, I initially used `gmsh`, but it quickly became overwhelmed. So I switched to `cfMesh` which drastically improved mesh quality, simulation accuracy, and speed.

### System Specifications

```
OS: Windows 11
CPU: AMD Ryzen 7 4800H with 8 cores and 16 threads
GPU: NVIDIA GeForce RTX 3050 Laptop
RAM: 16GB
```

### Setup

1. Install FreeCAD from its official [website](https://www.freecadweb.org/).
2. Start FreeCAD and install the CfdOF Addon from `Tools > Addon Manager...`
3. Go to `Edit > Preferences... -> CfdOF` and install OpenFOAM, ParaView and cfMesh

> Note: if you are using Windows, installing OpenFOAM will install the blueCFD release. This includes a ParaView binary, which you can point to directly instead of installing it again.

4. Update the executable paths in the same window. It looks something like this in my case:

![install directory](./misc/executables.png)

### Running the Simulation

1. Create the model of the room using the Part Design workbench in FreeCAD.
2. Go to the CfdOF workbench and start a CFD analysis.
3. Define the inlets, outlets, walls, and symmetry constraints using the `Fluid Boundary` option.
    a. The **exhaust** face is selected and defined as an outlet with uniform velocity of $1.14 m/s$ in the Y-direction
    b. The **door** and **window** faces are defined as "open" with pressure $101 kPa$ or as a "wall" when closed
    c. The **symmetry** plane is defined as `Constraint > Symmetry`
    d. All remaining faces are selected and added as a `wall` with the default no-slip attribute
4. Define the physics model. In our case, we are performing a steady-state analysis, in a single-phase, isothermal flow, with RANS turbulence modelling using the k-Omega SST method. This sets the solver to `simpleFoam` which is ideal for an incompressible approximation of this type.
5. Use the `Add Fluid Properties` option and choose the "Air" preset.
6. Use the `Initialise` option and set:  
    a. initial pressure inside the room as $101 kPa$  
    b. velocity as "Potential flow". This lets the `potentialFoam` solver define a suitable velocity gradient.
7. Go to the `CFD Mesh` option and choose `cfMesh` as the mesher and define $50 mm$ as the base element size. Then write the mesh case, and run the mesher. Also run `Check Mesh` to ensure there are no errors
8. Finally, go to the `CfdSolver` option:  
    a. Change the `Parallel Cores` option in the `Data` panel to your number of cores (NOT number of parallel threads). Also change the `Max Iterations` number to 400 which is reasonable for these test cases  
    b. `Write` the simulation case. This will write out all the directories (`system`, `constant`, `0`) and files used by OpenFOAM in the temporary directory  
    c. (Optional) `Edit` the simulation case. You can manually modify the case files to change the algorithms and solvers in order to get better stability/accuracy in your simulation. In our case, no change was required for convergence.  
    d. `Run` the simulation case. This will automatically pop up the `Residuals` window which will plot how the solutions are converging over the iterations. It will ideally stop when steady state is reached, but more commonly it will continue solving until it reaches the Max Iterations limit. If you see that the residuals do not change significantly after a certain number, it might be a good idea to reduce your `Max Iterations` attribute to that to save runtime. 


> The project follows the standard OpenFOAM case structure. Each case directory contains the following subdirectories:
> 
> - `0`: Contains the initial and boundary conditions for the flow variables (e.g., `U` for velocity, `p` for pressure).
> - `constant`: Contains the mesh (`polyMesh`) and physical properties of the fluid (`transportProperties`).
> - `system`: Contains the settings for the simulation, such as solver settings (`controlDict`, `fvSolution`), numerical schemes (`fvSchemes`), and parallel processing settings (`decomposeParDict`).
>
> These are all stored in the temporary directory by default and can be easily copied over to a more permanent directory (e.g., `all_open`) with the help of the `Edit` button
    

### Visualizing the Results

1. Click on the `ParaView` button in the `CfdSolver` task window to load the results
2. Change mode to 2D, and use the view direction buttons to select your view
3. Change the data to Velocity `U` and mode to `Surface LIC`
4. Change the scale using the Custom range button. $[0, 0.005]$ is a good range for this simulation
5. Change the Surface LIC rendering to `Multiply` and `LIC and color` enhanced to enhance the visibility of the lines

You can now see the streamlines of the air flowing inside the room, along with the associated velocity.

![ParaView Interface](./misc/paraview-interface.png)

## Results and Analysis

Here are some visualizations of the different simulation cases.

| | |
| :---: | :---: |
| All Open | ![All Open](./misc/all_open.png) |
| Door Open | ![Door Open](./misc/door_open.png) |
| Window Open | ![Window Open](./misc/window_open.png) |

As expected, keeping the door open drastically improves the airflow, which is in line with my expectations. What is interesting to note is that half of the bathroom sees nearly zero outflow when the door is closed, which severely hinders airflow.

Opening or not opening the window doesn't have a huge impact on the flow. There is some recirculation with the outside air happening in a vortex close to the window, but it's not significant. What is significant is that closing the window increases the velocity of the air at the center of the room, somewhat increasing the airflow.

This makes "Door open, window closed" the best possible scenario for clearing up the bathroom air, with the "All open" case a close second.

## Resources

- [FreeCAD by Deltahedra](https://www.youtube.com/watch?v=E14m5hf6Pvo)
- [CfdOF by TechBernd](https://www.youtube.com/watch?v=OS4sbbBtZUw&list=PL9H9jQE7y0a5jhlyACRzsdfnx-42AYCCX&index=2)
- [ParaView by AirShaper](https://www.youtube.com/watch?v=kczZPc4M-ms)