extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sound.play_bg('bg_forest_1', 0.6, true)


func _on_start_button_pressed() -> void:
	Sound.play('ui_button_ahead')
	get_tree().change_scene_to_file("res://gui/ui_level.tscn")


func _on_credits_button_pressed() -> void:
	Sound.play('ui_button_ahead')
	get_tree().change_scene_to_file("res://gui/credits.tscn")


func _on_options_button_pressed() -> void:
	Sound.play('ui_button_ahead')
	get_tree().change_scene_to_file("res://gui/ui_options.tscn")


func _on_quit_button_pressed() -> void:
	Sound.play('ui_button_back')
	get_tree().quit()
