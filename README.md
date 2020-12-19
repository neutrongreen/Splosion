# Splosion
## About
Splosion is a project to create a simple 2d scalar field mesh render within the Godot game engine.
I wanted to create a 2d scalar mesh render within the Godot game engine because I use the engine frequently for my own personal projects and there was a lack of publicly available addons and software for the generation of 2d meshes from a scalar field within the Godot engine community.
making this project also allowed me to learn more about how the Godot engine functions internally and how to optimise large dataset interacting programs.

## Description
This repository contains the source code for a demo of the Splosion render in the form of a small procedurally generated game terrain within the Godot game engine.
the render uses the Godot game engine as a framework for rending the meshes and interacting with physics and is written in the GDScript programming language.

## How Does the Render Work
the render works by iterating though a scalar field represented by a matrix and using the [marching squares algorithm] utilising linear interpolation to generate
meshes for each set of points. these meshes are then passed through to Godot’s inbuilt draw commands, as well as added to the scene as a collision mesh.
to optimise the render the matrix is broken down into smaller Chunks that can re render there nodes independently of other chunks, meaning that chunks that are
not changed when a change is made to the scalar field are not updated, preserving system resources.

## Potential improvements
* Add extra shapes and shape selection conditions to improve accuracy of the marching squares algorithm
* improve updating not chunks do not have to be completely refreshed every time an update is made to them

## Demo
The demo contained within this project is a simple procedurally generated terrain based game. where the gal is to make it to the bottom of each level as fast as possible using the
least number of bombs. bombs are used to destroy terrain. the demo showcases the dynamic terrain generation and updating capability’s of the render
the controls for the game are

* Arrow keys for movement and jumping
* mouse for aiming
* left click to throw bombs

the game has been compiled for both Windows and Linux and can be downloaded in the releases folder on the GitHub page or from the bin folder

## Editing
to view the source project of the game download the free [Godot Game Engine](https://godotengine.org/) and import project.godot into the engine as a project
allowing you to view and edit the scenes natively

## Credits
this project makes use of Public Doman art as credited below
* https://opengameart.org/content/classic-hero By GrafxKid
* https://opengameart.org/content/seamless-cave-in-parts By PWL
* https://opengameart.org/content/bomb-sprite By Znevs
* https://opengameart.org/content/bombs By Chrisblue
* https://kenney.nl/assets/impact-sounds By Kenny	

all collected on the 15/12/2020
