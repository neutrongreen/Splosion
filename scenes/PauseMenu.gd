extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event.is_action_pressed("ui_pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

func _on_Button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Button2_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/TitleScreen.tscn")

func _on_Button3_pressed():
	get_tree().quit()
