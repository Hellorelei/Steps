extends Node2D
class_name TurretTargetModule

## Type de ciblage.
@export_enum("Aléatoire", "Suivi", "Zone") var targeting_mode: String = "Aléatoire"
## Vitesse de tir en tirs par seconde.
@export_range(0.0, 8.0, 0.1) var fire_rate: float = 0.5
## Dommages causés aux mobs de type ciblés.
@export_range(0.0, 32.0, 1.0) var target_damage: float = 1.0
## Dommages causés aux autres mobs.
@export_range(0, 32.0, 1.0) var other_damage: float = 0.0
@export var target_cannettes: bool = false
@export var target_amidons: bool = false
@export var target_micropolluants: bool = false
@export var target_lipides: bool = false

@export var effect_ripple: PackedScene = load("res://turrets/effects/effect_ripple.tscn")

var enabled_targets: Array
var fire_clock: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## On va chercher le signal chez le parent.
	if get_parent() is Turret:
		get_parent().pulse.connect(_on_pulse)
	else:
		print("Erreur: La node parent doit être de type Turret.")
		
	if fire_rate > 0.0:
		_setup_fire_clock()
		
	enabled_targets = _setup_targets()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pulse() -> void:
	match targeting_mode:
		"Aléatoire":
			pass
		#	print("hi")

func _on_fire_pulse() -> void:
	match targeting_mode:
		"Aléatoire":
			pass
		"Suivi":
			pass
		"Zone":
			_create_zone()

## Initialize une liste de cibles acceptées à partir des réglages de l'éditeur.
func _setup_targets() -> Array:
	var target_list: Array
	if target_cannettes:
		target_list.append("Cannette")
	if target_amidons:
		target_list.append("Amidons")
	if target_micropolluants:
		target_list.append("Micropolluants")
	if target_lipides:
		target_list.append("Lipides")
	return target_list

func _setup_fire_clock() -> void:
	fire_clock = Timer.new()
	fire_clock.wait_time = clampf(1 / fire_rate, 0.1, 8)
	fire_clock.timeout.connect(_on_fire_pulse)
	add_child(fire_clock)
	fire_clock.start()

func _create_zone() -> void:
	var ripple = effect_ripple.instantiate()
	#print("ripple out!")
	ripple.max_radius = 64
	ripple.expand_speed = 32
	ripple.inverted = true
	add_child(ripple)

func hit_target(body: Mob) -> void:
	print(body)
	if body.type in enabled_targets:
		print("hit " + str(body))
		body.hit(target_damage)
	else:
		pass
