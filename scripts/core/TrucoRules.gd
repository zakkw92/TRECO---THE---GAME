class_name TrucoRules
extends RefCounted

const RANK_ORDER: Array[int] = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

const SUIT_STRENGTH_MAP: Dictionary = {
	CardData.Suit.OUROS: 100,
	CardData.Suit.ESPADAS: 200,
	CardData.Suit.COPAS: 300,
	CardData.Suit.PAUS: 400
}

static func get_manilha_rank_for_vira(vira_rank: int) -> int:
	# Regra da Taverna: quando o tombo/vira for 2 ou 3, a manilha é o 4
	if vira_rank == 12: # 2
		return 4
	if vira_rank == 13: # 3
		return 4
	
	var idx = RANK_ORDER.find(vira_rank)
	if idx == -1:
		return 4
	return RANK_ORDER[(idx + 1) % RANK_ORDER.size()]

static func get_card_strength(card: CardData, vira: CardData) -> int:
	if card == null:
		return -1
	var manilha_rank = get_manilha_rank_for_vira(vira.rank_value)
	if card.rank_value == manilha_rank:
		return 1000 + int(SUIT_STRENGTH_MAP.get(card.suit, 0))
	return card.rank_value

static func compare_cards(card_a: CardData, card_b: CardData, vira: CardData) -> int:
	var str_a = get_card_strength(card_a, vira)
	var str_b = get_card_strength(card_b, vira)
	if str_a > str_b:
		return 0
	elif str_b > str_a:
		return 1
	else:
		return -1

static func resolve_trick(played_cards: Array, starter_id: int, vira: CardData) -> Dictionary:
	var card_0: CardData = played_cards[0]
	var card_1: CardData = played_cards[1]
	
	if card_0.is_face_down and card_1.is_face_down:
		return {"winner": -1, "is_draw": true}
	elif card_0.is_face_down:
		return {"winner": 1, "is_draw": false}
	elif card_1.is_face_down:
		return {"winner": 0, "is_draw": false}
	
	var comp = compare_cards(card_0, card_1, vira)
	if comp == -1:
		return {"winner": -1, "is_draw": true}
	return {"winner": comp, "is_draw": false}

static func evaluate_hand_winner(trick_results: Array) -> int:
	var p0_wins = 0
	var p1_wins = 0
	var draws = 0
	
	for res in trick_results:
		if res == 0: p0_wins += 1
		elif res == 1: p1_wins += 1
		elif res == -1: draws += 1
	
	if p0_wins >= 2: return 0
	if p1_wins >= 2: return 1
	
	if trick_results.size() >= 1 and trick_results[0] == -1:
		if trick_results.size() >= 2:
			if trick_results[1] != -1:
				return trick_results[1]
			if trick_results.size() >= 3:
				if trick_results[2] != -1:
					return trick_results[2]
				return 0
	
	if trick_results.size() >= 2 and trick_results[1] == -1:
		return trick_results[0]
	
	if trick_results.size() >= 3 and trick_results[2] == -1:
		return trick_results[0]
	
	return -2
