extends Area2D
var turret_type: String
var caught_list: Array
var aoe_radius: int
var aoe_alpha: float

var zone_radius: int
var zone_ripples: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turret_type = "oxygen"
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.play()
	caught_list = []
	
	$DamageArea2D/DamageCollisionShape2D.shape.set_radius(aoe_radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	pass

func shoot():
	# v from turret to first entry in caught_list
	# instanciate a bubble and impulse it with vector
	# bubble contains a script to downscale itself until disappearance with time
	# firing refractory period (to see how implemented :)) 
	
	pass

## Efface la tourelle.
func delete() -> void:
	queue_free()

## Activée lorsqu'une Node2D entre dans l'Area2D principale: cause l'aspiration vers la tourelle.
func _on_body_entered(body: Node2D) -> void:
	print("hit!")
	if body is RigidBody2D:
		caught_list.append(body)

func _on_body_exited(body: Node2D) -> void:
	print("body exited turret area: bye!")
	if body is RigidBody2D:
		if body in caught_list:
			caught_list.erase(body)
			print("list without:")
			print(caught_list)


func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("body entered aoe: bang!")
		if body.mass >= 1:
			body.hit(2)
		#else:
		#	while body in caught_list: # Repousse le corps de la zone :)
		#		body.apply_central_impulse(global_position.direction_to(body.global_position).normalized() * 0.3)
		#		await get_tree().create_timer(.01).timeout
