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
export (float) var SURFACE_LEVEL = 0.4
# Called when the node enters the scene tree for the first time.
var map = []
var polygons = []
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

var colours = PoolColorArray([Color(255,255,255)])
#http://jamie-wong.com/2014/08/19/metaballs-and-marching-squares/
func interpolateVertsY(var v1, var v2, var vect1, var vect2):
	vect1.y = vect1.y + ((SURFACE_LEVEL-v1)/(v2-v1))*(vect2.y - vect1.y)
	vect1.y = clamp(vect1.y, 0, 1)
	return vect1.y
func interpolateVertsX(var v1, var v2, var vect1, var vect2):
	vect1.x = vect1.x + ((SURFACE_LEVEL-v1)/(v2-v1))*(vect2.x - vect1.x)
	vect1.x = clamp(vect1.x, 0, 1)
	return vect1.x
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
#flip axis commands
func flip_x_axis(var vector):
	if vector.x == 1:
		vector.x = 0 
	elif vector.x == 0:
		vector.x = 1
	return vector

func flip_y_axis(var vector):
	if vector.y == 1:
		vector.y = 0 
	elif vector.y == 0:
		vector.y = 1
	return vector

func get_shape(var VOXEL_DATA, var mappos):
	#set shape to voxel data shape
	var shape = SHAPE_LIST.SHAPES[VOXEL_DATA.SHAPE_ID]
	#for i in range of shape size
	for i in range(shape.size()):
		var tempvector = shape[i]
		#flip x axis
		if VOXEL_DATA.FLIP_X:
			tempvector = flip_x_axis(tempvector)
		
		#flip y axis
		if VOXEL_DATA.FLIP_Y:
			tempvector = flip_y_axis(tempvector)
		
		#apply interpolation if vertex is = edge
		for edge in VOXEL_DATA.INTERPOLATED_EDGES:
			if edge.x == i:
				var b = edges[edge.y][1]
				var d = edges[edge.y][0]
				if edgesaxis[edge.y] == 0:
					tempvector.x = interpolateVertsX(map[d.x + mappos.x][d.y + mappos.y], 
					map[b.x + mappos.x][b.y + mappos.y], d, b)
				else:
					tempvector.y = interpolateVertsY(map[d.x + mappos.x][d.y + mappos.y], 
					map[b.x + mappos.x][b.y + mappos.y], d, b)
				break
		tempvector += mappos
		tempvector *= TILE_SIZE
		#scale shape to needed size
		#if it is get scalar and mutiplay 
		#set point to shape
		shape.set(i, tempvector)
	return shape

func generate_map():
	map = []
	polygons = []
	for x in range(MAP_SIZE.x):
		map.append([])
		for y in range(MAP_SIZE.y):
			map[x].append(noise.get_noise_2d(x, y) + 1)
	for x in range(MAP_SIZE.x - 1):
		polygons.append([])
		for y in range(MAP_SIZE.y - 1):
			var polygon = null
			var voxid = 0
			#get location value
			if map[x][y] > SURFACE_LEVEL:
				voxid |= bitwise[0]
			if map[x+1][y] > SURFACE_LEVEL:
				voxid |= bitwise[1]
			if map[x][y+1] > SURFACE_LEVEL:
				voxid |= bitwise[2]
			if map[x+1][y+1] > SURFACE_LEVEL:
				voxid |= bitwise[3]
			
			for i in VOXEL_TABLE:
				if i.points == voxid:
					polygon = get_shape(i, Vector2(x,y))
			
			polygons[x].append(polygon)
			
	pass # Replace with function body.

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	generate_map()

func _draw():
	for x in range(MAP_SIZE.x - 1):
		for y in range(MAP_SIZE.y - 1):
			
			if(polygons[x][y]):
				var geo_invalid = Geometry.triangulate_polygon(polygons[x][y]).empty()
				if(!geo_invalid):
					draw_polygon(polygons[x][y], colours)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		SURFACE_LEVEL += 0.1*delta
		generate_map()
		update()
	elif Input.is_action_pressed("ui_down"):
		SURFACE_LEVEL -= 0.1*delta
		generate_map()
		update()
