extends Node2D

var bitwise = [1, 2, 4, 8]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#http://jamie-wong.com/2014/08/19/metaballs-and-marching-squares/

var noise = OpenSimplexNoise.new()

onready var VoxelChunk = load("res://entitys/voxels/VoxelChunk.tscn")
onready var Ball = load("res://entitys/physics/ball.tscn")
export (int) var CHUNK_SIZE = 32
export (Resource) var SHAPE_LIST
export (Array, Resource) var VOXEL_TABLE
export (int) var TILE_SIZE = 32
export (Vector2) var MAP_SIZE = Vector2(4, 4)
export (Vector2) var SPAWN_OFFSET = Vector2(4, 4)
export (float) var MAP_SCALE = 1
export (float) var SURFACE_LEVEL = 0.4
export (bool) var testing = false;
# Called when the node enters the scene tree for the first time.
var map = []
onready var chunks = []
var edges = [[Vector2(0, 0), Vector2(1, 0)], 
				[Vector2(1, 0), Vector2(1, 1)], 
				[Vector2(0, 1), Vector2(1, 1)], 
				[Vector2(0, 0), Vector2(0, 1)]]
var edgesaxis = [
	0,
	1,
	0,
	1
]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
#flip axis commands
#https://www.reddit.com/r/godot/comments/9qmjfj/remove_all_children/
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func generate_map(persist):
	if !persist:
		map = []
		for x in range((MAP_SIZE.x*CHUNK_SIZE) + 1):
			map.append([])
			for y in range((MAP_SIZE.y*CHUNK_SIZE) + 1):
				map[x].append(noise.get_noise_2d(x*MAP_SCALE, y*MAP_SCALE) + 1)
	if(!chunks):
		for x in range(MAP_SIZE.x):
			chunks.append([])
			for y in range(MAP_SIZE.y):
				chunks[x].append(VoxelChunk.instance())
				chunks[x][y].chunk_pos = Vector2(x, y)
				add_child(chunks[x][y])
	else:
		for x in range(MAP_SIZE.x):
			chunks.append([])
			for y in range(MAP_SIZE.y):
				chunks[x][y].update_voxels()
			
func get_updated_chunks(coords):
	var x_array = []
	var y_array = []
	var return_array = []
	coords.x /= CHUNK_SIZE
	coords.y /= CHUNK_SIZE
	x_array.append(floor(coords.x))
	y_array.append(floor(coords.y))
	if fmod(coords.x, 1) == 0:
		x_array.append(floor(coords.x) - 1)
	if fmod(coords.y, 1) == 0:
		y_array.append(floor(coords.y) - 1)
	for x in x_array:
		for y in y_array:
			if !(x < 0) and x < MAP_SIZE.x:
				if !(y < 0) and y < MAP_SIZE.y:
					return_array.append(Vector2(x, y))
	return return_array
	
#https://stackoverflow.com/questions/15856411/finding-all-the-points-within-a-circle-in-2d-space
func circle_brush(mappos, r, strength):
	var updated_chunks = []
	for x in range(mappos.x - r, mappos.x + r):
		var yspan = floor(r*sin(acos((mappos.x-x)/r)));
		for y in range(mappos.y - yspan, mappos.y + yspan):
			var i = Vector2(x, y)
			if !((i.y > CHUNK_SIZE*MAP_SIZE.y) or i.y < 0) and !((i.x > CHUNK_SIZE*MAP_SIZE.x) or i.x < 0):
				#update map location
				map[i.x][i.y] = strength
				#then get what chunks are updated and if not in the update list add them
				var tempchunks = get_updated_chunks(i)
				for c in tempchunks:
					var is_dup = false
					for f in updated_chunks:
						if c == f:
							is_dup = true
							break
					if !is_dup:
						updated_chunks.append(c)
	for i in updated_chunks:
		chunks[i.x][i.y].update_voxels()
		#recoulor if updetated
#		chunks[i.x][i.y].colours = PoolColorArray([Color(255,255,0)])
				#(x, y), (x, ySym), (xSym , y), (xSym, ySym) are in the circle
		

func _ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	generate_map(false)
	circle_brush(Vector2((CHUNK_SIZE*MAP_SIZE.x)/2 + SPAWN_OFFSET.x, SPAWN_OFFSET.y), 10, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _process(delta):
#	if Input.is_action_pressed("ui_up"):
#		SURFACE_LEVEL += 0.1*delta
#		generate_map(true)
#	elif Input.is_action_pressed("ui_down"):
#		SURFACE_LEVEL -= 0.1*delta
#		generate_map(true)
	
#	if Input.is_action_just_pressed("ui_select"):
#		var tempball = Ball.instance()
#		tempball.position = get_global_mouse_position()
#		add_child(tempball)
#
#	if Input.is_action_pressed("ui_accept"):
#		var pos = get_global_mouse_position()
#		pos.x = round(pos.x/TILE_SIZE)
#		pos.y = round(pos.y/TILE_SIZE)
#		if pos.x < CHUNK_SIZE*MAP_SIZE.x and pos.x > 0:
#			if pos.y < CHUNK_SIZE*MAP_SIZE.y and pos.y > 0:
#				circle_brush(pos, 1, 0.8*delta)
