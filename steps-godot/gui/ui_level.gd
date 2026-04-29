extends CanvasLayer


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")


func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_level_2_button_pressed():
	get_tree().change_scene_to_file("res://levels/level_2.tscn")


func _on_level_3_button_pressed():
	get_tree().change_scene_to_file("res://levels/level_3.tscn")


func _on_level_4_button_pressed():
	get_tree().change_scene_to_file("res://levels/level_4.tscn")
