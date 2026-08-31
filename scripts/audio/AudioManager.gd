class_name AudioManager
extends Node

var table_hit_player: AudioStreamPlayer
var card_slide_player: AudioStreamPlayer
var potion_player: AudioStreamPlayer
var victory_player: AudioStreamPlayer
var click_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_players()

func _setup_audio_players() -> void:
	table_hit_player = AudioStreamPlayer.new()
	card_slide_player = AudioStreamPlayer.new()
	potion_player = AudioStreamPlayer.new()
	victory_player = AudioStreamPlayer.new()
	click_player = AudioStreamPlayer.new()
	
	add_child(table_hit_player)
	add_child(card_slide_player)
	add_child(potion_player)
	add_child(victory_player)
	add_child(click_player)
	
	table_hit_player.stream = _create_table_hit_sound()
	card_slide_player.stream = _create_card_slide_sound()
	potion_player.stream = _create_potion_sound()
	victory_player.stream = _create_victory_sound()
	click_player.stream = _create_click_sound()

func play_table_hit() -> void:
	if table_hit_player != null:
		table_hit_player.pitch_scale = randf_range(0.92, 1.08)
		table_hit_player.play()

func play_card_slide() -> void:
	if card_slide_player != null:
		card_slide_player.pitch_scale = randf_range(0.95, 1.1)
		card_slide_player.play()

func play_potion() -> void:
	if potion_player != null:
		potion_player.pitch_scale = randf_range(0.9, 1.1)
		potion_player.play()

func play_victory() -> void:
	if victory_player != null:
		victory_player.play()

func play_click() -> void:
	if click_player != null:
		click_player.pitch_scale = randf_range(0.98, 1.02)
		click_player.play()

# 44.1kHz 16-bit Sound Synthesizers
func _create_table_hit_sound() -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 0.35
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 22.0)
		var sub_freq = 65.0 * exp(-t * 15.0)
		var wood_body = sin(2.0 * PI * 130.0 * t) * 0.4 * exp(-t * 12.0)
		var mug_clack = (randf_range(-0.4, 0.4) * exp(-t * 80.0))
		var s = (sin(2.0 * PI * sub_freq * t) * 0.6 + wood_body + mug_clack) * env
		var sample_16 = int(clamp(s * 28000.0, -32768.0, 32767.0))
		buffer.encode_s16(i * 2, sample_16)
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _create_card_slide_sound() -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 0.18
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = sin(t / duration * PI)
		var noise = randf_range(-0.6, 0.6)
		var snap = sin(2.0 * PI * 400.0 * t) * 0.2 * exp(-t * 50.0)
		var s = (noise * 0.35 + snap) * env
		var sample_16 = int(clamp(s * 18000.0, -32768.0, 32767.0))
		buffer.encode_s16(i * 2, sample_16)
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _create_potion_sound() -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 0.45
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 5.5)
		var freq = 280.0 + sin(t * 40.0) * 140.0 + t * 500.0
		var sparkle = sin(2.0 * PI * 1200.0 * t) * 0.15 * exp(-t * 10.0)
		var s = (sin(2.0 * PI * freq * t) * 0.45 + sparkle) * env
		var sample_16 = int(clamp(s * 22000.0, -32768.0, 32767.0))
		buffer.encode_s16(i * 2, sample_16)
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _create_victory_sound() -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 0.9
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 2.2)
		var freq = 440.0 if t < 0.22 else (554.37 if t < 0.44 else (659.25 if t < 0.66 else 880.0))
		var s = (sin(2.0 * PI * freq * t) * 0.4 + sin(4.0 * PI * freq * t) * 0.2) * env
		var sample_16 = int(clamp(s * 24000.0, -32768.0, 32767.0))
		buffer.encode_s16(i * 2, sample_16)
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav

func _create_click_sound() -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 0.06
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	buffer.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t = float(i) / sample_rate
		var env = exp(-t * 80.0)
		var s = sin(2.0 * PI * 800.0 * t) * 0.4 * env
		var sample_16 = int(clamp(s * 15000.0, -32768.0, 32767.0))
		buffer.encode_s16(i * 2, sample_16)
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.data = buffer
	return wav
