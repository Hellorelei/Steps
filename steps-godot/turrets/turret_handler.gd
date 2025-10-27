extends Node2D

@export var generic_turret: PackedScene
@export var grate_turret: PackedScene

var turret_buttons: Array
var delete_button: Array
var last_base_press: float
var game_time: float
var turret_selected: String
var built_turret: Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("▎ turret handler called!")
	game_time = 0
	turret_selected = "empty"
	turret_buttons = [
		$AddTurret1Button1, $AddTurret1Button2, $AddTurret1Button3,
		$AddTurret1Button4
		]
	delete_button = [
		$DeleteTurretButton
	]
	for button in turret_buttons:
		button.visible = 0
	for button in delete_button:
		button.visible = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	built_turret.delete()
	set_turret("empty")
	button_toggle(delete_button, 0)
	pass # Replace with function body.

func set_turret(turret:String):
	turret_selected = turret
	if turret == "1":
		built_turret = grate_turret.instantiate()
		# A 0, 0 vector puts the turret right atop the button.
		built_turret.position = Vector2(0, 0)
		print($BaseButton.position)
		print(position)
		add_child(built_turret)
		pass
