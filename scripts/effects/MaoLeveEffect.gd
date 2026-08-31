class_name MaoLeveEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Mão Leve"
	description = "Batedor de Carteira: Rouba a carta mais fraca da mão do oponente."
	energy_cost = 2
	activation_window = Window.REACTION

func apply_effect(match_manager, activator_id: int) -> bool:
	var opponent_id = 1 if activator_id == 0 else 0
	var opp_hand = match_manager.get_player_hand(opponent_id)
	var my_hand = match_manager.get_player_hand(activator_id)
	
	if opp_hand.is_empty():
		print("[TRECO] Mão Leve falhou: Oponente sem cartas na mão.")
		return false
		
	var weakest_card: CardData = opp_hand[0]
	var weakest_idx: int = 0
	var min_strength = TrucoRules.get_card_strength(weakest_card, match_manager.vira_card)
	
	for i in range(1, opp_hand.size()):
		var c = opp_hand[i]
		var s = TrucoRules.get_card_strength(c, match_manager.vira_card)
		if s < min_strength:
			min_strength = s
			weakest_card = c
			weakest_idx = i
			
	opp_hand.remove_at(weakest_idx)
	my_hand.append(weakest_card)
	print("[TRECO] Mão Leve Sucesso! Jogador %d roubou %s do Jogador %d" % [activator_id, weakest_card.to_string_short(), opponent_id])
	return true
