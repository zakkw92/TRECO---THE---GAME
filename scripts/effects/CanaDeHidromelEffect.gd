class_name CanaDeHidromelEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Cana de Hidromel"
	description = "Distração de Taverna: Anula a manilha jogada pelo adversário na vaza atual."
	energy_cost = 2
	activation_window = ActivationWindow.REACTION

func apply_effect(match_manager, activator_id: int) -> bool:
	var opponent_id = 1 if activator_id == 0 else 0
	var opp_card: CardData = match_manager.played_cards[opponent_id]
	if opp_card == null:
		return false
	opp_card.is_manilha = false
	return true
