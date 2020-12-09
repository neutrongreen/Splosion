extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gravity = 800
var walk_speed = 10000
var jump_boost = 500
var velocity = Vector2(0, 0)
export (NodePath) var voxelmapnode
export (int) var bomb_speed = 500
onready var voxelmap = get_node(voxelmapnode)
onready var Ball = load("res://entitys/physics/ball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x
	$Camera2D.limit_top = 0
	$Camera2D.limit_bottom = voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y
	position = Vector2((voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x)/2 + voxelmap.SPAWN_OFFSET.x, voxelmap.SPAWN_OFFSET.y)*voxelmap.TILE_SIZE
	#constrain camera to map size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	#move item
	velocity.y += gravity*delta
	velocity.x = 0
	if(Input.is_action_pressed("ui_left")):
		velocity.x -= walk_speed*delta
	if(Input.is_action_pressed("ui_right")):
		velocity.x += walk_speed*delta
	if(Input.is_action_just_pressed("ui_space") and is_on_floor() == true):
		velocity.y -= jump_boost
	velocity = move_and_slide(velocity, Vector2(0, -1))
	#constrain postion to map size
	position.x = clamp(position.x, 0, voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x)
	position.y = clamp(position.y, 0, voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y)
	#spawn bombs
	if Input.is_action_just_pressed("ui_select"):
		var tempball = Ball.instance()
		tempball.position = position
		var angle = get_angle_to(get_global_mouse_position())
		var direction = Vector2(cos(angle), sin(angle))
		tempball.linear_velocity = direction*bomb_speed
		tempball.voxelmap = voxelmap
		voxelmap.add_child(tempball)
