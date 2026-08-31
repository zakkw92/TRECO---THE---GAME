class_name OlhoDeLinceEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Olho de Lince"
	description = "Revela uma carta aleatória da mão do oponente."
	energy_cost = 1
	activation_window = Window.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	var opponent_id = 1 if activator_id == 0 else 0
	
	# Verifica se o oponente está protegido pela Fumaça de Taverna
	if match_manager.is_player_protected_from_spying(opponent_id):
		print("[TRECO] Olho de Lince falhou! O Jogador %d está protegido por Fumaça de Taverna." % opponent_id)
		return false
		
	var opponent_hand = match_manager.get_player_hand(opponent_id)
	var unrevealed_cards: Array[CardData] = []
	
	for card in opponent_hand:
		if not card.is_revealed:
			unrevealed_cards.append(card)
			
	if unrevealed_cards.is_empty():
		print("[TRECO] Olho de Lince: Todas as cartas do oponente já estão visíveis.")
		return false
		
	unrevealed_cards.shuffle()
	var target_card = unrevealed_cards[0]
	target_card.is_revealed = true
	print("[TRECO] Olho de Lince Sucesso! Revelou: %s do Jogador %d" % [target_card.to_string_short(), opponent_id])
	return true
