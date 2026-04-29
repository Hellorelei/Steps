extends Node2D

## Applique un effet d'amortissement et/ou une gravité artificielle dans la zone de la tourelle afin
## d'attirer/repousser les mobs donnés.
class_name TurretAreaEffect

@export_group("Dampening")
## Applique un effet d'amortissement aux mobs se trouvant dans la zone d'effet de la tourelle.
@export var dampening: bool = false

@export_group("Artificial gravity")
## Applique un effet de gravité en direction de la tourelle aux mobs se trouvant dans la zone
## d'effet de la tourelle ET listés comme cibles potentielles.
@export var artificial_gravity: bool = false
## Fréquence d'application de la gravité artificielle, en secondes.
@export_range(0.0, 6, 0.1) var frequency: float = 0.1
## Intensité de la force de gravité artificielle.
@export_range(0.0, 32, 0.1) var strength: float = 16
## Vise les cannettes?
@export var target_cannettes: bool = false
## Vise les amidons?
@export var target_amidons: bool = false
## Vise les micropolluants?
@export var target_micropolluants: bool = false
## Vise les lipides?
@export var target_lipides: bool = false

var enabled_targets: Array # Stocke la liste d'entités cibles pertinentes.
var parent_turret: Turret
## Nombre magique multipliant la force d'attraction de la zone.
const STRENGTH_MULTIPLIER = 4.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled_targets = _setup_targets()
	if get_parent() is Turret:
		parent_turret = get_parent()
	else:
		print("Erreur: la node parent de TurretAreaEffect doit être une tourelle.")


## Lorsqu'un ennemi rentre, on le rend immunisé à la gravité générale et on lui applique une fausse
## gravité. 
func _on_mob_in(mob: Mob) -> void:
	if artificial_gravity and mob.type in enabled_targets:
		mob.change_gravity_scale(0)
		_apply_artificial_gravity(mob)


## Lorsqu'un ennemi sort, on réinitialise sa gravity_scale pour lui rendre un comportement normal.
func _on_mob_out(mob: Mob) -> void:
	mob.reset_gravity_scale()


## Applique une pseudo-gravité centrée sur la tourelle aux ennemis passés comme argument.
## Se réapplique tous les frequency.
func _apply_artificial_gravity(mob: Mob) -> void:
	# Calcul du vecteur entre les positions mob → tourelle, normalisé.
	var dir: Vector2 = mob.global_position.direction_to(global_position).normalized()
	# Application de la force au centre du mob, multipliée par FORCE_MULTIPLIER
	mob.apply_central_force(dir * strength * STRENGTH_MULTIPLIER)
	
	# On attend .01 secondes avant de relancer…
	await get_tree().create_timer(frequency).timeout
	
	# …et on vérifie que le mob soit toujours capturé avant!
	if mob in parent_turret.get_mobs_in_zone():
		_apply_artificial_gravity(mob)


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
