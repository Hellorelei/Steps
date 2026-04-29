extends CanvasLayer

func _on_back_button_c_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")
