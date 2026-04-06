extends RigidBody2D

############# PROPRIÉTÉS DU MOB ####################################################################
## Points de vie du mob.
@export var hp:int
## Diamètre du mob (pour les filtres).
@export var diameter:int
## Compteur pour les frames d'invincibilité après un coup.
var invincibility_frame_counter: int
## Stocke la variable gravity_scale par défaut pour pouvoir la réinitialiser après changements.
var stored_gravity_scale: float


################ PROCESSUS DE BASE #################################################################

## Appelé lors de l'instanciation du mob.
func _ready():
	$AnimatedSprite2D.animation = "live" # Sélectionne l'animation "live" (par défaut)
	$AnimatedSprite2D.play() # Active l'animation sélectionnée
	diameter = 10 # Son diamètre par défaut est de 10
	hp = 10 # Ses points de vie par défaut sont de 10
	can_sleep = false # Fait que la simulation physique reste active même si le mob ne bouge plus.
	stored_gravity_scale = gravity_scale # Sauve la variable pour pouvoir la réinitialiser au besoin.


## Appelé à chaque frame à partir du moment ou le mob est instancé et ajouté à la scène.
func _process(delta: float) -> void:
	
	# On soustrait le temps passé chaque frame au compteur, tout en l'empêchant d'aller < 0.
	invincibility_frame_counter = clampf(invincibility_frame_counter - delta, 0, 1000000000)

## Delete le monstre si il sort de l'écran (pas sûre que ça marche en l'état)
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	

################ GESTION VIE ET DÉGATS #############################################################

## Applique un filtre rouge pendant le temps time au sprite pour marquer des dégâts reçus.
func hit_effect(time:float = 0.2):
	$AnimatedSprite2D.self_modulate = Color(1, 0.2, 0.2, 1)
	await get_tree().create_timer(time).timeout
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)

## Applique les dégâts dmg au monstre, les répête si dot: true.
## Vérifie d'abord que le monstre ne soit pas encore invulnérable du dernier
## coup avant d'appliquer les dégâts.
## Retire le monstre du jeu si les points de vie = 0.
func hit(dmg: int = 1, dot: bool = false) -> void:
	if dot == false && is_in_invincibility_frame(): # Vérifie l'invincibilité (ignoré si DOT)
		return # Si oui: on arrête.
	else:
		if dot == false: # Ne s'applique pas aux DOT.
			reset_invincibility_frame_counter() # Comme le monstre est frappé, reset du compteur.
		hp = clamp(hp - dmg, 0, 1000000000) # Application des dégats avec minimum à 0.
		hit_effect() # Applique l'effet visuel pour les dégats. 
		if hp <= 0: # Retire le mob si hp =< 0.
			queue_free()
		
		# Ré-applique les dégats si les dégats sont de type damage over time.
		if dot:
			await get_tree().create_timer(1.2).timeout
			hit(dmg, dot)
	
## Est-ce que le mob est en frame d'invincibilité?
func is_in_invincibility_frame() -> bool:
	if invincibility_frame_counter > 0:
		return true
	else:
		return false

## Reset le compteur de frames d'invincibilité.
func reset_invincibility_frame_counter() -> void:
	invincibility_frame_counter = 1 # Temps d'invincibilité après un coup (s)

####################################################################################################


## Pour réinitialiser la gravity_scale du mob.
func gravity_scale_reset():
	gravity_scale = stored_gravity_scale

## Marque la gravity_scale comme valeur scale reçue.
func gravity_scale_float(scale):
	gravity_scale = scale
