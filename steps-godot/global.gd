extends Node

signal send_wave

var game_time: float
var current_wave: int
var total_waves: int
var pulse_clock: Object
var half_pulse_clock: Object

@export var debug: bool = true
@export_group("Global Mob Settings", "mob_")
@export var mob_invincibility_duration: float = 0.6

signal pulse
signal half_pulse
signal spawners_ready

# Appelé une seule fois lorsque Global est initialisé. Global est persistent. 
func _ready() -> void:
	game_time = 0.0
	current_wave = 0
	total_waves = 0
	_setup_pulse()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_time = game_time + delta

## Réinitialise les compteurs de temps et vagues (utilisé lors d'un changement de niveau, retour
## au menu, etc.
func reset_time_and_waves() -> void:
	game_time = 0.0
	current_wave = 0
	total_waves = 0

## Définit le temps actuel comme étant x.
func set_time(time: float) -> void:
	game_time = time

## DEPRECIATED Ajoute delta au temps actuel.
func add_time(delta: float) -> void:
	return

## Retourne le temps actuel.
func get_time() -> float:
	return game_time

## Retourne le temps en nombre entier, format string.
func get_display_time() -> String:
	return str(int(floor(game_time)))

## Définit la vague actuelle comme étant x.
func set_current_wave(wave: int) -> void:
	current_wave = wave

## Retourne la vague actuelle en int.
func get_current_wave() -> int:
	return current_wave

## Définit le nombre de vagues totales comme étant x.
func set_total_waves(waves: int) -> void:
	total_waves = waves
	print(total_waves)

## Retourne le nombre total de vagues en int.
func get_total_waves() -> int:
	return total_waves

## Envoie le signal send_wave.
func emit_send_wave():
	send_wave.emit()

## Envoie le signal spawners_ready qui indique à GameLogic que les spawners sont prêts.
func emit_spawners_ready():
	spawners_ready.emit()

## Envoie le signal pulse. 
func _emit_pulse():
	pulse.emit()

## Remet à zéro le minuteur pulse_clock.
func reset_pulse():
	pulse_clock.start()

## Configure et lance le minuteur pulse_clock; 1Hz.
func _setup_pulse():
	pulse_clock = Timer.new()
	pulse_clock.wait_time = 1.0
	pulse_clock.timeout.connect(_emit_pulse)
	add_child(pulse_clock)
	pulse_clock.start()

## Fournit la durée d'invincibilité des mobs configurée via Global
func get_invincibility_duration() -> float:
	return mob_invincibility_duration
