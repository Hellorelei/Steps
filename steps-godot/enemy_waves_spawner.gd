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
	print("████████ EnemyWavesSpawner")
	add_to_group("enemy_waves_spawner")
	var spawner = load("res://lone_scripts/spawn_mob.gd")
	print("█           Test SpawnMob: " + SpawnMob.hello_world())
	all_waves_spawned = false
	print("█ Récupération des vagues: · · ·")
	get_children_waves()
	print("█               —> vagues: " + str(len(waves)))
	print("████████ · · · · · · · ·\n")

func get_children_waves() -> void:
	for child in self.get_children():
		waves.append(child.get_wave())

## Demande au spawner de faire apparaître la vague à l'index fourni.
func spawn_wave(index: int = 0) -> void:
	if index < len(waves): 
		var wave = waves[index]
		for entry in wave: 
			print(entry)
			SpawnMob.spawn(entry, self)
			await get_tree().create_timer(1, false).timeout
	return

func enemy_wave(index:int):
	print("wave in:" + str(index))
#	current_wave = index + 1
	#for enemy in enemy_waves[index]:
	#	add_enemy(enemy)
	#	await get_tree().create_timer(1).timeout
	#await get_tree().create_timer(10).timeout
#	print(len(enemy_waves))
#	if (index + 1) < len(enemy_waves):
#		print(str(index + 1) + ":" + str(len(enemy_waves)))
#		enemy_wave(index + 1)
#	else:
#		check_victory = true

#func add_enemy(enemy:String):
	#var mob = generic_mob.instantiate()
	#mob.position = $MobSpawnMarker2D.position
	#mob.set_collision_layer_value(13, true)
	#add_child(mob)
	#mob.rotation = randf()
