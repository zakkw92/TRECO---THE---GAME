class_name AudioManager
extends Node

# Sons sintéticos em tempo real sem depender de arquivos externos pesados
var table_hit_player: AudioStreamPlayer
var card_slide_player: AudioStreamPlayer
var potion_player: AudioStreamPlayer
var victory_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_players()

func _setup_audio_players() -> void:
	table_hit_player = AudioStreamPlayer.new()
	card_slide_player = AudioStreamPlayer.new()
	potion_player = AudioStreamPlayer.new()
	victory_player = AudioStreamPlayer.new()
	
	add_child(table_hit_player)
	add_child(card_slide_player)
	add_child(potion_player)
	add_child(victory_player)
	
	table_hit_player.stream = _generate_table_hit_stream()
	card_slide_player.stream = _generate_card_slide_stream()
	potion_player.stream = _generate_potion_stream()
	victory_player.stream = _generate_victory_stream()

func play_table_hit() -> void:
	if table_hit_player != null:
		table_hit_player.pitch_scale = randf_range(0.9, 1.1)
		table_hit_player.play()

func play_card_slide() -> void:
	if card_slide_player != null:
		card_slide_player.pitch_scale = randf_range(0.95, 1.15)
		card_slide_player.play()

func play_potion() -> void:
	if potion_player != null:
		potion_player.pitch_scale = randf_range(0.9, 1.1)
		potion_player.play()

func play_victory() -> void:
	if victory_player != null:
		victory_player.play()

# Geradores de amostras de áudio procedurais
func _generate_table_hit_stream() -> AudioStreamWAV:
	var sample_rate = 22050
	var duration = 0.3
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 18.0)
		var freq = 90.0 * exp(-t * 12.0)
		var noise = randf_range(-0.3, 0.3)
		var sample = (sin(2.0 * PI * freq * t) * 0.7 + noise * 0.3) * env
		var byte_val = int(clamp((sample + 1.0) * 127.5, 0.0, 255.0))
		buffer[i] = byte_val
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_8_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _generate_card_slide_stream() -> AudioStreamWAV:
	var sample_rate = 22050
	var duration = 0.15
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = sin(t / duration * PI)
		var noise = randf_range(-0.5, 0.5)
		var sample = noise * env * 0.4
		var byte_val = int(clamp((sample + 1.0) * 127.5, 0.0, 255.0))
		buffer[i] = byte_val
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_8_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _generate_potion_stream() -> AudioStreamWAV:
	var sample_rate = 22050
	var duration = 0.4
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 6.0)
		var freq = 300.0 + sin(t * 35.0) * 150.0 + t * 400.0
		var sample = sin(2.0 * PI * freq * t) * env * 0.5
		var byte_val = int(clamp((sample + 1.0) * 127.5, 0.0, 255.0))
		buffer[i] = byte_val
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_8_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _generate_victory_stream() -> AudioStreamWAV:
	var sample_rate = 22050
	var duration = 0.8
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 2.5)
		var freq = 440.0 if t < 0.2 else (554.37 if t < 0.4 else (659.25 if t < 0.6 else 880.0))
		var sample = sin(2.0 * PI * freq * t) * env * 0.5
		var byte_val = int(clamp((sample + 1.0) * 127.5, 0.0, 255.0))
		buffer[i] = byte_val
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_8_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav
