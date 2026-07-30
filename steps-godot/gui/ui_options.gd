extends CanvasLayer
## La scène contient :
## - BackButton : retour au menu principal;
## - CheckButton : toggle des outils de développement;
## - CheckButton2 : toggle de son; 

func _ready() -> void:
	$CheckButton.button_pressed = Global.dev_mode
	$CheckButton2.button_pressed = Global.sound_enabled

## Appelé lorsque le toggle Outils de développement est activé.  
func _on_devmode_button_pressed(toggle_status: bool) -> void:
	Sound.play('ui_button_toggle')
	Global.dev_mode = toggle_status

## Appelé lorsque le toggle Son est activé. 
func _on_sound_button_pressed(toggle_status: bool) -> void:
	Global.sound_enabled = toggle_status
	Sound.play('ui_button_toggle')

## Appelé lorsque le bouton de retour au menu est activé.
func _on_back_button_pressed():
	Sound.play('ui_button_back')
	get_tree().change_scene_to_file("res://gui/ui_menu.tscn")
