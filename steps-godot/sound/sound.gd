extends Node

## Ce script est un Global qui permet de jouer des sons.

var named_sounds = {
	'ui_button_ahead' = preload("res://sound/sound_resources/ui_tap_1.wav") as AudioStream,
	'ui_button_back' = preload("res://sound/sound_resources/ui_tap_2.wav") as AudioStream,
	'ui_button_start' = preload("res://sound/sound_resources/ui_start_1.wav") as AudioStream,
	'ui_button_toggle' = preload("res://sound/sound_resources/ui_switch_3.wav") as AudioStream,
	'ui_victory' = preload("res://sound/sound_resources/ui_victory_1.wav") as AudioStream,
	'ui_defeat' = preload("res://sound/sound_resources/ui_defeat_1.wav") as AudioStream,
	'mob_can_1' = preload("res://sound/sound_resources/mob_can_1.wav") as AudioStream,
	'mob_mud_1' = preload("res://sound/sound_resources/mob_mud_1.wav") as AudioStream,
	'mob_lipid_1' = preload("res://sound/sound_resources/mob_lipid_1.wav") as AudioStream,
	'mob_micro_1' = preload("res://sound/sound_resources/mob_micro_1.wav") as AudioStream,
}

var fx_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_fx_player()
	play('ui_button_ahead')
	

## Joue un son sound_name présent dans le dictionnaire named_sounds. 
func play(sound_name: String, pitch_adjust: bool = true, volume_adjust = 1.0) -> void:
	print("playing:" + str(sound_name)) # TODO: DELETE DEBUG STATEMENT.
	# On vérifie que le son désiré existe dans la liste.
	if sound_name in named_sounds:
		
		if !fx_player.playing: fx_player.play()
		 
		# Si permis, on ajuste le ton d'un facteur entre zéro et deux pour garantir
		# de la diversité et éviter une répétition fatiguante.
		if pitch_adjust: 
			fx_player.pitch_scale = randf() * 2.0
		else:
			print("nopitch")
			fx_player.pitch_scale = 1.0  # Sinon, on remet le son à son ton par défaut.
		print(fx_player.pitch_scale) # TODO: DELETE DEBUG STATEMENT.
		fx_player.volume_linear = volume_adjust
		if Global.sound_enabled:
			fx_player.get_stream_playback().play_stream(named_sounds.get(sound_name))

	else:
		printerr("Erreur: le son " + sound_name + " n'a pas été trouvé dans named_sounds.")


## Prépare la node qui jouera les effets sonores. 
func _setup_fx_player() -> void:
	fx_player = $FXAudioStreamPlayer
	fx_player.max_polyphony = 64
	fx_player.stream = AudioStreamPolyphonic.new()
	
	
