extends Node2D

@export_multiline var TutoText: String
@export_enum("Cannette", "Lipide", "Micropolluant", "Boue") var TutoMobAnimation: String = "Cannette" 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TutoRichTextLabel.text = TutoText
	$TutoMobAnimatedSprite2D.animation = TutoMobAnimation
	$TutoMobAnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
