extends Node2D

## TODO: Cleanup button auto hide by having a better timer and/or hover detection.

@export var generic_turret: PackedScene
#@export var grate_turret: PackedScene
@export var _test_grate_turret: PackedScene = load("res://turrets/_test_grate_turret.tscn")

# Liste des boutons pour ajouter une tourelle.
var turret_buttons: Array
# Liste du bouton pour effacer une tourelle.
var delete_button: Array
# Moment où la base a été pressée pour la dernière fois.
var last_base_press: float
# Moment actuel.
var game_time: float
# Tourelle actuellement placée sur la base, "empty" si vide.
var turret_selected: String
# Objet tourelle posé sur la base, on le stocke pour pouvoir appeler delete(). 
var built_turret: Object

## Appelé lorsque l'objet entre dans l'arbre de la scène la première fois.
## Initialise les variables et boutons. 
func _ready() -> void:
	print("▎ turret handler called!")
	game_time = 0
	# Il n'y a pas encore de tourelle → "empty".
	turret_selected = "empty"
	# On stocke les boutons dans des listes.
	turret_buttons = [
		$AddTurret1Button1, $AddTurret1Button2, $AddTurret1Button3,
		$AddTurret1Button4
		]
	delete_button = [
		$DeleteTurretButton
	]
	# Et on confirme qu'ils sont actuellement invisibles.
	for button in turret_buttons:
		button.visible = 0
	for button in delete_button:
		button.visible = 0


# Appelé à chaque frame: delta est le temps écoulé depuis la frame précédente.
func _process(delta: float) -> void:
	game_time = game_time + delta

func button_flyout(buttons: Array):
	button_toggle(buttons, 1)
	await get_tree().create_timer(5.5).timeout
	# Checking if five seconds have elapsed since last
	# registered button press: if yes, hide buttons.
	if game_time - last_base_press > 5:
		button_toggle(buttons, 0)

func button_toggle(buttons: Array, value: bool) -> void:
	for button in buttons:
		button.visible = value

func _on_base_button_button_down() -> void:
	print("▎ turret handler button down called!")
	last_base_press = game_time
	if turret_selected == "empty":
		button_flyout(turret_buttons)
	else:
		button_flyout(delete_button)


func _on_add_turret_1_button_1_button_down() -> void:
	set_turret("1")
	button_toggle(turret_buttons, 0)
	pass # Replace with function body.
	
func _on_delete_turret_button_button_down() -> void:
	#built_turret.delete()
	set_turret("empty")
	button_toggle(delete_button, 0)
	pass # Replace with function body.

func set_turret(turret:String):
	turret_selected = turret
	match turret:
		"empty":
			built_turret.delete()
		"1":
			built_turret = _test_grate_turret.instantiate()
		#"2":
		#	built_turret = generic_turret_oxy.instantiate()
	built_turret.position = Vector2(0, 0)
	add_child(built_turret)
