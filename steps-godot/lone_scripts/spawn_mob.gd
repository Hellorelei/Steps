extends Node
class_name SpawnMob
## Ce script permet de faire spawner un monstre.

static var cannette: PackedScene = preload("res://mobs/mob_can.tscn")
static var amidon: PackedScene = preload("res://mobs/mob_starch.tscn")

static func hello_world() -> String:
	return "hello world!"

## Fait spawner le monstre mob en tant qu'enfant de caller. 
static func spawn(mob, caller) -> void:
	var tospawn
	match mob:
		"cannette":
			tospawn = cannette
		"amidon":
			tospawn = amidon
	
	tospawn = tospawn.instantiate()
	tospawn.rotation = randf()
	tospawn.set_collision_layer_value(13, true)
	caller.add_child(tospawn)
