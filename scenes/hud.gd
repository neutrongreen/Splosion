extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bomb_count = 0
var time = 0
var power = 0
var depth = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	$PanelContainer/HBoxContainer/HBoxContainer2/bombs.text = ": %02d" % bomb_count
	$PanelContainer/HBoxContainer/timelabel.text = "TIME: %02d" % time
	$PanelContainer/HBoxContainer/level.text = "LEVEL: %02d" % Globals.level
	$PanelContainer/HBoxContainer/HBoxContainer2/ProgressBar.value = power
	$PanelContainer/HBoxContainer/HBoxContainer2/ProgressBar.modulate = lerp(Color("ffffff"), Color("ff0000"), power/1.5)
	$PanelContainer/HBoxContainer/HBoxContainer3/ProgressBar.value = depth
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
