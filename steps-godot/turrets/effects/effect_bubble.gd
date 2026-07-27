extends Node2D
## Créé une bulle avec durée de vie prédéterminée.

## Durée de vie de la bulle, en secondes.
const LIFESPAN := 3.0

var parent: TurretGunBubble

var radius: float
var bubble_placeholder: CustomCircle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is TurretGunBubble:
		parent = get_parent()
	if not $Sprite2D:
		bubble_placeholder = CustomCircle.new()
		bubble_placeholder.radius = get_child(0).get_shape().radius
		bubble_placeholder.color = Color(0.778, 0.852, 1.0, 1.0)
		add_child(bubble_placeholder)
	_self_doom()


## Fait disparaître la bulle.
func disappear() -> void:
	queue_free()


## Détruit automatiquement la bulle après un temps donné.
func _self_doom() -> void:
	await get_tree().create_timer(LIFESPAN).timeout
	disappear()


## Endommage les mobs.
func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		parent._forward_target_hit(body)
		disappear()
