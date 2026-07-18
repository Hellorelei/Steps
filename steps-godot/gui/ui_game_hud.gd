extends Node2D

## Interface pendant les niveaux.
## Le contenu de l'interface est rafraîchi à 1Hz, sauf cas échéant (vagues lors d'une nouvelle
## vague, etc.).
## La scène contient notamment :
## - BackButton : retour au menu principal;
## - CheckButton : toggle de pause;
## - StartButton : lance la première vague;
## - Wave : indique la vague actuelle / total des vagues;
## - Time : indique le temps écoulé;
## - GamePausedLabel : affiche Pause lorsque le jeu est en pause;
## - PauseOverlayPolygon2D : rectangle gris semi transparent pour afficher la pause;
## - DebugCheckButton : permet d'afficher / masquer le mode débug;
## - VictoryRichTextLabel : message affiché lors de la victoire;
## - DefeatRichTextLabel : message affiché lors d'une défaîte.

var pause_overlay: Object
var game_paused_label: Object
var time: Object
var wave: Object
var current_time: String
var current_wave: String
var total_waves: String
var victory_label: Object
var defeat_label: Object
var grade: int
var debug_menu_button: MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## On récupère les différents éléments d'interface.
	debug_menu_button = $DebugMenuButton
	pause_overlay = $PauseOverlayPolygon2D
	game_paused_label = $GamePausedLabel
	time = $Time
	wave = $Wave
	defeat_label = $DefeatRichTextLabel
	victory_label = $VictoryRichTextLabel
	update_texts()
	victory_label.visible = false
	defeat_label.visible = false
	## On se connecte aux signaux de Global: rafraichissement à 1Hz.
	Global.pulse.connect(update_texts)
	## Mais aussi quand une nouvelle vague est lancée!
	Global.send_wave.connect(update_texts)
	#Global.game_paused.connect()
	Global.resume_game_requested.connect(_on_game_resumed)
	Global.pause_game_requested.connect(_on_game_paused)
	$DebugCheckButton.button_pressed = Global.debug
	if Global.dev_mode == false:
		$DebugCheckButton.visible = false
		$DebugMenuButton.visible = false
	debug_menu_button.get_popup().id_pressed.connect(_debug_ending)
	Global.resume_game()


## Met à jour les éléments de texte (temps, vague) de l'interface.
func update_texts() -> void:
	_fetch_time_data()
	_fetch_wave_data()
	wave.text = "🌊 " + current_wave + "/" + total_waves
	time.text = "⏱️ " + current_time


## Va chercher les données de vague dans Global.
func _fetch_wave_data() -> void:
	current_wave = str(Global.get_current_wave())
	total_waves = str(Global.get_total_waves())


## Va chercher les données de temps dans Global.
func _fetch_time_data() -> void:
	current_time = Global.get_display_time()


## Appelé lorsque l'interrupteur de pause est allumé.
func _on_check_button_toggled(toggled_status: bool) -> void:
	Sound.play('ui_button_toggle')
	pause(toggled_status)


## Affiche ou cache les visuels de développement.
func _on_debug_check_button_toggled(toggled_status: bool) -> void:
	Sound.play('ui_button_toggle')
	Global.debug = toggled_status


## Pause le jeu et affiche l'interface de pause.
func pause(status: bool) -> void:
	if status:
		Global.pause_game()
	else:
		Global.resume_game()


## Appelé lorsque le jeu est mis en pause.
func _on_game_paused() -> void:
	show_pause_screen()	


## Appelé lorsque le jeu reprend.
func _on_game_resumed() -> void:
	hide_pause_screen()


## Affiche l'interface de pause.
func show_pause_screen() -> void:
	pause_overlay.visible = true


## Cache l'interface de pause.
func hide_pause_screen() -> void:
	pause_overlay.visible = false


## Appelé lorsque le bouton de retour au menu est activé.
func _on_back_button_button_down() -> void:
	Sound.play('ui_button_back')
	Global.resume_game()
	get_tree().change_scene_to_file("res://gui/ui_level.tscn")


## Appelé lorsque le bouton restart est appuyé → recharge la scène.
func _on_restart_button_button_down() -> void:
	Sound.play('ui_button_start')
	Global.resume_game()
	get_tree().reload_current_scene()


## Récupère la note du niveau.
func _fetch_victory_grade() -> void:
	grade = Global.get_current_grade()


func _display_grade() -> void:
	$ZeroStarScoreRichTextLabel.visible = true
	await get_tree().create_timer(0.2).timeout
	if grade >= 1:
		$OneStarScoreRichTextLabel.visible = true
		await get_tree().create_timer(0.2).timeout
		if grade >= 2:
			$TwoStarScoreRichTextLabel2.visible = true
			await get_tree().create_timer(0.2).timeout
			if grade >= 3:
				$ThreeStarScoreRichTextLabel3.visible = true
				await get_tree().create_timer(0.2).timeout
	$NextLevelButton.visible = true


## Affiche l'écran de victoire.
func show_victory() -> void:
	_fetch_victory_grade()
	Global.pause_game()
	Sound.play('ui_victory', false)
	victory_label.visible = true
	_display_grade()


## Affiche l'écran de défaîte. 
func show_defeat() -> void:
	Sound.play('ui_defeat', false)
	defeat_label.visible = true


## Relie les boutons d'action débug aux fonctions.
func _debug_ending(id) -> void:
	if id == 0:
		show_victory()
	elif id == 1:
		show_defeat()


## Demande à passer au prochain niveau. 
func _on_next_level_button_button_down() -> void:
	Sound.play('ui_button_ahead')
	var level_name = str(get_tree().get_current_scene().name)
	Global.move_to_next_level(level_name)
