extends Node2D

#export grid size 
export (Vector2) var GRID_SIZE = Vector2(16, 16)
var TILE_GRID_SIZE = Vector2(GRID_SIZE.x - 1, GRID_SIZE.y - 1)
var TILE_SIZE = 16
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#voxel grid of intergers will be size of map.
var grid = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#initalise grid array
	for x in range(GRID_SIZE.x):
		grid.append([])
		for y in range(GRID_SIZE.y):
			grid.append(0)
	#intialse tiel grid array
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
