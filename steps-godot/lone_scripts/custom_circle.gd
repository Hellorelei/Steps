class_name CustomCircle
extends Node2D
## Permet de dessiner des cercles.

@export var radius := 16.0
@export var color := Color(128.0, 32.0, 0.0, 0.3)


func _draw():
	draw_circle(Vector2(0.0, 0.0), radius, color)
