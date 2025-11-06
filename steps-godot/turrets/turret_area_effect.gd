extends Node
class_name TurretAreaEffect
## Applique un effet donné aux mobs se trouvant dans la zone d'effet de la tourelle.
@export_group("Dampening")
@export var dampening: bool = false
## Applique un effet de gravité en direction de la tourelle aux mobs se trouvant dans la zone
## d'effet de la tourelle ET listés comme cibles potentielles.
@export_group("Artificial gravity")
@export var artificial_gravity: bool = false
@export_range(0.0, 6, 0.1) var frequency: float = 0.1
@export_range(0.0, 32, 0.1) var strength: float = 16
@export var target_cannettes: bool = false
@export var target_amidons: bool = false
@export var target_micropolluants: bool = false
@export var target_lipides: bool = false

var enabled_targets: Array
var parent_turret: Turret

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled_targets = _setup_targets()
	if get_parent() is Turret:
		parent_turret = get_parent()
		parent_turret.body_in.connect(_on_body_in)
		parent_turret.body_out.connect(_on_body_out)
	else:
		print("Erreur: La node parent doit être de type Turret.")

## Lorsqu'un ennemi rentre, on le rend immunisé à la gravité générale et on lui applique une fausse
## gravité. 
func _on_body_in(body: Mob) -> void:
	if artificial_gravity:
		body.gravity_scale_float(0)
		_apply_artificial_gravity(body)

## Lorsqu'un ennemi sort, on réinitialise sa gravity_scale pour lui rendre un comportement normal.
func _on_body_out(body: Mob) -> void:
	body.gravity_scale_reset()

## Applique une pseudo-gravité de force x centrée sur la tourelle aux ennemis passés comme argument.
## Se réapplique tous les y.
func _apply_artificial_gravity(body: Mob) -> void:
	var dir = body.global_position.direction_to(parent_turret.global_position).normalized()
	# Application de la force au centre de body, multipliée
	body.apply_central_force(dir * strength)
	# On attend .01 secondes avant de relancer…
	await get_tree().create_timer(frequency).timeout
	# …et on vérifie que le corps soit toujours capturé avant!
	if body in parent_turret.get_enemies_in_zone():
		_apply_artificial_gravity(body)

## Initialize une liste de cibles acceptées à partir des réglages de l'éditeur.
func _setup_targets() -> Array:
	var target_list: Array
	if target_cannettes:
		target_list.append("Cannette")
	if target_amidons:
		target_list.append("Amidons")
	if target_micropolluants:
		target_list.append("Micropolluants")
	if target_lipides:
		target_list.append("Lipides")
	return target_list
