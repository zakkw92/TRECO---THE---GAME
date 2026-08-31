class_name FumacaDeTavernaEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Fumaça de Taverna"
	description = "Contra-Espionagem: Esconde suas cartas de qualquer revelação do oponente nesta rodada."
	energy_cost = 1
	activation_window = ActivationWindow.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	match_manager.set_player_spying_protection(activator_id, true)
	return true
