class_name AudioManager
extends Node

var table_hit_player: AudioStreamPlayer
var card_slide_player: AudioStreamPlayer
var potion_player: AudioStreamPlayer
var victory_player: AudioStreamPlayer
var click_player: AudioStreamPlayer
var truco_slam_player: AudioStreamPlayer

const SOUND_PATHS = {
	"table_hit": "res://assets/audio/table_hit.wav",
	"card_slide": "res://assets/audio/card_slide.wav",
	"potion": "res://assets/audio/potion_bubble.wav",
	"truco_slam": "res://assets/audio/truco_slam.wav",
	"victory": "res://assets/audio/victory_chime.wav",
	"click": "res://assets/audio/click_tactile.wav"
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_players()

func _setup_audio_players() -> void:
	table_hit_player = _create_player("table_hit", -2.0)
	card_slide_player = _create_player("card_slide", -1.0)
	potion_player = _create_player("potion", 0.0)
	truco_slam_player = _create_player("truco_slam", 2.0)
	victory_player = _create_player("victory", 1.0)
	click_player = _create_player("click", -4.0)

func _create_player(sound_key: String, volume_db: float = 0.0) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.volume_db = volume_db
	add_child(player)
	
	var path = SOUND_PATHS.get(sound_key, "")
	if ResourceLoader.exists(path):
		player.stream = load(path)
	return player

func play_table_hit() -> void:
	if table_hit_player != null and table_hit_player.stream != null:
		table_hit_player.pitch_scale = randf_range(0.92, 1.08)
		table_hit_player.play()

func play_card_slide() -> void:
	if card_slide_player != null and card_slide_player.stream != null:
		card_slide_player.pitch_scale = randf_range(0.95, 1.12)
		card_slide_player.play()

func play_potion() -> void:
	if potion_player != null and potion_player.stream != null:
		potion_player.pitch_scale = randf_range(0.90, 1.10)
		potion_player.play()

func play_truco_slam() -> void:
	if truco_slam_player != null and truco_slam_player.stream != null:
		truco_slam_player.pitch_scale = randf_range(0.94, 1.04)
		truco_slam_player.play()

func play_victory() -> void:
	if victory_player != null and victory_player.stream != null:
		victory_player.play()

func play_click() -> void:
	if click_player != null and click_player.stream != null:
		click_player.pitch_scale = randf_range(0.96, 1.04)
		click_player.play()
