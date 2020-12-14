extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var radius = 10
export (Array, AudioStreamOGGVorbis) var collsion_sounds
var voxelmap = 0
var final = false
var power = 1
var max_radius = 10
var min_radius = 4
var min_time = 0.5
var max_time = 5

var particle_min_lifespan = 0.1
var particle_max_lifespan = 0.3

var lastbody = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Timer.wait_time = lerp(min_time, max_time, power)
	$Timer.start()
	$Particles2D.lifetime = lerp(particle_min_lifespan, particle_max_lifespan, power)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$Particles2D.emitting = true
	$Sprite.visible = false
	final = true
	mode = RigidBody2D.MODE_STATIC
	var radius = int(lerp(min_radius, max_radius, power))
	voxelmap.circle_brush(Vector2(position.x/voxelmap.TILE_SIZE, position.y/voxelmap.TILE_SIZE), radius, 0)
func _physics_process(delta):
	if position.x < 0 or position.x > voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x:
		queue_free()
	if position.y < 0 or position.y > voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y:
		queue_free()
	if final and $Particles2D.emitting == false:
		queue_free()



func _on_ball_body_entered(body):
	$AudioStreamPlayer2D.stream = collsion_sounds[randi() % collsion_sounds.size()]
	$AudioStreamPlayer2D.play()

