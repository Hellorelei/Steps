## Cette node permet d'afficher une droite représentant les forces appliquées
## sur le mob parent lorsque le mode débug est activé.

extends Node
class_name MobDebug

var debug_line: Object
var parent_mob: Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_line = Line2D.new()
	debug_line.default_color = Color(1, 0.6, 0, 0.6)
	add_child(debug_line)
	parent_mob = get_parent()

# Affiche une droite représentant les forces appliquées sur le mob parent.
func _process(delta: float) -> void:
	debug_line.points = PackedVector2Array(
		[parent_mob.global_position, parent_mob.global_position + parent_mob.linear_velocity]
		)
	
	if Global.debug == true && debug_line.visible == false:
		debug_line.visible = true
		#$TargetPolygon2D.visible = true
	if Global.debug == false && debug_line.visible == true:
		debug_line.visible = false
		#$TargetPolygon2D.visible = false
