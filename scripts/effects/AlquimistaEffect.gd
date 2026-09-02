class_name AlquimistaEffect
extends TrecoEffect

func _init() -> void:
	item_name = "O Alquimista"
	description = "Poção Alquímica Rara: Transmuta a carta mais fraca da mão em uma Manilha de Ouros (♦) ou Espadas (♠). Custa toda a energia (3⚡)."
	energy_cost = 3
	rarity_weight = 1
	activation_window = ActivationWindow.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	var hand = match_manager.get_player_hand(activator_id)
	if hand.is_empty():
		return false
	
	var vira = match_manager.vira_card
	var manilha_rank = TrucoRules.get_manilha_rank_for_vira(vira.rank_value)
	
	# Encontra a carta mais fraca da mão para transmutar
	var weakest_card: CardData = hand[0]
	var min_str = TrucoRules.get_card_strength(weakest_card, vira)
	
	for card in hand:
		var s = TrucoRules.get_card_strength(card, vira)
		if s < min_str:
			min_str = s
			weakest_card = card
	
	# Transmuta para Manilha (70% Ouros, 30% Espadas - balanceado e temático!)
	weakest_card.rank_value = manilha_rank
	weakest_card.suit = CardData.Suit.OUROS if randf() < 0.7 else CardData.Suit.ESPADAS
	weakest_card.is_manilha = true
	
	match_manager.log_message.emit("⚗️ TRANSMUTAÇÃO! O Alquimista transformou uma carta em uma Manilha (%s)!" % weakest_card.to_string_short())
	return true
