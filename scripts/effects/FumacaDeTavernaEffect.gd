class_name FumacaDeTavernaEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Fumaça de Taverna"
	description = "Protege suas cartas contra efeitos de espionagem do oponente até o fim da rodada."
	energy_cost = 1
	activation_window = Window.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	match_manager.set_player_spying_protection(activator_id, true)
	print("[TRECO] Fumaça de Taverna ativada! Jogador %d agora está protegido contra espionagem." % activator_id)
	return true
