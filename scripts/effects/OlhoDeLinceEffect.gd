class_name OlhoDeLinceEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Olho de Lince"
	description = "Revela uma carta aleatória da mão do oponente."
	energy_cost = 1
	activation_window = ActivationWindow.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	var opponent_id = 1 if activator_id == 0 else 0
	if match_manager.is_player_protected_from_spying(opponent_id):
		return false
	var opponent_hand = match_manager.get_player_hand(opponent_id)
	var unrevealed: Array[CardData] = []
	for card in opponent_hand:
		if not card.is_revealed:
			unrevealed.append(card)
	if unrevealed.is_empty():
		return false
	unrevealed.shuffle()
	unrevealed[0].is_revealed = true
	return true
