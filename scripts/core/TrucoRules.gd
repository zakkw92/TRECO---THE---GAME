class_name TrucoRules
extends RefCounted

# Ordem oficial das cartas no Truco Paulista (da mais fraca para a mais forte)
# 4, 5, 6, 7, Q (8), J (9), K (10), Ás (11), 2 (12), 3 (13)
const RANK_ORDER: Array[int] = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

# Força dos naipes exclusiva para Manilhas:
# 1º Paus (Zap - 400) > 2º Copas (300) > 3º Espadas (200) > 4º Ouros (100)
const SUIT_STRENGTH_MAP: Dictionary = {
	CardData.Suit.OUROS: 100,
	CardData.Suit.ESPADAS: 200,
	CardData.Suit.COPAS: 300,
	CardData.Suit.PAUS: 400
}

# Retorna a Manilha seguinte na sequência circular do Truco Paulista
# Virou 3 -> 4 | Virou 7 -> Q | Virou K -> A | Virou A -> 2 | Virou 2 -> 3
static func get_manilha_rank_for_vira(vira_rank: int) -> int:
	var idx = RANK_ORDER.find(vira_rank)
	if idx == -1:
		return 4
	return RANK_ORDER[(idx + 1) % RANK_ORDER.size()]

# Retorna o valor numérico de força da carta:
# - Cartas comuns: 4 (mais fraca) até 13 (3 - mais forte comum). O naipe não altera a força.
# - Manilhas: 1000 + peso do naipe (1100 a 1400 - Zap).
static func get_card_strength(card: CardData, vira: CardData) -> int:
	if card == null:
		return -1
	var manilha_rank = get_manilha_rank_for_vira(vira.rank_value)
	if card.rank_value == manilha_rank:
		return 1000 + int(SUIT_STRENGTH_MAP.get(card.suit, 0))
	return card.rank_value

# Compara duas cartas. Retorna: 0 se card_a vence, 1 se card_b vence, -1 se empate (canga)
static func compare_cards(card_a: CardData, card_b: CardData, vira: CardData) -> int:
	var str_a = get_card_strength(card_a, vira)
	var str_b = get_card_strength(card_b, vira)
	if str_a > str_b:
		return 0
	elif str_b > str_a:
		return 1
	else:
		return -1

# Resolve a vaza considerando blefe de cartas viradas (escondidas)
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

# Regras oficiais de desempate do Truco Paulista em melhor de 3 vazas:
# - Empate na 1ª vaza -> vence a mão quem ganhar a 2ª vaza.
# - Empate na 1ª e 2ª vazas -> vence quem ganhar a 3ª vaza.
# - Empate na 2ª vaza -> vence a mão quem ganhou a 1ª vaza.
# - Empate na 3ª vaza -> vence a mão quem ganhou a 1ª vaza.
# - Empate nas 3 vazas -> ninguém pontua (-1).
static func evaluate_hand_winner(trick_results: Array) -> int:
	var p0_wins = 0
	var p1_wins = 0
	var draws = 0
	
	for res in trick_results:
		if res == 0: p0_wins += 1
		elif res == 1: p1_wins += 1
		elif res == -1: draws += 1
	
	# Quem fez 2 vazas normais vence a mão
	if p0_wins >= 2: return 0
	if p1_wins >= 2: return 1
	
	# 1. Empate na 1ª rodada
	if trick_results.size() >= 1 and trick_results[0] == -1:
		if trick_results.size() >= 2 and trick_results[1] != -1:
			return trick_results[1] # Quem ganha a 2ª leva
		if trick_results.size() >= 3 and trick_results[2] != -1:
			return trick_results[2] # Empatou 1ª e 2ª, quem ganha a 3ª leva
		if trick_results.size() >= 3 and trick_results[0] == -1 and trick_results[1] == -1 and trick_results[2] == -1:
			return -1 # Empate nas 3: ninguém pontua
	
	# 2. Empate na 2ª rodada -> vence quem ganhou a 1ª
	if trick_results.size() >= 2 and trick_results[1] == -1:
		return trick_results[0]
	
	# 3. Empate na 3ª rodada -> vence quem ganhou a 1ª
	if trick_results.size() >= 3 and trick_results[2] == -1:
		return trick_results[0]
	
	return -2 # Mão ainda em andamento
