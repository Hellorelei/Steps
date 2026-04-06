extends Node2D
class_name TurretGunRipple

@export var effect_ripple: PackedScene = load("res://turrets/effects/effect_ripple.tscn")
var parent_target_module: TurretTargetModule

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is not TurretTargetModule:
		print("Erreur: Le parent d'un TurretGunRipple doit être un TurretTargetModule.")
	else:
		parent_target_module = get_parent()
		parent_target_module.shoot_at.connect(_shoot_at)

func _shoot_at(target: Mob) -> void:
	print("pew!")
	var ripple = effect_ripple.instantiate()
	#print("ripple out!")
	ripple.max_radius = 64
	ripple.expand_speed = 32
	ripple.inverted = true
	parent_target_module.add_child(ripple)
