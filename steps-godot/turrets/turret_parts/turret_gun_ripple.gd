extends Node2D
class_name TurretGunRipple

@export var effect_ripple: PackedScene = load("res://turrets/effects/effect_ripple.tscn")
var parent_target_module: TurretTargetModule


func _ready() -> void:
	if get_parent() is not TurretTargetModule:
		print("Erreur: Le parent d'un TurretGunRipple doit être un TurretTargetModule.")
	else:
		parent_target_module = get_parent()
		parent_target_module.shoot_at.connect(_shoot_at)


## Créé une onde centrée sur la tourelle. La fonction reçoit un target même s'il est pas utilisé,
## par interopérabilité avec les autres objets TurretGun.
func _shoot_at(target: Mob) -> void:
	var ripple = effect_ripple.instantiate()
	ripple.max_radius = 64
	ripple.expand_speed = 32
	ripple.inverted = true
	parent_target_module.add_child(ripple)
