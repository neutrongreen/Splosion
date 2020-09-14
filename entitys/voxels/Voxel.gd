extends StaticBody2D

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
#http://jamie-wong.com/2014/08/19/metaballs-and-marching-squares/
func interpolateVertsY(var v1, var v2, var vect1, var vect2):
	vect1.y = vect1.y + ((map.SURFACE_LEVEL-v1)/(v2-v1))*(vect2.y - vect1.y)
	vect1.y = clamp(vect1.y, 0, 1)
	return vect1.y
func interpolateVertsX(var v1, var v2, var vect1, var vect2):
	vect1.x = vect1.x + ((map.SURFACE_LEVEL-v1)/(v2-v1))*(vect2.x - vect1.x)
	vect1.x = clamp(vect1.x, 0, 1)
	return vect1.x
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
export (Resource) var VOXEL_DATA
onready var map = get_parent()

var mappos = Vector2(0, 0)
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

func _ready():
	#set shape to voxel data shape
	var shape = map.SHAPE_LIST.SHAPES[VOXEL_DATA.SHAPE_ID]
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
					tempvector.x = interpolateVertsX(map.map[d.x + mappos.x][d.y + mappos.y], 
					map.map[b.x + mappos.x][b.y + mappos.y], d, b)
				else:
					tempvector.y = interpolateVertsY(map.map[d.x + mappos.x][d.y + mappos.y], 
					map.map[b.x + mappos.x][b.y + mappos.y], d, b)
				break
		tempvector *= map.TILE_SIZE
		#scale shape to needed size
		#if it is get scalar and mutiplay 
		#set point to shape
		shape.set(i, tempvector)
	
	#set meshes to shape
	$Polygon2D.polygon = shape
	$CollisionPolygon2D.polygon = shape
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
