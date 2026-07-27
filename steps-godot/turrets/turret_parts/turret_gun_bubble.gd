class_name TurretGunBubble
extends Node2D
## Créé une bulle projetée en direction d'un ennemi.

@export var effect_bubble: PackedScene = load("res://turrets/effects/effect_bubble.tscn")
## Force de projection de la bulle.
@export var strength := 4.0

const STRENGTH_MULTIPLIER := 2.0
var parent_target_module: TurretTargetModule


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is not TurretTargetModule:
		printerr("Le parent d'un TurretGunBubble doit être un TurretTargetModule.")
	
	else:
		parent_target_module = get_parent()
		parent_target_module.shoot_at.connect(_shoot_at)


## Informe le target module parent qu'une cible a été touchée.
func _forward_target_hit(target):
	parent_target_module.hit_target(target)


## Tire une bulle en direction du mob cible.
func _shoot_at(target: Mob) -> void:
	var dir: Vector2  # Vecteur pointant vers la cible.
	if target is not Mob:
		dir = global_position.direction_to(Vector2(10.0, 10.0)).normalized()
	else:
		dir = global_position.direction_to(
				target.global_position + target.linear_velocity).normalized()

	var bubble:PhysicsBody2D = effect_bubble.instantiate()
	bubble.apply_central_force(dir * strength * STRENGTH_MULTIPLIER)
	add_child(bubble)
