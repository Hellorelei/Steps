extends Node
class_name GameLogic

signal start_game

@export var ui_game_hud: PackedScene = preload("res://ui_game_hud.tscn")

var game_started: bool
var check_victory: bool
var ui: Node
var start_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_ui()
	Global.pulse.connect(_on_pulse)

func _exit_tree() -> void:
	_reset_level()

## Vérifie la présence d'ennemis.
func check_for_enemies() -> int:
	var spotted = len(get_tree().get_nodes_in_group("enemy_group"))
	if spotted > 0:
		print(spotted)
	return spotted

## Envoie la vague suivante. 
func _send_wave() -> void:
	Global.emit_send_wave()
	Global.current_wave = Global.current_wave + 1

## Chaque seconde, on vérifie la présence d'ennemis.
func _on_pulse() -> void:
	#print(game_started)
	#print(Global.debug)
	## Si le jeu a commencé et qu'il n'y a plus d'ennemis…
	if game_started and (check_for_enemies() < 1):
		#print("[ " + str(Global.get_current_wave()))
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
		_send_wave()
		game_started = true
		start_button.disabled = true

## Réinitialise les propriétés de Global losrqu'on commence un niveau.
func _reset_level() -> void:
	game_started = false
	start_button.disabled = false
	Global.reset_time_and_waves()

## Appelé lors d'une victoire.
func victory() -> void:
	print("well played!")
	ui.show_victory()
