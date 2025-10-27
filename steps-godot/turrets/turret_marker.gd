extends Marker2D
class_name TurretMarker

var turret_handler: PackedScene = preload("res://turrets/turret_handler.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turret_base = turret_handler.instantiate()
	#turret_base.global_position = self.global_position
	add_child(turret_base)
