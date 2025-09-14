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
	
	#print(progress)
	var target_mob_location = $Path2D/PathFollow2D
	target_mob_location.progress_ratio = progress
	#print("pos" + str(mob_location.position))
	#print("pro" + str(mob_location.progress_ratio))
	
	## position = mob_location.position
	
	var dir_vector = target_mob_location.position - position
	#var dir_vector_x = target_mob_location.position.x - position.x
	#var dir_vector_y = target_mob_location.position.y - position.y
	#print("gpos: " + str(global_position))
	#print("cpos: " + str(captor_position))
	var dir_captor = captor_position - global_position
	#var dir_vector = Vector2(dir_vector_x, dir_vector_y)
	
	if not is_caught:
		apply_central_force(dir_vector)
		progress = progress + (delta/50)
	else:
		time_spent_in = time_spent_in + 1
		apply_central_force(
			dir_captor.normalized() * clamp(time_spent_in, 0, 100)
			)
		# hp = hp - 1
	if hp < 0:
		pass
		# queue_free()
	
	$DebugLine2D.points = PackedVector2Array([Vector2(0, 0), linear_velocity])
	#print(dir_vector_x)
	#print(dir_vector_y)
	
	#print(progress)
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func hit(dmg) -> void:
	pass
	# hp = hp - dmg
	# if hp <= 0:
	#	queue_free()
	#	print("pop!")

func caught(in_captor_position: Vector2) -> void:
	is_caught = true
	print("——————————caught!")
	captor_position = in_captor_position
	#add_constant_central_force(captor_position)

func release() -> void:
	is_caught = false
	add_constant_central_force(Vector2(0, 0))
	time_spent_in = 0
