# Splosion
## About
Splosion is a project to create a simple 2d scalar field mesh render within the godot game engine.
i wanted to create a 2d scalar mesh render within the godot game engine both because i use the engine fequinlty for my own personal projects.
and that there was a lack of publicly avalabile addons and software for the generation of procendaly generated 2d meshes based upon a scalar field within godot.
making this projet also allowed 

## Description
This repository contians the source code for a demo of the Splosion render in the form of a small rpodagly generated game within the godot game engine.
the render uses the godot game engine as a framework for rending the meshes and interacting with phyics and is wrtien in the gdscript programing langauge.

## How Does the Render Work
the render works by itterating though a sclar feild represetned by a matrix and using the [marching squares algorthim] uitlsing linear interpolation to genrate
meshes for each set of points. these meshes are then passed though to godots inbuitl draw comamnds, as wella s added to the scene as a colsion mesh.
to opsimse the rneder the matrix is broken down intol smaller Chunks that can re render ther nodes indpendaly of other chunks, meaing that chunks that are
not changed when a change is made to the scalar feild are not updated, preserving system resources.

## Potenrial inproments
* Add extra shapes and shape contions to impprove accresy of the marching squares algorthim
* improve updating nto chunks do nto have to be compleaty refreshed every time an update is made to them

## Demo
The demo contained within this project is a simple progenaly genrated game. where the gal is to make it to the bottom of each level as fast as possilbe using the
least number of bombs. bombs are used to destory terrain. the demo showcases the dynamic terrain generation and destruction capabiltiys of the render
the controlls for the game are

* Arrow keys for movement and jumping
* mouse for aiming
* left click to throw bombs

the game has been compiled for both windows and liniux and can be downloaded in the relaceses folder or from the bin folder

## Editing
to view the source project of the game download the free [Godot Game Engine](https://godotengine.org/) and import project.godot into the engine as a project
allowing you to view and edit the scenes nativy

## Credits
this project makes use of public doman art as credited below
* https://opengameart.org/content/classic-hero By GrafxKid
* https://opengameart.org/content/seamless-cave-in-parts	 By PWL
* https://opengameart.org/content/bomb-sprite By Znevs
* https://opengameart.org/content/bombs By Chrisblue
* https://kenney.nl/assets/impact-sounds By Kenny	

all collected on the 15/12/2020
