extends RigidBody2D
## Extension de RigidBody2D pour faire les mobs.
##
## Un mob est constitué des composants suivants: [br]
## - Un AnimatedSprite2D pour lui donner une apparence; [br]
## - Un VisibleOnScreenNotifier2D pour le faire disparaître à la sortie de l'écran; [br]
## - Un CollisionShape2D pour lui donner une hitbox; [br]
## - Un MobDebug pour pouvoir visualiser certaines variables lorsque nécessaire; [br]
## - Un MobHealth qui gère sa vie, son invincibilité, etc. [br]
class_name Mob

## Type de mob; affecte l'interaction avec les tours et projectiles.
@export_enum("Cannette", "Amidons", "Micropolluants", "Lipides") var type: String = "Cannette"

var original_gravity_scale: float

signal mob_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_sleep = false # Fait que la simulation physique reste active même si le mob ne bouge plus.
	original_gravity_scale = gravity_scale # On stocke la variable pour pouvoir réinitialiser après.
	
	self.add_to_group("enemy_group")
	
	## On regarde s'il y a un $AnimatedSprite2D pour avoir le sprite + animation; si non, informer.
	if $AnimatedSprite2D:
		# $AnimatedSprite2D.set_scale(Vector2(0.1, 0.1))
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.play()
	else:
		print("Attention: Pas d'$AnimatedSprite2D pour le mob, celui-ci sera invisible.")

## Applique x dégâts au mob.
func hit(damage: int = 0) -> void:
	mob_hit.emit(damage)

## Applique la modulation Color au sprite. Si aucun paramètre, réinitialise la modulation. 
func apply_color_mod_to_sprite(new_color: Color = Color(1, 1, 1, 1)) -> void:
	$AnimatedSprite2D.self_modulate = new_color

func change_gravity_scale(new_scale: float = 0) -> void:
	gravity_scale = new_scale

## Réinitialise la gravity_scale du mob.
func reset_gravity_scale() -> void:
	gravity_scale = original_gravity_scale

## Appelé lorsqu'un mob est détruit.
func destroy() -> void:
	self.queue_free()
