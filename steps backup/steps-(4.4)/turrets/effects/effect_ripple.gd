extends Node2D
"""
Créé une onde circulaire se propageant depuis le point d'instanciation jusqu'au
périmètre max_radius donné, à la vitesse expand_speed. 
"""

## Rayon d'action de l'onde. 
@export var max_radius: float = 32
## Vitesse d'expansion de l'onde'.
@export var expand_speed: float = 6
## Est-ce que l'onde va de l'extérieur vers l'intérieur?
@export var inverted: bool = false
# Usage interne: rayon actuel de l'onde.
var radius: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ajuste le calcul si l'onde va vers l'intérieur.
	if inverted:
		expand_speed = 0 - expand_speed
		radius = max_radius
	#print("hi!")

## Dessine le cercle de l'onde.
func _draw():
	draw_circle(position, radius, Color(0.4, 0.6, 0.8, 0.4), false, 1, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Ajoute le temps écoulé * la vitesse de l'onde à son rayon.
	radius = clamp(radius + (delta * expand_speed), 0, max_radius)
	#print(radius)
	if radius >= max_radius or radius <= 0:
		disappear()
	# Adapte la taille du cercle de collision au nouveau rayon.
	$DamageArea2D/DamageCollisionShape2D.shape.set_radius(radius)
	# Demande de dessiner à nouveau le cercle visuel de la vaguelette. 
	queue_redraw()

## Fait disparaître l'onde.
func disappear() -> void:
	#print("bye!")
	queue_free()
	
## Endommage tout objet touché de masse >= 1.
func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	if body is Mob:
		print("body entered aoe: bang!")
		get_parent().hit_target(body)
		#if body.mass >= 1:
		#	body.hit(2)
		#else:
		#	while body in caught_list: # Repousse le corps de la zone :)
		#		body.apply_central_impulse(global_position.direction_to(body.global_position).normalized() * 0.3)
		#		await get_tree().create_timer(.01).timeout
