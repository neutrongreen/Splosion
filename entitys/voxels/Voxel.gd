extends StaticBody2D


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
		
		#apply interpolation
		
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
