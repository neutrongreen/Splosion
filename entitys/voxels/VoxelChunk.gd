extends StaticBody2D

export var chunk_pos= Vector2(0 ,0)
var map = NAN
var polygons = []
var bitwise = [1, 2, 4, 8]
var colours = PoolColorArray([Color(255,255,255)])
var test_colours = NAN
export (bool) var testing = false;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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
		tempvector += mappos
		tempvector *= map.TILE_SIZE
		#scale shape to needed size
		#if it is get scalar and mutiplay 
		#set point to shape
		shape.set(i, tempvector)
	return shape

func generate_voxel(pos):
	var voxid = 0
	var mappos = pos
	#get location value
	if map.map[mappos.x][mappos.y] > map.SURFACE_LEVEL:
		voxid |= bitwise[0]
	if map.map[mappos.x+1][mappos.y] > map.SURFACE_LEVEL:
		voxid |= bitwise[1]
	if map.map[mappos.x][mappos.y+1] > map.SURFACE_LEVEL:
		voxid |= bitwise[2]
	if map.map[mappos.x+1][mappos.y+1] > map.SURFACE_LEVEL:
		voxid |= bitwise[3]
	for i in map.VOXEL_TABLE:
		if i.points == voxid:
			return get_shape(i, Vector2(mappos.x,mappos.y))

func update_voxels():
	polygons = []
	for x in range(map.CHUNK_SIZE):
		polygons.append([])
		for y in range(map.CHUNK_SIZE):
			var dis = Vector2(chunk_pos.x*map.CHUNK_SIZE + x, chunk_pos.y*map.CHUNK_SIZE + y)
			#generate polygon for chunk location
			polygons[x].append(generate_voxel(dis))
	update()

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_parent()
	#https://godotengine.org/qa/2539/how-would-i-go-about-picking-a-random-number
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_value = random_generator.randf_range(0.00,60.00)
	test_colours = PoolColorArray([Color.from_hsv(random_value, 0.5, 1)])
	create_shape_owner(self)
	update_voxels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#called when master render function is called and redraws on the screen the chunk
#and redraws the collsion meshes 

func _draw():

	shape_owner_clear_shapes(0)
	for x in range(map.CHUNK_SIZE):
		for y in range(map.CHUNK_SIZE):
			if(polygons[x][y]):
				var geo_invalid = Geometry.triangulate_polygon(polygons[x][y]).empty()
				if(!geo_invalid):
					if testing:
						draw_polygon(polygons[x][y], test_colours)
					else:
						draw_polygon(polygons[x][y], colours)
					
					var collision = ConvexPolygonShape2D.new()
					collision.set_point_cloud(polygons[x][y])
					shape_owner_add_shape(0, collision)
