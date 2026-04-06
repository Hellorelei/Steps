extends ProgressBar

## Barre de vie basée sur ProgressBar.
## Demande un parent qui émette un signal health_points_changed(health_value) pour afficher
## ses points de vie de manière dynamique.
class_name HealthBar

@export_color_no_alpha var health_bar_color: Color = Color(0.9, 0.2, 0.2, 1.0)
var parent_object: Object
var style = get_theme_stylebox("fill") as StyleBoxFlat

func _ready() -> void:
	value = 100
	show_percentage = false
	style.bg_color = health_bar_color
	## On récupère l'entité parente pour savoir quand ses points de vie changent.
	parent_object = get_parent()
	parent_object.health_points_changed.connect(_on_health_change)

## Met à jour la barre de vie lorsque les points de vie de l'entité parente changent.
func _on_health_change(health_value) -> void:
	value = health_value
