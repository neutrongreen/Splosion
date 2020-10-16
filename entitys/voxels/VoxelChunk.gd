extends StaticBody2D

export var chunk_pos= Vector2(0 ,0)
var map = NAN
var polygons = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_parent()
	for x in range(map.CHUNK_SIZE -1):
		polygons.append(x)
		for y in range(map.CHUNK_SIZE -1):
			polygons.append(x)
		
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#called when master render function is called and redraws on the screen the chunk
#and redraws the collsion meshes 

func _draw():
	for x in range(chunk_pos.x + map.CHUNK_SIZE - 1):
		for y in range(chunk_pos.y + map.CHUNK_SIZE - 1):
			if(map.polygons[x][y]):
				var geo_invalid = Geometry.triangulate_polygon(polygons[x][y]).empty()
				if(!geo_invalid):
					draw_polygon(polygons[x][y], colours)
