extends CanvasLayer

## La scène contient: 
## - BackButton : retour au menu principal;
## - Level_X_Button : accès aux niveaux 1 à 4;

## Appelé lorsque le bouton de retour au menu est activé.
func _on_back_button_pressed():
	Sound.play('ui_button_back')
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")

## Appelé lorsque le bouton du niveau 1 est activé.
func _on_level_1_button_pressed():
	Sound.play('ui_button_ahead')
	Global.game_time = 0.0
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

## Appelé lorsque le bouton du niveau 3 est activé.
func _on_level_2_button_pressed():
	Sound.play('ui_button_ahead')
	Global.game_time = 0.0
	get_tree().change_scene_to_file("res://levels/level_2.tscn")

## Appelé lorsque le bouton du niveau 3 est activé.
func _on_level_3_button_pressed():
	Sound.play('ui_button_ahead')
	Global.game_time = 0.0
	get_tree().change_scene_to_file("res://levels/level_3.tscn")

## Appelé lorsque le bouton du niveau 4 est activé.
func _on_level_4_button_pressed():
	Sound.play('ui_button_ahead')
	Global.game_time = 0.0
	get_tree().change_scene_to_file("res://levels/level_4.tscn")
