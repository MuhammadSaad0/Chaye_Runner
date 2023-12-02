extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/startScene.tscn")


func _on_check_box_toggled(button_pressed):
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_check_button_toggled(button_pressed):

	if (get_node("TextureRect/VBoxContainer/CheckButton").button_pressed):
		AudioServer.set_bus_volume_db(0, 0)
		get_node("TextureRect/VBoxContainer/CheckButton2").disabled = false
	else:
		AudioServer.set_bus_volume_db(0, -100)
		get_node("TextureRect/VBoxContainer/CheckButton2").disabled = true


func _on_check_box_ready():
	if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		get_node("TextureRect/VBoxContainer/CheckBox").set_pressed_no_signal(true)
	else:
		get_node("TextureRect/VBoxContainer/CheckBox").set_pressed_no_signal(false)
		

func _on_check_button_ready():
	if(AudioServer.get_bus_volume_db(0) >= 0):
		get_node("TextureRect/VBoxContainer/CheckButton").set_pressed_no_signal(true)
	else:
		get_node("TextureRect/VBoxContainer/CheckButton").set_pressed_no_signal(false)


func _on_check_button_2_toggled(button_pressed):
	if (get_node("TextureRect/VBoxContainer/CheckButton2").button_pressed):
		AudioServer.set_bus_volume_db(0, 50)
	else:
		AudioServer.set_bus_volume_db(0, 0)


func _on_check_button_2_ready():
	if(get_node("TextureRect/VBoxContainer/CheckButton").button_pressed):
		get_node("TextureRect/VBoxContainer/CheckButton2").disabled = false
		if(AudioServer.get_bus_volume_db(0) == 50):
			get_node("TextureRect/VBoxContainer/CheckButton2").set_pressed_no_signal(true)
		else:
			get_node("TextureRect/VBoxContainer/CheckButton2").set_pressed_no_signal(false)
	else:
		get_node("TextureRect/VBoxContainer/CheckButton2").disabled = true
		
	
