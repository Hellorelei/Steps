extends Area2D
class_name TurretArea2D

## Les nodes TurretArea2D servent uniquement à notifier la tourelle parente de l'entrée et sortie
## des mobs dans la zone d'effet de la tourelle.

var parent_turret: Turret
var debug_area: CustomCircle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## On va chercher le signal chez le parent.
	if get_parent() is Turret:
		parent_turret = get_parent()
		parent_turret.pulse.connect(_on_pulse)
		parent_turret.enable_dampening.connect(_enable_dampening)
	else:
		print("Erreur: La node parent doit être de type Turret.")
	
	_setup_debug_area()
	
	## Connexiond des signaux.
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

## Activée lorsqu'une Node2D entre dans la TurretArea2D.
## On vérifie alors qu'il s'agisse bien d'un mob avant d'en avertir la tourelle
## parente.
func _on_body_entered(body: Node2D) -> void:
	print("turret_area: body entered: " + str(body))
	if body is Mob:
		parent_turret.add_enemy_in_zone(body)

## Activée lorsqu'une Node2D sort de la TurretArea2D.
## On vérifie alors qu'il s'agisse bien d'un mob avant d'en avertir la tourelle
## parente.
func _on_body_exited(body: Node2D) -> void:
	print("turret_area: body exited: " + str(body))
	if body is Mob:
		if body in parent_turret.enemies_in_zone:
			parent_turret.remove_enemy_in_zone(body)

## Chaque seconde, vérifie si la zone de débug devrait être affichée ou non.
func _on_pulse() -> void:
	if Global.debug and debug_area.visible == false:
		debug_area.visible = true
	elif Global.debug == false and debug_area.visible:
		debug_area.visible = false

## Active le dampening linéaire si demandé par TurretAreaEffect.
func _enable_dampening() -> void:
	linear_damp_space_override = 3
	linear_damp = 1.0
	
## Prépare un cercle visible affichant la zone d'effet de la tourelle à afficher si debug == true.
func _setup_debug_area() -> void:
	debug_area = CustomCircle.new()
	debug_area.radius = get_child(0).get_shape().radius
	add_child(debug_area)
	
