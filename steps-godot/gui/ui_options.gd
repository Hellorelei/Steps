extends CanvasLayer


func _ready() -> void:
	$CheckButton.button_pressed = Global.dev_mode
	$CheckButton2.button_pressed = Global.sound_enabled

func _on_devmode_button_pressed(toggle_status: bool) -> void:
	Sound.play('ui_button_toggle')
	Global.dev_mode = toggle_status


func _on_sound_button_pressed(toggle_status: bool) -> void:
	Global.sound_enabled = toggle_status
	Sound.play('ui_button_toggle')


func _on_back_button_pressed():
	Sound.play('ui_button_back')
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")
