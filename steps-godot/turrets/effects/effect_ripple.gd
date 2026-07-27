extends Node2D
## Créé une onde circulaire se propageant depuis le point d'instanciation jusqu'au
## périmètre max_radius donné, à la vitesse expand_speed. 

## Rayon d'action de l'onde. 
@export var max_radius := 32.0
## Vitesse d'expansion de l'onde'.
@export var expand_speed := 6.0
## Est-ce que l'onde va de l'extérieur vers l'intérieur?
@export var inverted := false
# Usage interne: rayon actuel de l'onde.
var radius: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ajuste le calcul si l'onde va vers l'intérieur.
	if inverted:
		expand_speed = 0.0 - expand_speed
		radius = max_radius


## Dessine le cercle de l'onde.
func _draw():
	draw_circle(position, radius, Color(0.4, 0.6, 0.8, 0.4), false, 1.0, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Ajoute le temps écoulé * la vitesse de l'onde à son rayon.
	radius = clampf(radius + (delta * expand_speed), 0.0, max_radius)
	if radius >= max_radius or radius <= 0.0:
		disappear()
	# Adapte la taille du cercle de collision au nouveau rayon.
	$DamageArea2D/DamageCollisionShape2D.shape.set_radius(radius)
	# Demande de dessiner à nouveau le cercle visuel de la vaguelette. 
	queue_redraw()


## Fait disparaître l'onde.
func disappear() -> void:
	queue_free()


## Endommage tout mob touché.
func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	if body is Mob:
		get_parent().hit_target(body)
