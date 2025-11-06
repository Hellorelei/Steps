extends RigidBody2D
class_name Mob

## Type de mob.
@export_enum("Cannette", "Amidons", "Micropolluants", "Lipides") var type: String = "Cannette"
@export_range(0, 64, 1.0) var health_points

var original_gravity_scale: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_sleep = false # Fait que la simulation physique reste active même si le mob ne bouge plus.
	original_gravity_scale = gravity_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Applique x dégâts au mob.
func hit(damage: int) -> void:
	pass

## Réinitialise la gravity_scale du mob.
func reset_gravity_scale() -> void:
	gravity_scale = original_gravity_scale
