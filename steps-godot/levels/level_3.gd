extends Node2D

@export var generic_mob: PackedScene
@export var turret_handler: PackedScene
@export var enemy_waves: Array = [
		["can"],
		["can", "can", "can"],
		["can", "can", "can", "can", "can", "can", "can"]
	]
	
var current_wave:int
var gametime:float
var game_started:bool
var total_waves: int
var check_victory: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	# Adding a test mob!
	var mob = generic_mob.instantiate()
	mob.position = $MobSpawnMarker2D.position
	#mob.self_curve = $MobPath.curve
	mob.rotation = randf()
	mob.mass = 0.6
	add_child(mob)
	
	for base in get_tree().get_nodes_in_group("turret_base_group"):
		print(base)
		var turret_base = turret_handler.instantiate()
		turret_base.position = base.position
		add_child(turret_base)
		
	#var turret_base = turret_handler.instantiate()
	#turret_base.position = $TurretMarker2D.position
	#add_child(turret_base)
	
	total_waves = len(enemy_waves)
	gametime = 0
	game_started = 0
	check_victory = false
