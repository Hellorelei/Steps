extends RigidBody2D
class_name Mob

## Type de mob.
@export_enum("Cannette", "Amidons", "Micropolluants", "Lipides") var type: String = "Cannette"
@export_range(0, 64, 1.0) var health_points

var invincibility_duration: float = 1.0
var is_invincible: bool = false
var original_gravity_scale: float

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
	else:
		print("Attention: Pas d'$AnimatedSprite2D pour le mob, celui-ci sera invisible.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Applique x dégâts au mob.
func hit(damage: int) -> void:
	if not invincible:
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

func destroy() -> void:
	self.queue_free()

func invincible() -> void:
	is_invincible = true
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
	
func show_damage_taken(damage: int) -> void:
	pass
