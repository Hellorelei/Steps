extends Node2D

# 
@export var ui_game_hud: PackedScene = preload("res://ui_game_hud.tscn")

var current_wave:int
var gametime:float
var game_started:bool
var total_waves: int
var check_victory: bool
var wave_spawners: Array
var waves: Array
var ui: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("████████ level_1 > _ready()")
	print("█ Préparation de l'interface: · · ·")
	ui = ui_game_hud.instantiate()
	add_child(ui)
	get_node("UiGameHud/StartButton").button_down.connect(_on_button_button_down)
	print("█ Récupération des spawners: · · ·")
	for wave_spawner in get_tree().get_nodes_in_group("enemy_waves_spawner"):
		wave_spawners.append(wave_spawner)
		waves.append(wave_spawner.waves)
		print("█        vagues —> " + str(wave_spawner.waves))
	print("█      spawners —> " + str(wave_spawners))
	
	print("█ Calcul des vagues: · · ·")
	if len(wave_spawners) > 0:
		var temp_waves: Array
		for wave_spawner in wave_spawners:
			temp_waves.append(len(wave_spawner.waves))
		print("█  len() vagues —> " + str(temp_waves))
		total_waves = temp_waves.max()
		print("█  max() vagues —> " + str(total_waves))
	else:
		print("█        Erreur: Aucune vague trouvée.")
		get_tree().quit()

	print("████████ · · · · · · · ·\n")
	
	total_waves = len(wave_spawners)
	gametime = 0
	game_started = 0
	check_victory = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gametime += delta
	$Time.text = "Time: " + str(int(floor(gametime)))
	$Wave.text = "Wave: " + str(current_wave) + "/" + str(total_waves)
	if check_victory:
		if not get_tree().get_nodes_in_group("enemy_group"):
			print("████████ Vérifier victoire: aucun ennemi restant. Bravo!")
			# add victory function here :)
			$CheckButton.button_pressed = true

func enemy_wave(index:int):
	print("████████ level_1 > enemy_wave(" + str(index) + ")")
	current_wave = index + 1
	print("█ Vague: " + str(current_wave) + "/" + str(total_waves))
	print("█ Appel aux spawners: · · ·")
	for wave_spawner in wave_spawners:
		print("█  wave_spawner.spawn_wave() —> " + str(wave_spawner) + str(index))
		wave_spawner.spawn_wave(index)
	print("█ Timer: · · ·")
	await get_tree().create_timer(10, false).timeout
	print("█ Timer: Terminé.")
	
	print("█ Vérification de la progression: · · ·")
	print("█  Est-ce que " + str(current_wave) + " < " + str(total_waves) + " ?")
	if current_wave < total_waves:
		print("█  Oui! On lance la vague suivante: · · ·")
		enemy_wave(index + 1)
	else:
		print("█  Non! On change le drapeau de vérification des victoires: · · ·")
		check_victory = true

func start_game():
	enemy_wave(0)

## TODO: move to ui_game_hud?
func _on_button_button_down() -> void:
	if not game_started:
		start_game()
		get_node("UiGameHud/StartButton").disabled = true

func _on_failure_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("game over!")
		# TODO: move to game over scene
		# The function will take a level in to have a restart
		# level option; we'll do that later.
