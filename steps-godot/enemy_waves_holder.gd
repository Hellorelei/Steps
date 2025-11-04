extends Node
class_name EnemyWavesHolder

var registered_spawners: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("spawners ready.")
	Global.emit_spawners_ready()
	_fill_Global()

func register_spawner(spawner: Object) -> void:
	registered_spawners.append(spawner)
	print("spawner registered.")

func _fill_Global() -> void:
	var tempwaves: Array
	for spawner in registered_spawners:
		tempwaves.append(len(spawner.waves))
	var maxwaves = tempwaves.max()
	Global.set_total_waves(maxwaves)
