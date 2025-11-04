extends Node2D
#onready var listener = #reference to your listener here 
var pause_overlay: Object
var game_paused_label: Object
var time: Object
var wave: Object
var current_time: String
var current_wave: String
var total_waves: String
var victory_label: Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_overlay = $PauseOverlayPolygon2D
	game_paused_label = $GamePausedLabel
	time = $Time
	wave = $Wave
	victory_label = $VictoryRichTextLabel
	update_texts()
	victory_label.visible = false
	## On se connecte aux signaux de Global: rafraichissement à 1Hz.
	Global.pulse.connect(update_texts)
	## Mais aussi quand une nouvelle vague est lancée!
	Global.send_wave.connect(update_texts)
	$DebugCheckButton.button_pressed = Global.debug

## Met à jour les éléments de texte (temps, vague) de l'interface.
func update_texts() -> void:
	_fetch_time_data()
	_fetch_wave_data()
	wave.text = "🌊 " + current_wave + "/" + total_waves
	time.text = "⏱️ " + current_time

## Va chercher les données de vague dans Global.
func _fetch_wave_data():
	current_wave = str(Global.get_current_wave())
	total_waves = str(Global.get_total_waves())

## Va chercher les données de temps dans Global.
func _fetch_time_data():
	current_time = Global.get_display_time()

## Appelé lorsque l'interrupteur de pause est allumé.
func _on_check_button_toggled(toggled_on: bool) -> void:
	pause(toggled_on)

func _on_debug_check_button_toggled(toggled_on: bool) -> void:
	Global.debug = toggled_on

## Pause le jeu et affiche l'interface de pause.
func pause(status: bool) -> void:
	get_tree().paused = status
	pause_overlay.visible = status
	game_paused_label.visible = status

## Appelé lorsque le bouton de retour au menu est activé.
func _on_back_button_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui_level.tscn")

func show_victory() -> void:
	victory_label.visible = true
