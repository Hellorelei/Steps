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
	$AnimatedSprite2D.animation = "live" #sélectionner l'animation "live" par défaut
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
	$Node/DebugLine2D.points = PackedVector2Array([global_position, global_position + linear_velocity])

	# Affiche la cible actuelle du mob
	$TargetPolygon2D.global_position = target_mob_location.global_position	
	
	# Affiche une ligne blanche équivalente aux forces appliquées au monstre
	if Global.debug:
		$Node/DebugLine2D.visible = true
		$TargetPolygon2D.visible = true
		print("trubug")
	else:
		$Node/DebugLine2D.visible = false
		$TargetPolygon2D.visible = false
		print("falbug")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Delete le monstre si il sort de l'écran (pas sûre que ça marche en l'état)
	self.remove_from_group("enemy_group")
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
