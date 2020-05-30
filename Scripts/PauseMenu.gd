extends Control

var sensitivity = 1;

export var initial_volume = -10

func _ready():
	_on_VolumeSlider_value_changed(initial_volume)

func _on_Resume_pressed():
	get_parent().get_parent().resume()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Sensitivity_value_changed(value):
	get_parent().get_parent().sensitivity = value

func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_Fullscreen_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)
