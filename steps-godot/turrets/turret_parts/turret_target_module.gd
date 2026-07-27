class_name TurretTargetModule
extends Node2D
## Node permettant aux tourelles de viser des ennemis et leur tirer dessus. 
##
## Les modes de ciblage implémentés sont "Suivi" et "Aléatoire".

signal shoot_at(target: Mob)

## Type de ciblage.
@export_enum("Aléatoire", "Suivi", "Zone") var targeting_mode: String = "Aléatoire"
## Vitesse de tir en tirs par seconde.
@export_range(0.0, 8.0, 0.1) var fire_rate: float = 0.5
## Dommages causés aux mobs de type ciblés.
@export_range(0, 32, 1, "prefer_slider") var target_damage: int = 1
## Dommages causés aux autres mobs.
@export_range(0, 32, 1, "prefer_slider") var other_damage: int = 0
@export var target_cannettes := false
@export var target_amidons := false
@export var target_micropolluants := false
@export var target_lipides := false
@export var target_boues := false

var enabled_targets: Array
var fire_clock: Timer
var parent_turret: Turret
var current_target: Mob


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# On va chercher le signal chez le parent.
	if get_parent() is Turret:
		parent_turret = get_parent()
	else:
		printerr("La node parent doit être de type Turret.")
		
	if fire_rate > 0.0:
		_setup_fire_clock()
		
	enabled_targets = _setup_targets()


## Fonction appelée lorsqu'un mob est touché par la tourelle.
func hit_target(body: Mob) -> void:
	if body.type in enabled_targets:
		body.hit(target_damage)
	else:
		if other_damage == 0:
			return
		if body is Mob:
			body.hit(other_damage)


## Appelé à la fréquence de tir; tire.
func _on_fire_pulse() -> void:
	var potential_targets: Array = parent_turret.get_mobs_in_zone()
	match targeting_mode:
		"Aléatoire":
			if potential_targets.is_empty():
				return
			else:
				current_target = parent_turret.get_mobs_in_zone().pick_random()
		"Suivi":
			if potential_targets.is_empty():
				return
			else:
				if not current_target in parent_turret.get_mobs_in_zone():
					current_target = parent_turret.get_mobs_in_zone().pick_random()
		"Zone":
			pass # Pas implémenté.

	shoot_at.emit(current_target)


## Initialize une liste de cibles acceptées à partir des réglages de l'éditeur.
func _setup_targets() -> Array:
	var target_list: Array = []
	if target_cannettes:
		target_list.append("Cannettes")
	if target_amidons:
		target_list.append("Amidons")
	if target_micropolluants:
		target_list.append("Micropolluants")
	if target_lipides:
		target_list.append("Lipides")
	if target_boues:
		target_list.append("Boues")
	return target_list


## Prépare les horloges gérant la fréquence de tirs.
func _setup_fire_clock() -> void:
	fire_clock = Timer.new()
	fire_clock.wait_time = clampf(1.0 / fire_rate, 0.1, 8.0)
	fire_clock.timeout.connect(_on_fire_pulse)
	add_child(fire_clock)
	fire_clock.start()
