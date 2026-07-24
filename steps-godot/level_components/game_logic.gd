extends Node
class_name GameLogic

signal start_game

@export var ui_game_hud: PackedScene = preload("res://gui/ui_game_hud.tscn")
var game_started: bool
var check_victory: bool
var ui: Node
var start_button: Button
const MAX_GRADE: int = 3  # Note maximale possible.
var grade: int  # Note actuelle.
var tutorial: Tutorial
var over: bool # Est-ce que le jeu est fini? 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_ui()
	_setup_failure_area()
	over = false
	grade = MAX_GRADE
	Global.set_grade(grade)
	Global.pulse.connect(_on_pulse)
	Global.tutorial_done.connect(_tutorial_done)
	Global.pause_game_requested.connect(_pause_game)
	Global.resume_game_requested.connect(_resume_game)
	if str(get_tree().get_current_scene().name) == 'Level4':
		Sound.play_bg('bg_waves_1', 0.3, true)


func _tutorial_done() -> void:
	Global.resume_game()


func _exit_tree() -> void:
	_reset_level()


func _setup_failure_area() -> void:
	var failure_area: Area2D = get_node("../FailureArea2D")
	if not failure_area:
		print("FailureArea2D manquante.")
	else:
		failure_area.body_entered.connect(_check_for_defeat)


## Appelé lorsqu'un corps rentre dans la FailureArea2D. On vérifie qu'il s'agisse bien d'un mob,
## et si c'est le cas, on cause une défaite.
func _check_for_defeat(mob) -> void:
	if mob is Mob:
		mob.destroy()
		grade = grade - 1  # Baisse de la note lorsqu'un mob entre dans la zone de défaite.
		Global.set_grade(grade)
		if grade <= 0:
			defeat()


## Vérifie la présence d'ennemis.
func check_for_enemies() -> int:
	var spotted = len(get_tree().get_nodes_in_group("enemy_group"))
	return spotted


## Envoie la vague suivante. 
func _send_wave() -> void:
	Global.emit_send_wave()
	Global.current_wave = Global.current_wave + 1


## Chaque seconde, on vérifie la présence d'ennemis.
func _on_pulse() -> void:
	## Si le jeu a commencé et qu'il n'y a plus d'ennemis…
	if game_started and (check_for_enemies() < 1) and over == false:
		## …et si il reste des vagues à envoyer…
		if Global.get_current_wave() < Global.get_total_waves():
			## On envoie une vague.
			_send_wave()
		## …sinon, victoire!
		else:
			victory()


## Configure l'interface user (instancie une node ui_game_hud).
func _setup_ui() -> void:
	ui = ui_game_hud.instantiate()
	add_child(ui)
	start_button = get_node("UiGameHud/StartButton")
	start_button.button_down.connect(_on_button_down)


## Appelé lorsque le bouton start est pesé.
func _on_button_down() -> void:
	if not game_started:
		print("playing sound")
		Sound.play('ui_button_start', false, 2.0)
		_send_wave()
		game_started = true
		start_button.disabled = true


## Réinitialise les propriétés de Global losrqu'on commence un niveau.
func _reset_level() -> void:
	game_started = false
	start_button.disabled = false
	Global.reset_time_and_waves()
	Global.reset_grade()


## Appelé lors d'une victoire.
func victory() -> void:
	print("well played!")
	ui.show_victory()


## Appelé lors d'une défaite
func defeat() -> void:
	over = true
	ui.show_defeat()


func _pause_game() -> void:
	get_tree().paused = true


func _resume_game() -> void:
	get_tree().paused = false
