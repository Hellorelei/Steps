extends Area2D
class_name TurretArea2D

var parent_turret: Turret

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## On va chercher le signal chez le parent.
	if get_parent() is Turret:
		parent_turret = get_parent()
		parent_turret.pulse.connect(_on_pulse)
	else:
		print("Erreur: La node parent doit être de type Turret.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	if body in parent_turret.enemies_in_zone:
		art_grav(body)

## Activée lorsqu'une Node2D entre dans l'Area2D principale: cause l'aspiration vers la tourelle.
func _on_body_entered(body: Node2D) -> void:
	#print("hit!")
	if body is RigidBody2D:
		parent_turret.add_enemy_in_zone(body)
		# On ne cherche que les canettes: masse >= 1 (potentiellement, à changer avec le nom du mob, etc.)
		if body.mass >= 1:
			body.gravity_scale_float(0)
			art_grav(body)
			#print("graved")

func _on_body_exited(body: Node2D) -> void:
	print("body exited turret area: bye!")
	#print(caught_list)
	if body is RigidBody2D:
		body.gravity_scale_reset()
		if body in parent_turret.enemies_in_zone:
			parent_turret.remove_enemy_in_zone(body)

####
#func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	#	print("body entered aoe: bang!")
##	if body is RigidBody2D:
	#	if body.mass >= 1:
	#		body.hit(2)
	#		
func _on_pulse() -> void:
	pass
