extends Node2D
#onready var listener = #reference to your listener here 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().paused = true
		$PauseOverlayPolygon2D.visible = true
		#modulate = Color(0.3, 0.3, 0.3, 1)
		$GamePausedLabel.visible = true
	else:
		get_tree().paused = false
		$PauseOverlayPolygon2D.visible = false
		#modulate = Color(1, 1, 1, 1)
		$GamePausedLabel.visible = false


func _on_back_button_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui_level.tscn")
