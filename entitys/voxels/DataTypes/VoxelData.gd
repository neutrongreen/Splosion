extends Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name VoxelData

export (int) var SHAPE_ID
export (int, FLAGS, "TL", "TR", "BL", "BR") var points
export (Array, Vector3) var INTERPOLATED_EDGES
export (bool) var FLIP_X
export (bool) var FLIP_Y
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
