extends Node2D
class_name Tutorial

@export_multiline var TutoText: String
@export_enum("Cannette", "Lipide", "Micropolluant", "Boue") var TutoMobAnimation: String = "Cannette" 
@export_enum("Charbon", "Decanteur", "Grille", "Oxygene") var TutoTurretAnimation: String = "Grille"
# Called when the node enters the scene tree for the first time.

signal skip_button_pressed

func _ready() -> void:
	$TutoRichTextLabel.text = TutoText
	$TutoMobAnimatedSprite2D.animation = TutoMobAnimation
	$TutoMobAnimatedSprite2D.play()
	$TutoTurretAnimatedSprite2D.animation = TutoTurretAnimation
	$TutoTurretAnimatedSprite2D.play()
	Global.current_tutorial = self
	Global.pause_game()


func _on_skip_button_button_down() -> void:
	Global.tutorial_complete()
	self.queue_free()
