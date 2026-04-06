extends Node2D

## Composant de Mob gérant les points de vie du mob et les dégâts reçus.
class_name MobHealth

## Mob parent.
var parent_mob:Mob
var health_bar: Object

@export var mob_is_invincible:bool = false

## Les points de vie du mob.
@export_range(0, 64, 1, "prefer_slider") var base_health_points:int = 16
var current_health_points:int :
	set(value):
		current_health_points = clampi(value, 0, base_health_points)
		health_points_changed.emit(health_points_percent)

## Points de vie actuels en pourcents. 
var health_points_percent:float:
	get:
		return (100.0 / base_health_points) * current_health_points

## Signal émis lorsque les points de vie du mob changent.
signal health_points_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health_points = base_health_points
	parent_mob = get_parent()
	parent_mob.mob_hit.connect(_on_mob_hit)

## Appelé lorsque le mob parent reçoit une attaque.
func _on_mob_hit(damage: int) -> void:
	if mob_is_invincible:
		_display_mob_invincible_effect()
	else:
		_display_mob_hurt_effect()
		_apply_damage_to_mob(damage)

## Fait clignoter le mob en rouge pour signifier que des dégâts ont été reçus.
func _display_mob_hurt_effect() -> void:
	parent_mob.apply_color_mod_to_sprite() # Reset au cas où un effet est déjà appliqué.
	parent_mob.apply_color_mod_to_sprite(Color(1.2, 0.2, 0.2, 1))
	await get_tree().create_timer(0.2).timeout
	parent_mob.apply_color_mod_to_sprite()

## Fait clignoter le mob en blanc pour signifier son invincibilité.
func _display_mob_invincible_effect() -> void:
	parent_mob.apply_color_mod_to_sprite()
	parent_mob.apply_color_mod_to_sprite(Color(18.892, 18.892, 18.892, 1.0))
	await get_tree().create_timer(0.2).timeout
	parent_mob.apply_color_mod_to_sprite()

## Applique les dégâts damage au mob.
func _apply_damage_to_mob(damage:int) -> void:
	current_health_points = current_health_points - damage # C'est health_points qui se charge du clamping.
	if current_health_points == 0:
		_kill_parent_mob()

## Remonte au mob parent l'instruction de se détruire.
func _kill_parent_mob() -> void:
	parent_mob.apply_color_mod_to_sprite(Color(0.2, 0.2, 0.2, 1)) # Un effet visuel quand même !
	await get_tree().create_timer(0.2).timeout
	parent_mob.destroy()
