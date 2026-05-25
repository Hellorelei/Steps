## Cette classe est un point de spawn pour des vagues d'ennemis. 
##
## Elle hérite de Marker2D pour définir l'emplacement.
## Elle demande des enfants de type EnemyWavesContent pour fournir les vagues.
## Elle se fait appeler avec spawn_wave(index: int = 0) lorsqu'il faut faire apparaître une vague.
extends Marker2D

class_name EnemyWavesSpawner

# Les vagues d'ennemis, en liste de listes d'ennemis au format string.
var waves: Array
var all_waves_spawned: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy_waves_spawner")
	all_waves_spawned = false
	# On enregistre le spawner dans le gestionnaire de spawners.
	_register_spawner()
	get_children_waves()

	Global.send_wave.connect(_on_send_wave)


func get_children_waves() -> void:
	for child in self.get_children():
		waves.append(child.get_wave())


## Demande au spawner de faire apparaître la vague à l'index fourni.
func spawn_wave(index: int = 0) -> void:
	if index < len(waves): 
		var wave = waves[index]
		for entry in wave: 
			SpawnMob.spawn(entry, self)
			await get_tree().create_timer(1, false).timeout
	return


func _on_send_wave():
	var index: int = Global.get_current_wave()
	spawn_wave(index)


func _register_spawner() -> void:
	if get_parent() is EnemyWavesHolder:
		get_parent().register_spawner(self)
	else:
		print("Error registering spawner.")
	return
