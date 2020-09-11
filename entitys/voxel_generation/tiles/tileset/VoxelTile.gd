extends StaticBody2D

#base plygon structure for vector2d stuff

#array of edge descriptors coistng of two coords in tuples

var EDGES = [
#left edge = 0
[Vector2(0, 0), Vector2(0, 1)], 
#upper edge = 1
[Vector2(0, 0), Vector2(1, 0)], 
#right edge = 2
[Vector2(1, 0), Vector2(1, 1)],
#bottom edge = 3
[Vector2(0, 1), Vector2(1, 0)]]

#postion on grid 
var g_positon = Vector2(0, 0)

var map = get_parent()
#get parent as the parent will be a grid
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#export size of tile for reference
var TILE_SIZE = 16
#get list of interpolated edges and veteces
export (Array, Resource) var  INTERPOLATED_VERTICES = []


#export interpolated edge array 


# Called when the node enters the scene tree for the first time.
func _ready():
	#interpolate over distance
	var polygons = $Mesh.get_polygon()
	
	for i in INTERPOLATED_VERTICES:
		#get edge value 
		var edge = i.edge
		var p_a = map.grid[position.x + i.edge[0].x][position.y + i.edge[0].y]
		var p_b = map.grid[position.x + i.edge[0].x][position.y + i.edge[0].y]
		
		#get midpoint of interpolated values and use it as offset 
		var center = lerp(p_a, p_b, 0.5)
		#get actual vetex offset from first postion in rage of 0-1 
		var offset = center/(max(p_a, p_b) - min(p_a, p_b))
		#get actoual offest
		var vertexpos = lerp(i.edge[0], i.edge[1], offset)*TILE_SIZE
		#set vertex postion to offest
		polygons.set(i.vertex, vertexpos)
	#set collider mesh to the voxel mesh allowing for nice collsion
	$Collider.polygon = polygons


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
