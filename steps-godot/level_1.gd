extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_b_button_1_pressed():
	get_tree().change_scene_to_file("res://ui_level.tscn")


	
