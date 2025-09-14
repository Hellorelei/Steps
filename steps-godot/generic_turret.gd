extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func delete() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("hit!")
	if body is RigidBody2D:
		var target_pos = body.global_position
		var self_pos = $AnimatedSprite2D.global_position
		print(target_pos)
		print(self_pos)
		body.caught(self_pos)
	pass # Replace with function body.
