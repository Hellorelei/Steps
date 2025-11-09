## Node de base pour une tourelle.
## La tourelle demande: 
## TODO: liste.
extends Node2D
class_name Turret

@export_enum("Charbon", "Décanteur", "Grille", "Oxygène") var turret_type: String = "Grille"

## Horloge interne à 0.1Hz. 
signal pulse

## Signaux pour l'entrée et sortie d'un corps dans la zone enfant.
signal body_in(body)
signal body_out(body)

## Signal pour indiquer à TurretArea2D d'activer le dampening.
signal enable_dampening

## Horloge interne à 10Hz pour les modules enfants.
var internal_clock: Timer

## Contient la liste d'ennemis (Objets) dans la zone d'effet de la tourelle.
var enemies_in_zone: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello world!")
	_internal_clock() # Replace with function body.
	if $AnimatedSprite2D:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Efface la tourelle.
func delete() -> void:
	queue_free()		

## Horloge interne à 0.1Hz.
func _internal_clock() -> void:
	internal_clock = Timer.new()
	internal_clock.wait_time = 0.1
	internal_clock.timeout.connect(_emit_pulse)
	add_child(internal_clock)
	internal_clock.start()

## Envoie le signal pulse.
func _emit_pulse() -> void:
	pulse.emit()

## Rajoute un ennemi à la liste d'ennemis dans la zone.
func add_enemy_in_zone(enemy) -> void:
	enemies_in_zone.append(enemy)
	body_in.emit(enemy)

## Retire un ennemi de la liste d'ennemis dans la zone.
func remove_enemy_in_zone(enemy) -> void:
	enemies_in_zone.erase(enemy)
	body_out.emit(enemy)

func get_enemies_in_zone() -> Array:
	return enemies_in_zone
	
func area2d_enable_dampening() -> void:
	enable_dampening.emit()
