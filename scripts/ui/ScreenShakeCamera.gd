class_name ScreenShakeCamera
extends Camera2D

@export var decay: float = 0.85 # Taxa de decaimento do tremor por segundo
@export var max_offset: Vector2 = Vector2(25, 20) # Deslocamento máximo em pixels
@export var max_roll: float = 0.05 # Rotação máxima em radianos

var trauma: float = 0.0 # Nível atual de impacto (0.0 a 1.0)
var trauma_power: int = 2
var noise := FastNoiseLite.new()
var noise_y: float = 0.0

func _ready() -> void:
	noise.seed = randi()
	noise.frequency = 0.8

func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)

func _process(delta: float) -> void:
	if trauma > 0.0:
		trauma = max(trauma - decay * delta, 0.0)
		_shake()
	else:
		offset = Vector2.ZERO
		rotation = 0.0

func _shake() -> void:
	var amount = pow(trauma, trauma_power)
	noise_y += 1.0
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed + 1, noise_y)
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed + 2, noise_y)
