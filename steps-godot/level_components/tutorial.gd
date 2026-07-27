class_name Tutorial
extends Node2D
## Permet d'afficher une scène de tutoriel avant le début du niveau.

@export_multiline var TutoText: String
## Mob affiché.
@export_enum("Cannette", "Lipide", "Micropolluant", "Boue") var TutoMobAnimation: String = "Cannette" 
## Tourelle affichée.
@export_enum("Charbon", "Decanteur", "Grille", "Oxygene") var TutoTurretAnimation: String = "Grille"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TutoRichTextLabel.text = TutoText
	$TutoMobAnimatedSprite2D.animation = TutoMobAnimation
	$TutoMobAnimatedSprite2D.play()
	$TutoTurretAnimatedSprite2D.animation = TutoTurretAnimation
	$TutoTurretAnimatedSprite2D.play()
	Global.current_tutorial = self
	Global.pause_game()


## Indique que le jeu peu commencer; fait disparaître le tutoriel.
func _on_skip_button_button_down() -> void:
	Sound.play('ui_button_ahead')
	Global.tutorial_complete()
	self.queue_free()
