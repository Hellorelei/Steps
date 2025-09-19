extends RigidBody2D

############# Propriétés du mob
## Points de vie du mob
@export var hp:int
## Diamètre du mob (pour les filtres)
@export var diameter:int
## Vitesse du mob lorsque libre
@export var speed:int

############# Chemin du mob
## Emplacement du mob le long de son chemin théorique, en % de 1
var progress:float
## Si fourni avant instanciation, remplace le $Path2D interne par celui de la propriété
## self_curve.
var self_curve:Curve2D

############# Positions et facteurs sur les vecteurs du mob
## Chemin théorique du mob
var target_mob_location: PathFollow2D
var movement_path: PathFollow2D
## Est-ce que le mob est capturé par une tourelle?
var is_caught: bool 
## Emplacement de la tourelle ayant capturé le mob
var captor_position: Vector2
## Temps passé capturé par une tourelle
var time_spent_in: int 

@export var mob_distance_to_target_debug:float

############# Forces appliquées au mob
# Les forces sont appliquées en plus de celles de base à chaque frame physique.
# On ne remplace pas les forces inhérentes pour respecter le moteur physique et ses
# fonctions (notamment, collisions).
## Vecteur du mob lorsque libre: position cible - position actuelle
var dir_vector: Vector2
## Vecteur du mob lorsque capturé: position tourelle - position actuelle
var dir_captor: Vector2

## Appelé lors de l'instanciation du mob.
func _ready():
	$AnimatedSprite2D.animation = "live" # Sélectionne l'animation "live" (par défaut)
	$AnimatedSprite2D.play() # Active l'animation sélectionnée
	if self_curve:
		$Node/Path2D.curve = self_curve # Update le chemin interne du mob.
	print($Node/Path2D/PathFollow2D.progress_ratio) # DEBUG
	progress = 0 # Le mob commence au début de son chemin
	diameter = 10 # Son diamètre par défaut est de 10
	hp = 10 # Ses points de vie par défaut sont de 10
	speed = 2 # Sa vitesse par défaut est de 1.
	target_mob_location = $Node/Path2D/PathFollow2D # Son but est son $PathFollow2D
	movement_path = $Node/Path2D/PathFollow2D
	

## Appelé à chaque frame à partir du moment ou le mob est instancé et ajouté à la scène.
func _process(delta: float) -> void:
	
	mob_movement(delta)
	
	#movement_path.progress_ratio = progress
	#var mob_distance_to_target = position.distance_to(movement_path.position)
	#mob_distance_to_target_debug = mob_distance_to_target
	# print("distance: " + str(mob_distance_to_target))
	#if mob_distance_to_target < 64:
	#	progress = progress + 0.0005
	
	# On update le point cible le long du chemin au pourcentage égal à progress/1
	#target_mob_location.progress_ratio = progress
	
	# Le vecteur vers ce point devient donc la position cible - la position actuelle du monstre
	#dir_vector = target_mob_location.position - position
	
	# Le vecteur en cas de capture doit être calculé à partir de positions globales et non pas
	# relatives (vu que la tourelle se sait être en (0, 0) par rapport à elle-même et vice-versa. 
	#dir_captor = captor_position - global_position
	
	# normalized vector * (1 + speed factor + distance effect)
	# pause movement of target point if monster is too far
	# move target every 0.2 seconds rather than every frame?
	
	# Si le monstre n'est pas capturé
	#if not is_caught:
		# On lui applique une force équvaliente au vecteur le dirigeant vers sa cible
	#	apply_central_force(dir_vector.normalized() * (1 + speed/10 + dir_vector.distance_to(target_mob_location.position)/50))# * speed)
		# On incrémente la distance le point cible à suivre
		#progress = progress +  # (delta/50) # + speed
		# print("prog:" + str(progress))
	#else:
	#	time_spent_in = time_spent_in + 1
	#	apply_central_force(
	#		dir_captor.normalized() * clamp(time_spent_in, 0, 100)
	#		)
	
	# Affiche une ligne blanche équivalente aux forces appliquées au monstre
	$Node/DebugLine2D.points = PackedVector2Array([global_position, global_position + linear_velocity])
	
	# Affiche la cible actuelle du mob
	$TargetPolygon2D.global_position = target_mob_location.global_position


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Delete le monstre si il sort de l'écran (pas sûre que ça marche en l'état)
	queue_free()

func mob_movement(delta) -> void:
	
	movement_path.progress_ratio = progress
	var mob_distance_to_target = global_position.distance_to(movement_path.global_position)
	print(mob_distance_to_target)
	if mob_distance_to_target < 100:
		progress = progress + (0.005 * delta * 10) # TODO: add speed
	
	dir_vector = global_position.direction_to(movement_path.global_position)
	
	dir_captor = global_position.direction_to(captor_position)
	
	var cus_force = Vector2(0, 0)
	if not is_caught:
		cus_force = dir_vector.normalized() * 30
	else:
		time_spent_in = time_spent_in + 1
		cus_force = dir_captor.normalized() * clamp(time_spent_in, 0, 100)
	apply_central_force(cus_force)

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
		
	# Ré-applique les dégats si les dégats sont de type damage over time
	if dot:
		await get_tree().create_timer(1).timeout
		# Vérifie que le monstre est toujours capturé avant d'appliquer les dégâts
		if is_caught:
			hit(dmg, true)

func caught(in_captor_position: Vector2, captor_type: String) -> void:
	# Appelé lorsqu'un monstre est capturé par une tourelle:
	# marque is_caught comme true, et enregistre le type de tourelle + sa position
	is_caught = true
	print("——————————caught!")
	captor_position = in_captor_position
	print(captor_type)
	if captor_type == "generic":
		# Exemple 
		await get_tree().create_timer(1).timeout
		# On applique 2 dégâts et on note de les répéter dans le temps
		hit(2, true)

func release() -> void:
	# Appelé lorsque le monstre est relâché par une tourelle ou qu'il sort de sa zone d'effet.
	# On reset la force centrale constante pour que ça n'affecte plus la trajectoire.
	is_caught = false
	add_constant_central_force(Vector2(0, 0))
	time_spent_in = 0
