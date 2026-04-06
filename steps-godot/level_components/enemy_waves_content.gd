## Cette classe contient un dictionnaire représentant une vague d'ennemis.
extends EnemyWavesSpawner
class_name EnemyWavesContent

var wave_content: Dictionary
var wavee_content: Array

@export_group("Vague 1")
@export_range(0, 20, 1.0) var cannette:float = 0
@export_range(0, 20, 1.0) var boue:float = 0
@export_range(0, 20, 1.0) var lipide:float = 0
@export_range(0, 20, 1.0) var amidon:float = 0
@export_range(0, 20, 1.0) var micropolluant:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_content = {
		"cannette": cannette,
		"boue": boue,
		"lipide": lipide,
		"amidon": amidon,
		"micropolluant": micropolluant
	}

func get_wave() -> Array:
	var unpacked_wave: Array = []
	# Pour chaque entrée dans le dictionnaire, on l'ajoute autant de fois que
	# sa valeur numérique à la liste unpacked_wave.
	for entry in wave_content:
		if wave_content[entry] > 0:
			for i in range(0, wave_content[entry]):
				unpacked_wave.append(entry)
	# Mélange le contenu de la liste de mobs.
	unpacked_wave.shuffle()
	return unpacked_wave
