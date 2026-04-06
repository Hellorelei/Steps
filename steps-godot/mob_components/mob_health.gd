extends Node2D

## Composant de Mob gérant les points de vie du mob, les dégâts reçus et
## les frames d'invincibilité.
class_name MobHealth

## Mob parent.
var parent_mob:Mob
var health_bar: Object

## Est-ce que le mob est actuellement invincible?
var is_in_iframe: bool

## Les points de vie du mob.
@export_range(0, 64, 1, "prefer_slider") var base_health_points:int = 16
var current_health_points:int :
	set(value):
		current_health_points = clampi(value, 0, base_health_points)
		health_points_changed.emit(health_points_percent)
		print("calling health points changed.")

## Points de vie actuels en pourcents. 
var health_points_percent:float:
	get:
		return (100.0 / base_health_points) * current_health_points

## Signal émis lorsque les points de vie du mob changent.
signal health_points_changed
#var hit_effect: CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health_points = base_health_points
	parent_mob = get_parent()
	parent_mob.mob_hit.connect(_on_mob_hit)
	#health_bar = Line2D.new()
	#health_bar.default_color = Color(1, 0.1, 0.1, 0.6)
	#add_child(health_bar)
	#hit_effect = CanvasModulate.new()
	#hit_effect.color = Color(1.2, 1.2, 1.2, 1)
	#add_sibling(hit_effect)

## Appelé lorsque le mob parent reçoit une attaque.
func _on_mob_hit(damage: int) -> void:
	if _is_mob_invincible():
		return
	else:
		_display_mob_hurt_effect()
		_apply_damage_to_mob(damage)

func _is_mob_invincible() -> bool:
	return is_in_iframe

func _grant_invincibility_frames() -> void:
	is_in_iframe = true
	parent_mob.apply_color_to_sprite(Color(0.2, 1.2, 1.2, 1))
	await get_tree().create_timer(1).timeout
	is_in_iframe = false
	parent_mob.apply_color_to_sprite()

## Fait clignoter le mob en blanc pour signifier son invincibilité
func _display_mob_hurt_effect() -> void:
	pass

## Applique les dégâts damage au mob.
func _apply_damage_to_mob(damage:int) -> void:
	current_health_points = current_health_points - damage # C'est health_points qui se charge du clamping.
	parent_mob.apply_color_to_sprite(Color(1.2, 0.2, 0.2, 1))
	_grant_invincibility_frames()
	if current_health_points == 0:
		_kill_parent_mob()
	await get_tree().create_timer(1).timeout
	parent_mob.apply_color_to_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#health_bar.points = PackedVector2Array(
	#	[parent_mob.global_position, parent_mob.global_position + Vector2(health_points_percent,0)]
	#	)
	
	#if Global.debug == true && health_bar.visible == false:
	#	health_bar.visible = true
	#if Global.debug == false && health_bar.visible == true:
	#	health_bar.visible = false
	pass

## Remonte au mob parent l'instruction de se détruire.
func _kill_parent_mob() -> void:
	parent_mob.destroy()
	
