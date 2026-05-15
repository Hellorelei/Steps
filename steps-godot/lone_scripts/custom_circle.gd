extends Node2D
class_name CustomCircle

@export var radius: float = 16.0
@export var color: Color = Color(128, 32, 0, 0.3)


func _draw():
	draw_circle(Vector2(0, 0), radius, color)
