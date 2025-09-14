extends Area2D
var turret_type: String
var caught_list: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turret_type = "generic"
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.play()
	caught_list = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Delete turret: we release all bodies ever caught by it first.
func delete() -> void:
	for body in caught_list:
		body.release()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("hit!")
	if body is RigidBody2D:
		caught_list.append(body)
		var target_pos = body.global_position
		var self_pos = $AnimatedSprite2D.global_position
		print(target_pos)
		print(self_pos)
		body.caught(self_pos, turret_type)
		print(caught_list)

func _on_body_exited(body: Node2D) -> void:
	print("bye!")
	print(caught_list)
	if body is RigidBody2D:
		body.release()
		if body in caught_list:
			caught_list.erase(body)
			print("list without:")
			print(caught_list)
