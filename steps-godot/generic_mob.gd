extends RigidBody2D

var progress:float
var self_curve:Curve2D
@export var hp:int
@export var diameter:int
var is_caught: bool
var attraction:int
var captor_position: Vector2
var time_spent_in: int

# Called when the node enters the scene tree for the first time.
func _ready():
	#var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = "live"
	$AnimatedSprite2D.play()
	if self_curve:
		$Path2D.curve = self_curve
	print($Path2D/PathFollow2D.progress_ratio)
	progress = 0
	diameter = 10
	hp = 10
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var target_mob_location = $Path2D/PathFollow2D
	target_mob_location.progress_ratio = progress
	
	var dir_vector = target_mob_location.position - position
	var dir_captor = captor_position - global_position
	
	if not is_caught:
		apply_central_force(dir_vector)
		progress = progress + (delta/50)
	else:
		time_spent_in = time_spent_in + 1
		apply_central_force(
			dir_captor.normalized() * clamp(time_spent_in, 0, 100)
			)
	
	$DebugLine2D.points = PackedVector2Array([Vector2(0, 0), linear_velocity])
	
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func hit(dmg: int = 1, dot: bool = false) -> void:
	hp = hp - dmg
	# Flashes the sprite red to indicate damage was taken
	$AnimatedSprite2D.self_modulate = Color(1, 0.2, 0.2, 1)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)
	print("bonk!")
	
	if hp <= 0:
		queue_free()
		print("pop!")
		
	# Re-applies damage if it is damage over time
	if dot:
		await get_tree().create_timer(1).timeout
		if is_caught:
			hit(dmg, true)

func caught(in_captor_position: Vector2, captor_type: String) -> void:
	is_caught = true
	print("——————————caught!")
	captor_position = in_captor_position
	print(captor_type)
	if captor_type == "generic":
		await get_tree().create_timer(1).timeout
		hit(2, true)

func release() -> void:
	is_caught = false
	add_constant_central_force(Vector2(0, 0))
	time_spent_in = 0
