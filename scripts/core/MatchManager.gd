class_name MatchManager
extends Node

signal state_changed(new_state: State)
signal hand_started(vira_card: CardData)
signal card_played(player_id: int, card: CardData)
signal trick_resolved(winner: int, is_draw: bool, trick_idx: int)
signal hand_ended(winner: int, points_awarded: int)
signal match_ended(winner: int)
signal score_updated(score_p0: int, score_p1: int)
signal bet_updated(current_bet: int)
signal energy_updated(p0_energy: int, p1_energy: int)
signal treco_activated(player_id: int, treco_name: String)
signal truco_called(caller_id: int, bet_level: int)
signal truco_answered(responder_id: int, accepted: bool, raised: bool, bet_level: int)
signal turn_changed(player_id: int)
signal log_message(text: String)

enum State { IDLE, PREPARATION, PRE_PLAY, REACTION_WINDOW, WAITING_TRUCO_RESPONSE, RESOLVE_TRICK, RESOLVE_HAND, GAME_OVER }

var current_state: State = State.IDLE

# Placar da partida (0 a 12 tentos)
var score: Array[int] = [0, 0]

# Recursos por rodada (GDD v2.1)
var energy: Array[int] = [3, 3] # Energia de Taverna unificada (3 por mão)
var trecos_used_this_round: Array[int] = [0, 0] # Limite de no máximo 1 Treco por rodada por jogador
var spying_protected: Array[bool] = [false, false] # Flag da Fumaça de Taverna
var face_down_buff: Array[bool] = [false, false] # Flag da Cara de Pau
var double_bet_active: Array[bool] = [false, false] # Flag da Aposta Dobrada

# Mãos dos jogadores [P0 (Jogador), P1 (Oponente)]
var player_hands: Array = [[], []]
var vira_card: CardData
var deck: Deck

# Controle de Vazas (Melhor de 3)
var current_hand_starter: int = 0
var current_trick_starter: int = 0
var current_turn: int = 0
var current_trick_index: int = 0 # 0, 1 ou 2
var trick_history: Array[int] = [] # Vencedor de cada vaza: 0, 1 ou -1 (empate/canga)
var tricks_won: Array[int] = [0, 0]
var played_cards: Array = [null, null] # Cartas jogadas na vaza atual [P0, P1]

# Sistema de Apostas de Truco (1 -> 3 -> 6 -> 9 -> 12)
var current_bet: int = 1
var truco_caller: int = -1
var last_truco_raiser: int = -1

func _ready() -> void:
	deck = Deck.new()

func start_new_match() -> void:
	score = [0, 0]
	current_hand_starter = 0
	score_updated.emit(score[0], score[1])
	_emit_log("=== NOVA PARTIDA DE TRECO INICIADA! ===")
	start_new_hand()

func start_new_hand() -> void:
	if score[0] >= 12 or score[1] >= 12:
		current_state = State.GAME_OVER
		state_changed.emit(current_state)
		var match_winner = 0 if score[0] >= 12 else 1
		match_ended.emit(match_winner)
		_emit_log("Fim de Jogo! Vencedor da Taverna: Jogador %d!" % match_winner)
		return

	# Reset dos recursos e estado da mão
	energy = [3, 3]
	trecos_used_this_round = [0, 0]
	spying_protected = [false, false]
	face_down_buff = [false, false]
	double_bet_active = [false, false]
	played_cards = [null, null]
	trick_history.clear()
	tricks_won = [0, 0]
	current_trick_index = 0
	current_bet = 1
	truco_caller = -1
	last_truco_raiser = -1

	deck.reset_and_shuffle()
	player_hands[0] = deck.deal_hand(3)
	player_hands[1] = deck.deal_hand(3)
	vira_card = deck.draw_card()

	_update_manilhas()

	current_trick_starter = current_hand_starter
	current_turn = current_trick_starter

	current_state = State.PRE_PLAY
	state_changed.emit(current_state)
	hand_started.emit(vira_card)
	bet_updated.emit(current_bet)
	energy_updated.emit(energy[0], energy[1])
	turn_changed.emit(current_turn)
	
	var manilha_nome = TrucoRules.BASE_RANKS[TrucoRules.BASE_RANKS.find(TrucoRules.get_manilha_rank_for_vira(vira_card.rank_value))]
	_emit_log("Nova Mão! Vira: %s | Manilhas: cartas de valor %s" % [vira_card.to_string_short(), str(manilha_nome)])

