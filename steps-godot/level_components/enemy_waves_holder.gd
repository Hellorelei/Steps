class_name EnemyWavesHolder
extends Node
## Relie des EnemyWavesContent à un EnemyWavesSpawner.

var registered_spawners: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.emit_spawners_ready()
	_fill_Global()


## Appelé par un spawner pour s'enregistrer auprès de cette node.
func register_spawner(spawner: Object) -> void:
	registered_spawners.append(spawner)


## Transmet le total de vagues au Global.
func _fill_Global() -> void:
	var tempwaves := []
	for spawner in registered_spawners:
		tempwaves.append(len(spawner.waves))
	var maxwaves = tempwaves.max()
	Global.set_total_waves(maxwaves)
