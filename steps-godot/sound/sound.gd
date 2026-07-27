extends Node
## Ce script est un Global qui permet de jouer des sons.

var named_sounds = {
	'ui_button_ahead' = preload("res://sound/sound_resources/ui_tap_1.wav") as AudioStream,
	'ui_button_back' = preload("res://sound/sound_resources/ui_tap_2.wav") as AudioStream,
	'ui_button_start' = preload("res://sound/sound_resources/ui_start_1.wav") as AudioStream,
	'ui_button_start_2' = preload("res://sound/sound_resources/ui_start_2.wav") as AudioStream,
	'ui_button_toggle' = preload("res://sound/sound_resources/ui_switch_3.wav") as AudioStream,
	'ui_victory' = preload("res://sound/sound_resources/ui_victory_1.wav") as AudioStream,
	'ui_defeat' = preload("res://sound/sound_resources/ui_defeat_1.wav") as AudioStream,
	'mob_can_1' = preload("res://sound/sound_resources/mob_can_1.wav") as AudioStream,
	'mob_mud_1' = preload("res://sound/sound_resources/mob_mud_1.wav") as AudioStream,
	'mob_lipid_1' = preload("res://sound/sound_resources/mob_lipid_1.wav") as AudioStream,
	'mob_micro_1' = preload("res://sound/sound_resources/mob_micro_1.wav") as AudioStream,
}

var named_bg_sounds = {
	'bg_waves_1' = preload("res://sound/sound_resources/bg_waves_1.mp3") as AudioStream,
	'bg_forest_1' = preload("res://sound/sound_resources/bg_forest_1.mp3") as AudioStream,
}

var fx_player: AudioStreamPlayer
var bg_player: AudioStreamPlayer
var bg_ease_f: float  # Ajustement progressif du volume du son de fond.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_fx_player()


## Joue un son sound_name présent dans le dictionnaire named_sounds. 
func play(sound_name: String, pitch_adjust: bool = true, volume_adjust = 1.0) -> void:
	# On vérifie que le son désiré existe dans la liste.
	if sound_name in named_sounds:
		if !fx_player.playing: 
			fx_player.play()
		 
		# Si permis, on ajuste le ton d'un facteur entre zéro et deux pour garantir
		# de la diversité et éviter une répétition fatiguante.
		if pitch_adjust: 
			fx_player.pitch_scale = randf() * 1.5
		else:
			fx_player.pitch_scale = 1.0  # Sinon, on remet le son à son ton par défaut.
		
		fx_player.volume_linear = volume_adjust
		if Global.sound_enabled:
			fx_player.get_stream_playback().play_stream(named_sounds.get(sound_name))

	else:
		printerr("Le son " + sound_name + " n'a pas été trouvé dans named_sounds.")


## Joue un sound_name comme son de fond.
func play_bg(sound_name: String, volume_adjust = 1.0, random_start = false) -> void:
	var starting_pos = 0.0
	if sound_name in named_bg_sounds:	
		if Global.sound_enabled:
			bg_player.stream = named_bg_sounds.get(sound_name)
		if random_start:
			starting_pos = randf_range(0.0, bg_player.stream.get_length())
		bg_player.play(starting_pos)
		_bg_ease(volume_adjust)
		
	else:
		printerr("Le son " + sound_name + " n'a pas été trouvé dans named_bg_sounds.")


## Montée progressive du volume.
func _bg_ease(volume_adjust) -> void:
	bg_ease_f = 0.0
	while bg_ease_f <= volume_adjust * 10:
		bg_player.volume_linear = bg_ease_f / 10
		bg_ease_f += 0.2
		await get_tree().create_timer(0.2).timeout
		bg_player.volume_linear = volume_adjust


## Prépare la node qui jouera les effets sonores. 
func _setup_fx_player() -> void:
	fx_player = $FXAudioStreamPlayer
	fx_player.max_polyphony = 64
	fx_player.stream = AudioStreamPolyphonic.new()
	
	bg_player = $BGAudioStreamPlayer
	bg_ease_f = 0.0
