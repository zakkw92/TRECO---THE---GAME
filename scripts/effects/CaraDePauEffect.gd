class_name CaraDePauEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Cara de Pau"
	description = "Blefe Visual: Permite jogar uma carta virada para baixo (oculta até a resolução da vaza)."
	energy_cost = 2
	activation_window = ActivationWindow.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	match_manager.face_down_buff[activator_id] = true
	return true
