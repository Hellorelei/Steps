extends Node
class_name SpawnMob
## Ce script permet de faire spawner un monstre.

static var example: PackedScene = preload("res://mobs/generic_mob.tscn")
#static var cannette: PackedScene = preload("res://mobs/Acan_mob.tscn")
static var cannette: PackedScene = preload("res://mobs/mob_can.tscn")

static func hello_world() -> String:
	return "hello world!"

## Fait spawner le monstre mob en tant qu'enfant de caller. 
static func spawn(mob, caller) -> void:
	#print("spawned!")
	var tospawn
	match mob:
		"example":
			tospawn = cannette
		"cannette":
			#print("cantest")
			tospawn = cannette
	
	tospawn = tospawn.instantiate()
	tospawn.rotation = randf()
	tospawn.set_collision_layer_value(13, true)
	caller.add_child(tospawn)
