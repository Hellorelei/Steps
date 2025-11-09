extends RigidBody2D
class_name Mob

## Type de mob.
@export_enum("Cannette", "Amidons", "Micropolluants", "Lipides") var type: String = "Cannette"
@export_range(0, 64, 1.0) var health_points = 4

var invincibility_duration: float = 1.0
var is_invincible: bool = false
var original_gravity_scale: float
var hit_effect: CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_sleep = false # Fait que la simulation physique reste active même si le mob ne bouge plus.
	original_gravity_scale = gravity_scale # On stocke la variable pour pouvoir réinitialiser après.
	invincibility_duration = Global.get_invincibility_duration()
	
	self.add_to_group("enemy_group")
	
	## On regarde s'il y a un $AnimatedSprite2D pour avoir le sprite + animation; si non, informer.
	if $AnimatedSprite2D:
		$AnimatedSprite2D.set_scale(Vector2(0.1, 0.1))
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.play()
		#hit_effect = CanvasModulate.new()
		#hit_effect.set_color(Color(255, 0, 0, 0.8))
		#hit_effect.visible = true
		#$AnimatedSprite2D.add_child(hit_effect)
	else:
		print("Attention: Pas d'$AnimatedSprite2D pour le mob, celui-ci sera invisible.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Applique x dégâts au mob.
func hit(damage: int) -> void:
	print("was hit!")
	if not is_invincible:
		invincible()
		health_points = clampi(health_points - damage, 0, 1000000)
		show_damage_taken(damage)
		if health_points == 0:
			self.destroy()

func change_gravity_scale(new_scale: float = 0) -> void:
	gravity_scale = new_scale

## Réinitialise la gravity_scale du mob.
func reset_gravity_scale() -> void:
	gravity_scale = original_gravity_scale

## Appelé lorsqu'un mob est détruit.
func destroy() -> void:
	$AnimatedSprite2D.self_modulate = Color(0.2, 0.2, 0.2, 1)
	await get_tree().create_timer(0.2).timeout
	self.queue_free()

## Rend le mob invincible s'il ne l'est pas déjà, pour la durée prévue.
func invincible() -> void:
	is_invincible = true
	$AnimatedSprite2D.self_modulate = Color(1.2, 1.2, 1.2, 1)
	await get_tree().create_timer(invincibility_duration).timeout
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)
	is_invincible = false
	
## Affiche visuellement que des dégâts ont été pris.
func show_damage_taken(damage: int) -> void:
	#hit_effect.visible = true
	var old_modulate: Color = $AnimatedSprite2D.get_self_modulate()
	$AnimatedSprite2D.self_modulate = Color(1, 0.2, 0.2, 1)
	await get_tree().create_timer(0.1, false).timeout
	$AnimatedSprite2D.self_modulate = Color(old_modulate)
	#hit_effect.visible = false
