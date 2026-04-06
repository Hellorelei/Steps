extends Area2D
var turret_type: String
var caught_list: Array
var aoe_radius: int
var aoe_alpha: float

var zone_radius: int
var zone_ripples: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turret_type = "generic"
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.play()
	caught_list = []
	aoe_radius = 0
	aoe_alpha = 0
	zone_ripples = [
		[0, 0],
		[0, 0],
		[0, 0]
	]
	
	$DamageArea2D/DamageCollisionShape2D.shape.set_radius(aoe_radius)
	aoe()
	#zone_ripple()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_circle(position, aoe_radius,
			Color(0.4, 0.6, 0.8, aoe_alpha), false, 1, true)
	#for ripple in zone_ripples:
	#	draw_circle(position, ripple[0], 
	#		Color(0.4, 0.6, 0.8, ripple[1]), true, 1, true)

## Efface la tourelle.
func delete() -> void:
	queue_free()		

func aoe():
	for i in range(64):
		aoe_radius = i
		aoe_alpha = (clamp(i-8, 1, 8) * 0.1)
		$DamageArea2D/DamageCollisionShape2D.shape.set_radius(aoe_radius)
		queue_redraw()
		await get_tree().create_timer(.02).timeout
	
	# On désactive et réactive le monitoring pour reprendre en compte
	# les ennemis qui entreraient dans la zone à nouveau.
	monitoring = false 
	monitoring = true
	
	for i in range(6):
		aoe_alpha = (6-i) * 0.1
		queue_redraw()
		await get_tree().create_timer(.1).timeout
	aoe()

## Applique une pseudo-gravité au corps body passé en argument, en direction de la tourelle.
## La force est appliquée toute les .01 secondes tant que le corps reste dans la zone.
func art_grav(body):
	# print("wooo")
	# dir: vecteur entre body et la tourelle, normalisé
	var dir = body.global_position.direction_to(global_position).normalized()
	# Application de la force au centre de body, multipliée
	body.apply_central_force(dir * 16)
	# On attend .01 secondes avant de relancer…
	await get_tree().create_timer(.01).timeout
	# …et on vérifie que le corps soit toujours capturé avant!
	if body in caught_list:
		art_grav(body)

## Activée lorsqu'une Node2D entre dans l'Area2D principale: cause l'aspiration vers la tourelle.
func _on_body_entered(body: Node2D) -> void:
	print("hit!")
	if body is RigidBody2D:
		caught_list.append(body)
		# On ne cherche que les canettes: masse >= 1 (potentiellement, à changer avec le nom du mob, etc.)
		if body.mass >= 1:
			body.gravity_scale_float(0)
			art_grav(body)
			print("graved")

func _on_body_exited(body: Node2D) -> void:
	print("body exited turret area: bye!")
	#print(caught_list)
	if body is RigidBody2D:
		body.gravity_scale_reset()
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
