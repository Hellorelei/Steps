extends ProgressBar

class_name HealthBar
var parent_object: Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_object = get_parent()
	parent_object.health_change.connect(_on_health_change)
	value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#value -= 1
	#if value <= 0:
#		value = 100
	pass

func _on_health_change(health_value) -> void:
	value = health_value
