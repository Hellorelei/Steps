## Node de base pour une tourelle.
## La tourelle demande: 
extends Node2D
class_name Turret

@export_enum("Charbon", "Décanteur", "Grille", "Oxygène") var turret_type: String = "Grille"

## Horloge interne à 0.1Hz. 
signal pulse

## Émis lorsqu'un mob entre dans la zone d'influence de la tourelle.
signal mob_entered_zone(mob: Mob)
## Émis lorsqu'un mob sort de la zone d'influence de la tourelle.
signal mob_exited_zone(mob: Mob)

## Signal pour indiquer à TurretArea2D d'activer le dampening.
signal enable_dampening

## Horloge interne à 10Hz pour les modules enfants.
var internal_clock: Timer

## Contient la liste de mobs (Objets) dans la zone d'effet de la tourelle.
var mobs_in_zone: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_internal_clock() # Lance l'horloge interne.
	
	if $AnimatedSprite2D:
		var sprite = $AnimatedSprite2D
		
		sprite.z_index = 100
		sprite.animation = "default"
		sprite.play()
		
	if $TurretArea2D: # Connecte aux signaux de la TurretArea2D si fournie.
		var turret_area_2d = $TurretArea2D
		
		# Liaison des signaux $TurretArea2D → tourelle.
		turret_area_2d.mob_entered_TurretArea2D.connect(_register_to_mobs_in_zone)
		turret_area_2d.mob_exited_TurretArea2D.connect(_withdraw_from_mobs_in_zone)
		
		# Liaison du signal d'amortissement avec turret_area_2d.
		connect("enable_dampening", turret_area_2d._enable_dampening)
		
	if $TurretAreaEffect:
		var turret_area_effect = $TurretAreaEffect
		
		# Si l'amortissement est activé, on avertit $TurretArea2D via signal.
		if turret_area_effect.dampening:
			enable_dampening.emit()

		# Liaison des signaux tourelle → $TurretAreaEffect .
		connect("mob_entered_zone", turret_area_effect._on_mob_in)
		connect("mob_exited_zone", turret_area_effect._on_mob_out)


## Efface la tourelle.
func delete() -> void:
	queue_free()		
	

## Horloge interne à 10Hz.
func _internal_clock() -> void:
	internal_clock = Timer.new()
	internal_clock.wait_time = 0.1
	internal_clock.timeout.connect(_emit_pulse)
	add_child(internal_clock)
	internal_clock.start()


## Envoie le signal pulse.
func _emit_pulse() -> void:
	pulse.emit()


## Rajoute un mob à la liste de mobs dans la zone et envoie le signal correspondant.
func _register_to_mobs_in_zone(mob: Mob) -> void:
	mobs_in_zone.append(mob)
	mob_entered_zone.emit(mob)


## Retire un mob de la liste de mobs dans la zone et envoie le signal correspondant.
func _withdraw_from_mobs_in_zone(mob: Mob) -> void:
	mobs_in_zone.erase(mob)
	mob_exited_zone.emit(mob)


## Renvoie la liste de mobs présents dans la zone.
func get_mobs_in_zone() -> Array:
	return mobs_in_zone


func area2d_enable_dampening() -> void:
	enable_dampening.emit()
