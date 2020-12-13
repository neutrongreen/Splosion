extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scroll_speed = -50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	scroll_offset.x += scroll_speed*delta
