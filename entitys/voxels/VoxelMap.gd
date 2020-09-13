extends Node2D

var bitwise = [1, 2, 4, 8]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var noise = OpenSimplexNoise.new()

onready var VoxelNode = load("res://entitys/voxels/Voxel.tscn")

export (Resource) var SHAPE_LIST
export (Array, Resource) var VOXEL_TABLE
export (int) var TILE_SIZE = 32
export (Vector2) var MAP_SIZE
export (int) var SURFACE_LEVEL = -0.05
# Called when the node enters the scene tree for the first time.
var map = []
func _ready():
	
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	for x in range(MAP_SIZE.x):
		map.append([])
		for y in range(MAP_SIZE.y):
			map[x].append(noise.get_noise_2d(x, y))
	for x in range(MAP_SIZE.x - 1):
		for y in range(MAP_SIZE.y - 1):
			var shape = 0
			#get location value
			if map[x][y] > SURFACE_LEVEL:
				shape |= bitwise[0]
			if map[x+1][y] > SURFACE_LEVEL:
				shape |= bitwise[1]
			if map[x][y+1] > SURFACE_LEVEL:
				shape |= bitwise[2]
			if map[x+1][y+1] > SURFACE_LEVEL:
				shape |= bitwise[3]
			for i in VOXEL_TABLE:
				if i.points == shape:
					var voxeltile = VoxelNode.instance()
					var voxpos = Vector2(x,y)
					voxeltile.position = voxpos*TILE_SIZE
					voxeltile.mappos = voxpos
					voxeltile.VOXEL_DATA = i
					add_child(voxeltile)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