func _update_manilhas() -> void:
	var manilha_rank = TrucoRules.get_manilha_rank_for_vira(vira_card.rank_value)
	for p in range(2):
		for card in player_hands[p]:
			card.is_manilha = (card.rank_value == manilha_rank)

func play_card(player_id: int, card: CardData) -> bool:
	if current_state != State.PRE_PLAY and current_state != State.REACTION_WINDOW:
		return false
	if current_turn != player_id:
		_emit_log("Não é o turno do Jogador %d!" % player_id)
		return false
	var hand: Array = player_hands[player_id]
	if not hand.has(card):
		return false
	
	hand.erase(card)
	
	# Aplica blefe visual de Cara de Pau
	if face_down_buff[player_id]:
		card.is_face_down = true
		face_down_buff[player_id] = false
		_emit_log("Jogador %d jogou carta virada para baixo (Cara de Pau)!" % player_id)
	
	played_cards[player_id] = card
	card_played.emit(player_id, card)
	_emit_log("Jogador %d jogou: %s" % [player_id, "???" if card.is_face_down else card.to_string_short()])

	# Se ambos jogaram na vaza atual, resolve a vaza
	if played_cards[0] != null and played_cards[1] != null:
		_resolve_current_trick()
	else:
		# Passa o turno para o outro jogador
		current_turn = 1 if player_id == 0 else 0
		turn_changed.emit(current_turn)
	
	return true

func _resolve_current_trick() -> void:
	current_state = State.RESOLVE_TRICK
	state_changed.emit(current_state)

	var c0: CardData = played_cards[0]
	var c1: CardData = played_cards[1]

	# Revela cartas viradas para baixo
	c0.is_face_down = false
	c1.is_face_down = false

	var comp = TrucoRules.compare_cards(c0, c1, vira_card)
	var trick_winner = -1
	var is_draw = false

	if comp == 1:
		trick_winner = 0
		tricks_won[0] += 1
		current_trick_starter = 0
		_emit_log("Vaza %d: Jogador 0 VENCEU a vaza!" % (current_trick_index + 1))
	elif comp == -1:
		trick_winner = 1
		tricks_won[1] += 1
		current_trick_starter = 1
		_emit_log("Vaza %d: Jogador 1 VENCEU a vaza!" % (current_trick_index + 1))
	else:
		is_draw = true
		_emit_log("Vaza %d: EMPATE (Canga)!" % (current_trick_index + 1))

	trick_history.append(trick_winner)
	trick_resolved.emit(trick_winner, is_draw, current_trick_index)

	played_cards = [null, null]
	current_trick_index += 1

	# Avalia se a mão foi concluída
	var hand_winner = TrucoRules.evaluate_hand_winner(trick_history)
	if hand_winner != -1:
		_end_hand(hand_winner)
	else:
		# Continua para a próxima vaza
		current_turn = current_trick_starter
		current_state = State.PRE_PLAY
		state_changed.emit(current_state)
		turn_changed.emit(current_turn)

func _end_hand(winner: int) -> void:
	current_state = State.RESOLVE_HAND
	state_changed.emit(current_state)

	var points = current_bet
	if winner >= 0:
		if double_bet_active[winner]:
			points *= 2
			_emit_log("Bônus de Aposta Dobrada aplicado!")
		score[winner] += points
		score_updated.emit(score[0], score[1])
		_emit_log(">> FIM DA MÃO! Jogador %d venceu a mão e ganhou %d tento(s)! Placar: %d x %d" % [winner, points, score[0], score[1]])
		hand_ended.emit(winner, points)
	else:
		_emit_log(">> FIM DA MÃO! Mão Anulada por empate triplo.")
		hand_ended.emit(-1, 0)

	# Alterna quem começa a próxima mão
	current_hand_starter = 1 if current_hand_starter == 0 else 0

