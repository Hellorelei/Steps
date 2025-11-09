extends Node
class_name TurretTargetModule

@export_enum("Aléatoire", "Suivi") var targeting_mode: String = "Aléatoire"
@export var target_cannettes: bool = false
@export var target_amidons: bool = false
@export var target_micropolluants: bool = false
@export var target_lipides: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## On va chercher le signal chez le parent.
	if get_parent() is Turret:
		get_parent().pulse.connect(_on_pulse)
	else:
		print("Erreur: La node parent doit être de type Turret.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pulse() -> void:
	match targeting_mode:
		"Aléatoire":
			pass
		#	print("hi")

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
