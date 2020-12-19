extends KinematicBody2D

#https://godotengine.org/qa/62447/how-to-tell-how-long-a-button-is-pressed
var bomb_count = 0
var time = 0
var duration = 0
var power = 0
var lasttime = 0

var state

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#export modfiable player constnats
export (float) var gravity = 800
export (float) var walk_speed = 10000
export (float) var jump_boost = 500
export (int) var bomb_speed = 500
export (Vector2) var SPAWN_OFFSET = Vector2(4, 4)
export (float) var max_dur = 1
#persenstant velocity of player
var velocity = Vector2(0, 0)

#nodes player needs to acces within a scene
export (NodePath) var voxelmapnode
export (NodePath) var hudnode

#varables loaded whent the node is intanced
onready var voxelmap = get_node(voxelmapnode)
onready var hud = get_node(hudnode)
onready var Ball = load("res://entitys/physics/ball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	#set global score to zero
	Globals.score = 0
	#define camera limits relative to voxel map
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x
	$Camera2D.limit_top = 0
	$Camera2D.limit_bottom = voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y
	#set to spawn postion and clear cricle around spawn
	position = Vector2((voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x)/2 + SPAWN_OFFSET.x, SPAWN_OFFSET.y)*voxelmap.TILE_SIZE
	voxelmap.circle_brush(Vector2((voxelmap.CHUNK_SIZE * voxelmap.MAP_SIZE.x) / 2 + SPAWN_OFFSET.x, SPAWN_OFFSET.y), 10, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	#set state to default to idle
	state = "idle"
	#increase time spent awake
	time += delta
	#move item
	#set x velocity to zero
	velocity.x = 0
	#if walk input is true walk in the direction pressed and set state to walk
	if(Input.is_action_pressed("ui_left")):
		state = "walk"
		velocity.x -= walk_speed*delta
	if(Input.is_action_pressed("ui_right")):
		state = "walk"
		velocity.x += walk_speed*delta
	#if jumping key is pressed and on floor jump
	if(Input.is_action_just_pressed("ui_space") and is_on_floor() == true):
		velocity.y -= jump_boost
		
	#make animated sprite face in direction of x motion
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
	
	#if ground is not close enough set state to jump
	if $RayCast2D.is_colliding() == false:
		state = "jump"
	
	#apply gravity
	velocity.y += gravity*delta
	
	#move player
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	#set animation to current state
	$AnimatedSprite.play(state)
	
	# if reached end of level caclulate score and change scene
	if position.y >  voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y:
		#reload scene
		if bomb_count == 0:
			bomb_count = 1
		Globals.score = time*bomb_count
		get_tree().change_scene("res://scenes/EndLevelScreen.tscn")
	
	#constrain postion to map size
	position.x = clamp(position.x, 0, voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.x)
	position.y = clamp(position.y, 0, voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y)
	
	#handle bomb input, increase bomb power over time pressed untill relaced
	if Input.is_action_pressed("ui_select"):
		duration += delta
		power = clamp(duration, 0, max_dur)/max_dur
	#spawn bombs
	if Input.is_action_just_released("ui_select"):
		bomb_count += 1
		var tempball = Ball.instance()
		tempball.position = position
		var angle = get_angle_to(get_global_mouse_position())
		var direction = Vector2(cos(angle), sin(angle))
		tempball.linear_velocity = direction*bomb_speed
		tempball.voxelmap = voxelmap
		tempball.power = power
		voxelmap.add_child(tempball)
		duration = 0
		power= 0
	#update hud icons
	hud.power = power
	hud.bomb_count = bomb_count
	hud.time = time
	hud.depth = position.y/(voxelmap.TILE_SIZE*voxelmap.CHUNK_SIZE*voxelmap.MAP_SIZE.y)
	
