extends Control

var sensitivity = 1;

func _on_Resume_pressed():
	get_parent().get_parent().resume()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Sensitivity_value_changed(value):
	get_parent().get_parent().sensitivity = value


func _on_VolumeSlider_value_changed(value):
	var music = get_parent().get_parent().find_node("Music");
	if not music:
		print("Coult not find music node")
		return
	music.volume_db = value;

func _on_Fullscreen_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)
