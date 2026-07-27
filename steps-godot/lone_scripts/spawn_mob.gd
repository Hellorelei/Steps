class_name SpawnMob
extends Node
## Ce script permet de faire spawner un monstre.

static var cannette: PackedScene = preload("res://mobs/mob_can.tscn")
static var amidon: PackedScene = preload("res://mobs/mob_starch.tscn")
static var boue: PackedScene = preload("res://mobs/mob_mud.tscn")
static var lipide: PackedScene = preload("res://mobs/mob_lipid.tscn")
static var micro: PackedScene = preload("res://mobs/mob_micro.tscn")


## Renvoie un hello world pour indiquer que le script est fonctionnel.
static func hello_world() -> String:
	return "hello world!"


## Fait spawner le monstre [param mob] en tant qu'enfant de [param caller]. 
static func spawn(mob, caller) -> void:
	var tospawn
	match mob:
		"cannette":
			tospawn = cannette
		"amidon":
			tospawn = amidon
		"boue":
			tospawn = boue
		"lipide":
			tospawn = lipide
		"micropolluant":
			tospawn = micro
	
	tospawn = tospawn.instantiate()
	tospawn.rotation = randf()
	tospawn.set_collision_layer_value(13, true)
	caller.add_child(tospawn)
