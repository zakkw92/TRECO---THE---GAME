class_name CandleLight
extends PointLight2D

var base_energy: float = 1.2
var noise_speed: float = 4.0
var time_passed: float = 0.0

func _ready() -> void:
	base_energy = energy

func _process(delta: float) -> void:
	time_passed += delta * noise_speed
	var flicker = sin(time_passed) * 0.15 + sin(time_passed * 2.3) * 0.08 + randf_range(-0.04, 0.04)
	energy = base_energy + flicker
