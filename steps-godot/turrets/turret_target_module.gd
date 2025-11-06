extends Node
class_name TurretTargetModule

@export_enum("Aléatoire", "Suivi") var targeting_mode: String = "Aléatoire"

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
