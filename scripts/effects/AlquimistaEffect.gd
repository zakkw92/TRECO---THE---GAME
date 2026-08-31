class_name AlquimistaEffect
extends TrecoEffect

func _init() -> void:
	item_name = "O Alquimista"
	description = "Poção de Transmutação: transforma uma carta da sua mão no Zap (Paus) da manilha atual."
	energy_cost = 2
	activation_window = Window.REACTION

func apply_effect(match_manager, activator_id: int) -> bool:
	var hand = match_manager.get_player_hand(activator_id)
	if hand.is_empty():
		return false
	
	var manilha_rank = TrucoRules.get_manilha_rank_for_vira(match_manager.vira_card.rank_value)
	var target_card: CardData = null
	for card in hand:
		if not (card.is_manilha and card.suit == CardData.Suit.PAUS):
			target_card = card
			break
	
	if target_card == null:
		target_card = hand[0]
		
	target_card.rank_value = manilha_rank
	target_card.suit = CardData.Suit.PAUS
	target_card.is_manilha = true
	print("[TRECO] O Alquimista: Carta transmutada para Zap (%s) para o Jogador %d" % [target_card.to_string_short(), activator_id])
	return true