# Sistema de Truco
func call_truco(caller_id: int) -> bool:
	if current_state == State.WAITING_TRUCO_RESPONSE:
		return false
	if last_truco_raiser == caller_id:
		_emit_log("Você já aumentou a aposta e deve aguardar a resposta do oponente.")
		return false
	
	var next_bet = TrucoRules.get_next_bet(current_bet)
	if next_bet <= current_bet:
		_emit_log("Aposta já atingiu o valor máximo (12)!")
		return false

	truco_caller = caller_id
	last_truco_raiser = caller_id
	current_state = State.WAITING_TRUCO_RESPONSE
	state_changed.emit(current_state)
	truco_called.emit(caller_id, next_bet)
	
	var call_name = "TRUCO" if next_bet == 3 else ("SEIS" if next_bet == 6 else ("NOVE" if next_bet == 9 else "DOZE"))
	_emit_log("BATIDA NA MESA! Jogador %d pediu %s (%d pontos)!" % [caller_id, call_name, next_bet])
	return true

func answer_truco(responder_id: int, accept: bool, raise_bet: bool = false) -> void:
	if current_state != State.WAITING_TRUCO_RESPONSE:
		return
	var next_bet = TrucoRules.get_next_bet(current_bet)
	
	if not accept:
		# Correu / Fugiu do truco
		var winner = truco_caller
		var points_conceded = current_bet
		_emit_log("Jogador %d fugiu do pedido! Jogador %d ganha %d ponto(s)." % [responder_id, winner, points_conceded])
		truco_answered.emit(responder_id, false, false, current_bet)
		_end_hand(winner)
	elif raise_bet:
		# Retrucou / Aumentou
		current_bet = next_bet
		bet_updated.emit(current_bet)
		call_truco(responder_id)
	else:
		# Aceitou / Caiu
		current_bet = next_bet
		bet_updated.emit(current_bet)
		_emit_log("Jogador %d ACEITOU! A mão agora vale %d pontos!" % [responder_id, current_bet])
		truco_answered.emit(responder_id, true, false, current_bet)
		current_state = State.PRE_PLAY
		state_changed.emit(current_state)

# Sistema de Trecos (GDD v2.1)
func can_player_use_treco(player_id: int, treco: TrecoEffect) -> bool:
	if player_id < 0 or player_id > 1 or treco == null:
		return false
	if trecos_used_this_round[player_id] >= 1:
		_emit_log("Treco negado: Limite de 1 Treco por rodada já atingido!")
		return false
	if energy[player_id] < treco.energy_cost:
		_emit_log("Treco negado: Energia insuficiente (%d/%d)!" % [energy[player_id], treco.energy_cost])
		return false
	return true

func use_treco(player_id: int, treco: TrecoEffect) -> bool:
	if not can_player_use_treco(player_id, treco):
		return false
	var success = treco.apply_effect(self, player_id)
	if success:
		energy[player_id] -= treco.energy_cost
		trecos_used_this_round[player_id] += 1
		energy_updated.emit(energy[0], energy[1])
		treco_activated.emit(player_id, treco.item_name)
		_emit_log("Jogador %d ativou o Treco '%s'! (Energia restante: %d)" % [player_id, treco.item_name, energy[player_id]])
	return success

func is_player_protected_from_spying(player_id: int) -> bool:
	return spying_protected[player_id]

func set_player_spying_protection(player_id: int, protected: bool) -> void:
	spying_protected[player_id] = protected

func get_player_hand(player_id: int) -> Array:
	return player_hands[player_id]

func _emit_log(text: String) -> void:
	print("[TRECO] ", text)
	log_message.emit(text)
