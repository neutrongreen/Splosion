extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var radius = 10
var voxelmap = 0
var final = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$Particles2D.emitting = true
	$Sprite.visible = false
	final = true
	mode = RigidBody2D.MODE_STATIC
	voxelmap.circle_brush(Vector2(position.x/voxelmap.TILE_SIZE, position.y/voxelmap.TILE_SIZE), 10, 0)
func _physics_process(delta):
	position.x = clamp(position.x, 0, voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x)
	position.y = clamp(position.y, 0, voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y)
	if final and $Particles2D.emitting == false:
		queue_free()

func _on_ball_body_entered(body):
	pass # Replace with function body.
