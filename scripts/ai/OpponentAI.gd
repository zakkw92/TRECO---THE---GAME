class_name OpponentAI
extends RefCounted

enum Personality { BALANCED, AGGRESSIVE_BLUFFER, CAUTIOUS_DWARF, ALCHEMIST_WITCH }

var personality: Personality
var bluff_frequency: float = 0.35

func _init(p_personality: Personality = Personality.BALANCED) -> void:
	personality = p_personality
	match personality:
		Personality.AGGRESSIVE_BLUFFER:
			bluff_frequency = 0.55
		Personality.CAUTIOUS_DWARF:
			bluff_frequency = 0.15
		Personality.ALCHEMIST_WITCH:
			bluff_frequency = 0.40
		_:
			bluff_frequency = 0.35

func evaluate_hand_strength(hand: Array, vira: CardData) -> float:
	if hand.is_empty():
		return 0.0
	var total_score: float = 0.0
	for card in hand:
		var s = TrucoRules.get_card_strength(card, vira)
		if s >= 1000:
			total_score += 10.0 + (s - 1000) * 0.01
		elif s >= 11:
			total_score += 5.0
		elif s >= 8:
			total_score += 3.0
		else:
			total_score += 1.0
	return total_score / float(hand.size())

func should_call_truco(match_manager: MatchManager) -> bool:
	if match_manager.current_state == MatchManager.State.WAITING_TRUCO_RESPONSE:
		return false
	if match_manager.last_truco_raiser == 1:
		return false
	
	var hand = match_manager.get_player_hand(1)
	var strength = evaluate_hand_strength(hand, match_manager.vira_card)
	
	if strength >= 6.5:
		return true
	elif strength <= 3.0 and randf() < bluff_frequency:
		return true
	return false

func answer_truco_call(match_manager: MatchManager) -> Dictionary:
	var hand = match_manager.get_player_hand(1)
	var strength = evaluate_hand_strength(hand, match_manager.vira_card)
	
	if strength >= 8.0 and match_manager.current_bet <= 6 and randf() < 0.4:
		return {"accept": true, "raise_bet": true}
	elif strength >= 4.0:
		return {"accept": true, "raise_bet": false}
	elif randf() < bluff_frequency * 0.5:
		return {"accept": true, "raise_bet": false}
	else:
		return {"accept": false, "raise_bet": false}

func choose_card_to_play(match_manager: MatchManager) -> CardData:
	var hand = match_manager.get_player_hand(1)
	if hand.is_empty():
		return null
	
	var opp_card = match_manager.played_cards[0]
	var vira = match_manager.vira_card
	
	if opp_card == null:
		var sorted_hand = hand.duplicate()
		sorted_hand.sort_custom(func(a, b): 
			return TrucoRules.get_card_strength(a, vira) < TrucoRules.get_card_strength(b, vira)
		)
		if randf() < 0.7:
			return sorted_hand[0]
		return sorted_hand[sorted_hand.size() - 1]
	else:
		var winning_cards: Array[CardData] = []
		var losing_cards: Array[CardData] = []
		var opp_str = TrucoRules.get_card_strength(opp_card, vira)
		
		for c in hand:
			var my_str = TrucoRules.get_card_strength(c, vira)
			if my_str > opp_str:
				winning_cards.append(c)
			else:
				losing_cards.append(c)
		
		if not winning_cards.is_empty():
			winning_cards.sort_custom(func(a, b):
				return TrucoRules.get_card_strength(a, vira) < TrucoRules.get_card_strength(b, vira)
			)
			return winning_cards[0]
		else:
			losing_cards.sort_custom(func(a, b):
				return TrucoRules.get_card_strength(a, vira) < TrucoRules.get_card_strength(b, vira)
			)
			return losing_cards[0]

func think_treco_pre_play(match_manager: MatchManager) -> TrecoEffect:
	if match_manager.trecos_used_this_round[1] >= 1:
		return null
	if match_manager.energy[1] < 1:
		return null
	
	var hand = match_manager.get_player_hand(1)
	var strength = evaluate_hand_strength(hand, match_manager.vira_card)
	
	if strength <= 3.5 and match_manager.energy[1] >= 2 and randf() < 0.45:
		return AlquimistaEffect.new()
	elif randf() < 0.35 and match_manager.energy[1] >= 1:
		return OlhoDeLinceEffect.new()
	return null
