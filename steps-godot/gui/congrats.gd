extends CanvasLayer


func _on_back_button_c_pressed() -> void:
	Sound.play('ui_button_back')
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")
