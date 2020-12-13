extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Label.text = "Level: %s" % Globals.level
	$VBoxContainer/Label2.text = "Score: %s" % Globals.score
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button3_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Button2_pressed():
	Globals.level = 0
	Globals.score = 0
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
	pass # Replace with function body.


func _on_Button_pressed():
	Globals.score = 0
	Globals.level += 1
	get_tree().change_scene("res://scenes/main.tscn")
	pass # Replace with function body.
