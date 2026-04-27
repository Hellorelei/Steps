extends Node2D

class_name TurretGunBubble

@export var effect_bubble: PackedScene = load("res://turrets/effects/effect_bubble.tscn")

var parent_target_module: TurretTargetModule


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if get_parent() is not TurretTargetModule:
		print("Erreur: Le parent d'un TurretGunRipple doit être un TurretTargetModule.")
	
	else:
		parent_target_module = get_parent()
		parent_target_module.shoot_at.connect(_shoot_at)


## Informe le target module parent qu'une cible a été touchée.
func _forward_target_hit(target):
	print("forwarding target: " + str(target))
	parent_target_module.hit_target(target)


func _shoot_at(target: Mob) -> void:
	var dir: Vector2
	var STRENGTH_MULTIPLIER = 2
	var strength = 4
	if target is not Mob:
		dir = global_position.direction_to(Vector2(10,10)).normalized()
	else:
		dir = global_position.direction_to(target.global_position + target.constant_force).normalized()
	#print(target)
	#print("blub!")
	var bubble:PhysicsBody2D = effect_bubble.instantiate()
	#print("ripple out!")
	# Application de la force au centre du mob, multipliée par FORCE_MULTIPLIER
	#ripple.expand_speed = 32
	#ripple.inverted = true
	bubble.apply_central_force(dir * strength * STRENGTH_MULTIPLIER)
	#bubble.position = Vector2(200, 200)
	add_child(bubble)
	#bubble.move_and_collide((dir * strength * STRENGTH_MULTIPLIER))
