class_name OpponentAI
extends RefCounted

enum Personality { BALANCED, AGGRESSIVE_BLUFFER, CAUTIOUS_DWARF }

var personality: Personality = Personality.BALANCED
var ai_player_id: int = 1 # Oponente é P1

# Inventário de Trecos disponíveis para a IA na partida
var available_trecos: Array[TrecoEffect] = []

func _init(p_personality: Personality = Personality.BALANCED) -> void:
	personality = p_personality
	_setup_inventory()

func _setup_inventory() -> void:
	available_trecos = [
		OlhoDeLinceEffect.new(),
		FumacaDeTavernaEffect.new(),
		AlquimistaEffect.new(),
		CanaDeHidromelEffect.new(),
		CaraDePauEffect.new()
	]

# Avalia a força global da mão (soma das forças relativas das cartas)
func evaluate_hand_strength(match_manager: MatchManager) -> int:
	var hand = match_manager.get_player_hand(ai_player_id)
	var total = 0
	for card in hand:
		total += TrucoRules.get_card_strength(card, match_manager.vira_card)
	return total

# Decide se deve usar um Treco durante a janela de Pré-Jogada
func think_treco_pre_play(match_manager: MatchManager) -> TrecoEffect:
	# Se já usou Treco na rodada ou sem energia suficiente
	if match_manager.trecos_used_this_round[ai_player_id] >= 1:
		return null
	
	var hand = match_manager.get_player_hand(ai_player_id)
	var has_strong_manilha = false
	for card in hand:
		if card.is_manilha and card.suit in [CardData.Suit.PAUS, CardData.Suit.COPAS]:
			has_strong_manilha = true
			break
			
	for treco in available_trecos:
		if not match_manager.can_player_use_treco(ai_player_id, treco):
			continue
		
		# Se tem manilha forte e tem Fumaça de Taverna, protege contra espionagem
		if treco is FumacaDeTavernaEffect and has_strong_manilha and not match_manager.is_player_protected_from_spying(ai_player_id):
			return treco
			
		# Se mão é intermediária e tem Olho de Lince, tenta espionar
		if treco is OlhoDeLinceEffect and not match_manager.is_player_protected_from_spying(0) and randf() < 0.6:
			return treco
			
		# Blefe de Cara de Pau
		if treco is CaraDePauEffect and personality == Personality.AGGRESSIVE_BLUFFER and randf() < 0.4:
			return treco

	return null

# Decide qual carta jogar na vaza atual
func choose_card_to_play(match_manager: MatchManager) -> CardData:
	var hand: Array = match_manager.get_player_hand(ai_player_id)
	if hand.is_empty():
		return null
	
	var opp_card: CardData = match_manager.played_cards[0] # Carta jogada pelo jogador
	var vira = match_manager.vira_card
	
	# Ordena cartas da mão da menor força para a maior
	var sorted_hand = hand.duplicate()
	sorted_hand.sort_custom(func(a, b):
		return TrucoRules.get_card_strength(a, vira) < TrucoRules.get_card_strength(b, vira)
	)
	
	# Se a IA está abrindo a vaza (o jogador ainda não jogou)
	if opp_card == null:
		if match_manager.current_trick_index == 0:
			# 1ª vaza: joga carta intermediária ou forte para disputar a primeira
			return sorted_hand[sorted_hand.size() - 1] if personality == Personality.AGGRESSIVE_BLUFFER else sorted_hand[sorted_hand.size() / 2]
		else:
			# Vazas seguintes: joga a maior disponível
			return sorted_hand[sorted_hand.size() - 1]
	else:
		# O jogador já jogou. IA procura a menor carta que vença a carta do jogador
		var opp_strength = TrucoRules.get_card_strength(opp_card, vira)
		for card in sorted_hand:
			if TrucoRules.get_card_strength(card, vira) > opp_strength:
				return card # Vence com o menor custo possível
				
		# Se não consegue vencer, descarta a carta mais fraca (lixo)
		return sorted_hand[0]

# Decide se a IA deve pedir Truco
func should_call_truco(match_manager: MatchManager) -> bool:
	if match_manager.current_bet >= 12 or match_manager.last_truco_raiser == ai_player_id:
		return false
	
	var hand = match_manager.get_player_hand(ai_player_id)
	var hand_str = evaluate_hand_strength(match_manager)
	var bluff_chance = 0.15 if personality == Personality.BALANCED else (0.35 if personality == Personality.AGGRESSIVE_BLUFFER else 0.05)
	
	# Se tem mão muito forte (ex: manilhas), pede Truco
	if hand_str >= 100 or (match_manager.tricks_won[ai_player_id] == 1 and hand_str >= 8):
		return true
		
	# Blefe de taverna!
	if randf() < bluff_chance:
		return true
		
	return false

# Decide como responder ao pedido de Truco do jogador (Aceitar, Fugir ou Retrucar)
# Retorno: Dictionary com keys: {"accept": bool, "raise_bet": bool}
func answer_truco_call(match_manager: MatchManager) -> Dictionary:
	var hand = match_manager.get_player_hand(ai_player_id)
	var hand_str = evaluate_hand_strength(match_manager)
	var next_bet = TrucoRules.get_next_bet(match_manager.current_bet)
	
	# Se tem cartas fortes
	if hand_str >= 100:
		# Chance de retrucar (pedir 6/9/12)
		if next_bet < 12 and randf() < 0.5:
			return {"accept": true, "raise_bet": true}
		return {"accept": true, "raise_bet": false}
	
	if hand_str >= 14 or match_manager.tricks_won[ai_player_id] == 1:
		return {"accept": true, "raise_bet": false}
		
	# Se mão é muito fraca
	if hand_str < 6:
		# Chance pequena de pagar no blefe
		if personality == Personality.AGGRESSIVE_BLUFFER and randf() < 0.25:
			return {"accept": true, "raise_bet": false}
		return {"accept": false, "raise_bet": false} # Corre!
		
	return {"accept": true, "raise_bet": false}
