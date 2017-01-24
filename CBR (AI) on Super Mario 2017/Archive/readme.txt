# CBR Project for a Mario Game

This is a project for the course in Advanced Machine Learning Techniques at Universitat Politècnica de Catalunya. It consists of a Case-Based Reasoning (CBR) system module that takes input from a simple replica of a classic Super Mario game. The purpose of the CBR is to play the game.

## Getting Started

In order to play the game manually, simply navigate to the /scripts directroy and run the file play.py using python3. The game is very simple. Avoid enemies by jumping (hold and release any key). In order to let the CBR play, run the file auto_play.py using python3.
The auto_play.py script also saves data in data.txt (watch out to overwrite it). This data can be plotted by running plotter.py

## Prerequisites

Aside from the standard libraries, the following packages were used:

pygame, for rendering the game
numpy, for doing mathematical operations

## Installing

The installation consists of unzipping the archive. The extra packages can be installed using a Python package manager such as pip.

## Overview of files

play.py, script to run the game manually
auto_play.py, script to run the game using the CBR
case.py, classes used for representing cases
cbr.py, the CBR engine.
gaussian_processes.py, an implementation of Gaussian Processes
mario.py, the game engine itself.
