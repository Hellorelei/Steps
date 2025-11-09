extends Node2D
class_name CustomCircle

@export var radius: float = 16.0
@export var color: Color = Color(128, 32, 0, 0.3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_circle(Vector2(0, 0), radius, color)
