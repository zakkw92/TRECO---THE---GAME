class_name TrucoRules
extends RefCounted

# Ordem natural de força das cartas no Truco (sem ser Manilha)
# 4 (mais fraca) -> 3 (mais forte)
const BASE_RANKS: Array[int] = [4, 5, 6, 7, 11, 12, 13, 1, 2, 3]

# Retorna a carta manilha correspondente ao Vira
static func get_manilha_rank_for_vira(vira_rank: int) -> int:
	var idx = BASE_RANKS.find(vira_rank)
	if idx == -1:
		return 4
	var next_idx = (idx + 1) % BASE_RANKS.size()
	return BASE_RANKS[next_idx]

# Calcula o valor numérico absoluto de força de uma carta para comparação
static func get_card_strength(card: CardData, vira_card: CardData) -> int:
	if card == null or vira_card == null:
		return -1
	var manilha_rank = get_manilha_rank_for_vira(vira_card.rank_value)
	
	# Se a carta for a Manilha da rodada
	if card.rank_value == manilha_rank:
		match card.suit:
			CardData.Suit.OUROS: return 100 # Pica-fumo
			CardData.Suit.ESPADAS: return 101 # Espadilha
			CardData.Suit.COPAS: return 102 # Copas
			CardData.Suit.PAUS: return 103 # Zap (Maior manilha)
			_: return 100
	
	# Carta comum: força base no array
	var idx = BASE_RANKS.find(card.rank_value)
	return idx if idx != -1 else 0

# Compara duas cartas. Retorna: 1 se card1 vence, -1 se card2 vence, 0 se empate (canga)
static func compare_cards(card1: CardData, card2: CardData, vira_card: CardData) -> int:
	var s1 = get_card_strength(card1, vira_card)
	var s2 = get_card_strength(card2, vira_card)
	if s1 > s2:
		return 1
	elif s1 < s2:
		return -1
	else:
		return 0

# Retorna o próximo valor de aposta de Truco (1 -> 3 -> 6 -> 9 -> 12)
static func get_next_bet(current_bet: int) -> int:
	match current_bet:
		1: return 3
		3: return 6
		6: return 9
		9: return 12
		_: return 12

# Avalia se a mão terminou baseado no histórico de vazas.
# Retorna: 0 ou 1 se houver vencedor definido, -1 se a mão continua, -2 se empate triplo (anulada)
static func evaluate_hand_winner(trick_history: Array[int]) -> int:
	var count = trick_history.size()
	if count == 0:
		return -1
		
	var p0_wins = 0
	var p1_wins = 0
	for res in trick_history:
		if res == 0: p0_wins += 1
		elif res == 1: p1_wins += 1

	# Caso direto: alguém já fez 2 vazas
	if p0_wins >= 2: return 0
	if p1_wins >= 2: return 1

	# Resolução de 2 vazas jogadas:
	if count == 2:
		if trick_history[0] == -1:
			if trick_history[1] == 0: return 0
			elif trick_history[1] == 1: return 1
		elif trick_history[1] == -1:
			return trick_history[0]

	# Resolução de 3 vazas jogadas:
	if count == 3:
		if trick_history[0] == -1 and trick_history[1] == -1:
			if trick_history[2] == 0: return 0
			elif trick_history[2] == 1: return 1
			else: return -2
			
		if trick_history[2] == -1:
			if trick_history[0] != -1:
				return trick_history[0]
			else:
				return trick_history[1]
				
		if p0_wins > p1_wins: return 0
		if p1_wins > p0_wins: return 1
		if p0_wins == p1_wins:
			return trick_history[0] if trick_history[0] != -1 else -2

	return -1
