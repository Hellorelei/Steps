extends CanvasLayer


func _on_devmode_button_pressed(toggle_status: bool) -> void:
	Global.dev_mode = toggle_status


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")
