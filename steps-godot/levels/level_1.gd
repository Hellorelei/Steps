extends Node2D

@export var generic_mob: PackedScene
@export var turret_handler: PackedScene
@export var enemy_waves: Array

var score:int
var gametime:float
var game_started:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	# Adding a test mob!
	var mob = generic_mob.instantiate()
	mob.position = $MobSpawnMarker2D.position
	mob.self_curve = $MobPath.curve
	mob.rotation = randf()
	add_child(mob)
	
	var turret_base = turret_handler.instantiate()
	turret_base.position = $TurretMarker2D.position
	add_child(turret_base)
	
	gametime = 0
	game_started = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gametime += delta
	$Time.text = "Time: " + str(int(floor(gametime)))
	$Score.text = "Score: " + str(int(floor(score)))
	pass

func _on_b_button_1_pressed():
	get_tree().change_scene_to_file("res://ui_level.tscn")

func enemy_wave(index:int):
	for enemy in enemy_waves[index]:
		add_enemy(enemy)
		await get_tree().create_timer(1).timeout
	pass

func add_enemy(enemy:String):
	var mob = generic_mob.instantiate()
	mob.position = $MobSpawnMarker2D.position
	mob.self_curve = $MobPath.curve
	mob.rotation = randf()
	add_child(mob)

func start_game():
	enemy_wave(1)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_button_button_down() -> void:
	if not game_started:
		start_game()
	pass # Replace with function body.
