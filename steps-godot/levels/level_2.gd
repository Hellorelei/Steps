extends Node2D

#Mobs à éliminer
@export var generic_mob: PackedScene
#Tours d'attaque
@export var turret_handler: PackedScene
#Attaques par vagues
@export var enemy_waves: Array = [
		["can"],
		["can"],
		["can"], 
]

#Vague d'ennemis actuels
var current_wave:int
#Nombre de process
var gametime:float
#Jeu commencé
var game_started:bool
#Nombre de vagues
var total_waves: int
#Vérification conditions de victoire
var check_victory: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	#Zones d'ajout des tours
	for base in get_tree().get_nodes_in_group("turret_base_group"):
		print(base)
		var turret_base = turret_handler.instantiate()
		turret_base.position = base.position
		add_child(turret_base)
		
	total_waves = len(enemy_waves)
	gametime = 0
	game_started = 0
	check_victory = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_b_button_2_pressed():
	get_tree().change_scene_to_file("res://ui_level.tscn")
