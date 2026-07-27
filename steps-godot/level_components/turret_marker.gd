class_name TurretMarker
extends Marker2D
## Marque l'emplacement d'une tourelle pour permettre son apparition dans le niveau.

var turret_handler: PackedScene = preload("res://turrets/turret_parts/turret_handler.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turret_base = turret_handler.instantiate()
	add_child(turret_base)
