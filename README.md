# 🔬 HYPERSONICS LAB


A real-time simulation environment developed in Godot Engine to validate concepts of advanced physics, aerospace engineering, and fluid thermodynamics.

The goal of this laboratory is to create a library of reusable physics components that enable rapid prototyping of complex systems (such as engines, aerodynamics, and vehicles) with mathematical precision.

## 🧪 Current Module: Hypersonic Propulsion (Scramjet/Ramjet)

<img width="1625" height="706" alt="ScramjetCFD1D" src="https://github.com/user-attachments/assets/78a2f09f-dd66-4526-ae6f-2c83981c3936" />

The first major experiment of the lab focuses on the simulation of thermodynamic cycles for jet engines without moving parts.

### The Challenge
To simulate the behavior of a Scramjet engine from scratch, calculating airflow properties step-by-step as it traverses the engine components.

### Core Physics Implementation
This module validates the interaction between three fundamental gas dynamics phenomena:

1.  **Fanno Flow (Friction):** Simulation of head loss and sonic choking in isolator ducts.
2.  **Rayleigh Flow (Combustion):** Heat addition in compressible flow and thermal shock analysis.
3.  **Isentropic Flow (Nozzle):** Gas expansion and thrust generation using variable geometry nozzles.

> **Technical Highlight:** The implemented solver is **hybrid**, utilizing **Newton-Raphson** methods for precision and **Bisection** for numerical stability, capable of dynamically handling the transition between subsonic and supersonic regimes.
> ---

## 🏗️ Laboratory Architecture

The project was designed with modularity in mind, allowing physics classes to be reused in future experiments:

* **`AtmoProperties`:** Global Singleton for standard atmosphere calculations and real gas properties.
* **`FluidSolvers`:** Libraries of numerical algorithms (Newton-Raphson, Derivatives) located in the "Calculators" folder, **decoupled** from game logic.
* **Modular Components:** `RayleighFlow` and `FannoFlow` are Nodes that can be attached to any object in the lab, not just engines.

## 🛠️ Tech Stack & Tools

* **Engine:** Godot 4.x (Typed GDScript)
* **Physics:** 1D Compressible Fluid Dynamics (CFD-lite)
* **Future Integration:** Ready for VR/XR (Meta Quest) 

## 🚀 Lab Roadmap

- [x] **Phase 1:** Thermodynamics Core (Scramjet)
- [ ] **Phase 2:** Trajectory and Control Integration
- [ ] **Phase 3:** Real-Time Data Visualization (In-Game Plotting)
- [ ] **Phase 4:** Virtual Reality Test Environment

---
*This repository is a constant "work in progress" for advanced studies in engineering and simulation.*
