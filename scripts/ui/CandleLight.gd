class_name CandleLight
extends PointLight2D

@export var min_energy: float = 0.9
@export var max_energy: float = 1.3
@export var flicker_speed: float = 8.0

var noise := FastNoiseLite.new()
var time: float = 0.0

func _ready() -> void:
	color = Color("ffaa44") # Luz quente de taverna
	noise.seed = randi()
	noise.frequency = 0.5

func _process(delta: float) -> void:
	time += delta * flicker_speed
	var noise_val = (noise.get_noise_1d(time) + 1.0) / 2.0
	energy = lerp(min_energy, max_energy, noise_val)
