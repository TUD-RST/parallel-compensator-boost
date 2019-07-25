# Parallel Compensator for a Boost Converter

This project contains the [Scilab](https://www.scilab.org/) source file for the simulation of a control loop with a boost converter. Contrary to many other approaches, the voltage output is directly used as a control variable. This results in a non-minimum phase system. The problems arising with this system property are circumvented using a parallel compensator. The intention of this project is to supplement the following conference paper:

Klaus Röbenack, Stafan Palis:  
*On the Control of Non-Minimum Phase Systems Using a Parallel Compensator*.  
[International Conference on System Theory, Control and Computing (ICSTCC)](http://icstcc2019.cs.upt.ro/),   
October 9-11, 2019, Sinaia, Romania

## Prerequisites

To carry out the simulation you need to install the follwoing open source software for numerical computation:

https://www.scilab.org/

## Simulation Results

The numerical simulation combined with the visualisation generates the following graphics showing the trajectories of the controlled system:

