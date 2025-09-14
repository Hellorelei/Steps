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
	#var mob = generic_mob.instantiate()
	#mob.position = $MobSpawnMarker2D.position
	#mob.self_curve = $MobPath.curve
	#mob.rotation = randf()
	#add_child(mob)
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gametime += delta
	$Time.text = "Time: " + str(int(floor(gametime)))
	$Wave.text = "Wave: " + str(current_wave) + "/" + str(total_waves)
	if check_victory:
		if not get_tree().get_nodes_in_group("enemy_group"):
			print("yay!")
			# add victory function here :)
			$CheckButton.button_pressed = true

func _on_b_button_1_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui_level.tscn")

func enemy_wave(index:int):
	print("wave in:" + str(index))
	current_wave = index + 1
	for enemy in enemy_waves[index]:
		add_enemy(enemy)
		await get_tree().create_timer(1).timeout
	await get_tree().create_timer(10).timeout
	print(len(enemy_waves))
	if (index + 1) < len(enemy_waves):
		print(str(index + 1) + ":" + str(len(enemy_waves)))
		enemy_wave(index + 1)
	else:
		check_victory = true

func add_enemy(enemy:String):
	var mob = generic_mob.instantiate()
	mob.position = $MobSpawnMarker2D.position
	mob.self_curve = $MobPath.curve
	mob.rotation = randf()
	add_child(mob)

func start_game():
	enemy_wave(0)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().paused = true
		$PauseOverlayPolygon2D.visible = true
		#modulate = Color(0.3, 0.3, 0.3, 1)
		$GamePausedLabel.visible = true
	else:
		get_tree().paused = false
		$PauseOverlayPolygon2D.visible = false
		#modulate = Color(1, 1, 1, 1)
		$GamePausedLabel.visible = false


func _on_button_button_down() -> void:
	if not game_started:
		start_game()
		$StartButton.disabled = true
	pass # Replace with function body.


func _on_failure_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("game over!")
		# TODO: move to game over scene
		# The function will take a level in to have a restart
		# level option; we'll do that later.
