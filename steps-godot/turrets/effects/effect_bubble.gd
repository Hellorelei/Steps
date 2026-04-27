extends Node2D
"""
Créé une bulle avec durée de vie prédéterminée.
"""

## Durée de vie de la bulle, en secondes.
const LIFESPAN: float = 3

var parent: TurretGunBubble

var radius: float
var bubble_placeholder: CustomCircle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	print(parent)
	bubble_placeholder = CustomCircle.new()
	bubble_placeholder.radius = get_child(0).get_shape().radius
	add_child(bubble_placeholder)
	_self_doom()
	

## Dessine le cercle de l'onde.
func _draw():
	pass


## Détruit automatiquement la bulle après un temps donné.
func _self_doom() -> void:
	await get_tree().create_timer(LIFESPAN).timeout
	disappear()

## Fait disparaître la bulle.
func disappear() -> void:
	queue_free()


## Endommage tout objet touché de masse >= 1.
func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	print("a")
	if body is RigidBody2D:
		print("got you!")
		parent._forward_target_hit(body)
		disappear()
