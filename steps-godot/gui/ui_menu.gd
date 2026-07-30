extends CanvasLayer
## La scène contient: 
## - OptionsButton : accès aux options du jeu;
## - CreditsButton : accès aux crédits;
## - QuitButton : quitter le jeu; 
## - StartButton : accès au menu des niveaux 1 à 4;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sound.play_bg('bg_forest_1', 0.6, true)

## Appelé lorsque le bouton Jouer est activé.
func _on_start_button_pressed() -> void:
	Sound.play('ui_button_ahead')
	get_tree().change_scene_to_file("res://gui/ui_level.tscn")

## Appelé lorsque le bouton Crédits est activé.
func _on_credits_button_pressed() -> void:
	Sound.play('ui_button_ahead')
	get_tree().change_scene_to_file("res://gui/credits.tscn")

## Appelé lorsque le bouton Options est activé.
func _on_options_button_pressed() -> void:
	Sound.play('ui_button_ahead')
	get_tree().change_scene_to_file("res://gui/ui_options.tscn")

## Appelé lorsque le bouton Quitter est activé, quitte le jeu. 
func _on_quit_button_pressed() -> void:
	Sound.play('ui_button_back')
	get_tree().quit()
