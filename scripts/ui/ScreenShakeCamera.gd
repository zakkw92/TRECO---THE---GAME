class_name ScreenShakeCamera
extends Camera2D

var trauma: float = 0.0
var max_offset: float = 24.0
var max_roll: float = 0.08
var trauma_decay: float = 1.4

var time_passed: float = 0.0
var initial_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	initial_offset = offset

func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)

func _process(delta: float) -> void:
	if trauma > 0.0:
		time_passed += delta * 50.0
		var shake_power = trauma * trauma
		var noise_x = sin(time_passed * 1.2) * randf_range(0.8, 1.2)
		var noise_y = cos(time_passed * 1.5) * randf_range(0.8, 1.2)
		var noise_rot = sin(time_passed * 2.0) * randf_range(0.8, 1.2)
		
		offset = initial_offset + Vector2(noise_x * max_offset * shake_power, noise_y * max_offset * shake_power)
		rotation = noise_rot * max_roll * shake_power
		
		trauma = max(0.0, trauma - trauma_decay * delta)
	else:
		offset = initial_offset
		rotation = 0.0
