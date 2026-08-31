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
var score: Array[int] = [0, 0]
var energy: Array[int] = [3, 3]
var trecos_used_this_round: Array[int] = [0, 0]
var spying_protected: Array[bool] = [false, false]
var face_down_buff: Array[bool] = [false, false]
var double_bet_active: Array[bool] = [false, false]

var player_hands: Array = [[], []]
var vira_card: CardData
var deck: Deck

var current_hand_starter: int = 0
var current_trick_starter: int = 0
var current_turn: int = 0
var current_trick_index: int = 0
var trick_history: Array[int] = []
var tricks_won: Array[int] = [0, 0]
var played_cards: Array = [null, null]

var current_bet: int = 1
var truco_caller: int = -1
var last_truco_raiser: int = -1

func _init() -> void:
	deck = Deck.new()

func start_new_match() -> void:
	score = [0, 0]
	current_hand_starter = 0
	score_updated.emit(score[0], score[1])
	log_message.emit("=== NOVA PARTIDA DE TRECO INICIADA! ===")
	start_new_hand()

func start_new_hand() -> void:
	deck.reset_and_shuffle()
	current_bet = 1
	truco_caller = -1
	last_truco_raiser = -1
	current_trick_index = 0
	trick_history.clear()
	tricks_won = [0, 0]
	played_cards = [null, null]
	
	energy = [3, 3]
	trecos_used_this_round = [0, 0]
	spying_protected = [false, false]
	face_down_buff = [false, false]
	double_bet_active = [false, false]
	
	player_hands[0] = deck.deal_hand(3)
	player_hands[1] = deck.deal_hand(3)
	
	vira_card = deck.draw_card()
	vira_card.is_revealed = true
	_update_manilhas()
	
	current_trick_starter = current_hand_starter
	current_turn = current_trick_starter
	current_hand_starter = 1 if current_hand_starter == 0 else 0
	
	_set_state(State.PRE_PLAY)
	hand_started.emit(vira_card)
	bet_updated.emit(current_bet)
	energy_updated.emit(energy[0], energy[1])
	
	var manilha_val = TrucoRules.get_manilha_rank_for_vira(vira_card.rank_value)
	log_message.emit("Nova Mão! Vira: %s | Manilhas: cartas de valor %d" % [vira_card.to_string_short(), manilha_val])
	turn_changed.emit(current_turn)

func _update_manilhas() -> void:
	var manilha_rank = TrucoRules.get_manilha_rank_for_vira(vira_card.rank_value)
	for p_idx in [0, 1]:
		for card in player_hands[p_idx]:
			card.is_manilha = (card.rank_value == manilha_rank)

func play_card(player_id: int, card: CardData) -> bool:
	if current_state != State.PRE_PLAY and current_state != State.PREPARATION:
		return false
	if player_id != current_turn:
		return false
	if not player_hands[player_id].has(card):
		return false
	
	player_hands[player_id].erase(card)
	
	if face_down_buff[player_id]:
		card.is_face_down = true
		face_down_buff[player_id] = false
	else:
		card.is_face_down = false
	
	played_cards[player_id] = card
	card_played.emit(player_id, card)
	log_message.emit("Jogador %d jogou: %s%s" % [player_id, card.to_string_short(), " (VIRADA)" if card.is_face_down else ""])
	
	var other_player = 1 if player_id == 0 else 0
	if played_cards[other_player] == null:
		current_turn = other_player
		turn_changed.emit(current_turn)
	else:
		_resolve_trick()
	return true

func _resolve_trick() -> void:
	_set_state(State.RESOLVE_TRICK)
	var res = TrucoRules.resolve_trick(played_cards, current_trick_starter, vira_card)
	var winner = res["winner"]
	var is_draw = res["is_draw"]
	
	trick_history.append(winner)
	if winner != -1:
		tricks_won[winner] += 1
		current_trick_starter = winner
	
	trick_resolved.emit(winner, is_draw, current_trick_index)
	
	if is_draw:
		log_message.emit("Vaza %d: CANGA! (Empate)" % (current_trick_index + 1))
	else:
		log_message.emit("Vaza %d: Jogador %d venceu a vaza!" % [(current_trick_index + 1), winner])
	
	var hand_winner = TrucoRules.evaluate_hand_winner(trick_history)
	if hand_winner != -2:
		_end_hand(hand_winner)
	else:
		current_trick_index += 1
		played_cards = [null, null]
		current_turn = current_trick_starter
		_set_state(State.PRE_PLAY)
		turn_changed.emit(current_turn)

func _end_hand(winner: int) -> void:
	_set_state(State.RESOLVE_HAND)
	var points = current_bet
	if double_bet_active[0] or double_bet_active[1]:
		points *= 2
	
	if winner != -1:
		score[winner] += points
		score_updated.emit(score[0], score[1])
		log_message.emit("Fim da Mão! Jogador %d VENCEU a mão (+%d pontos)!" % [winner, points])
	else:
		log_message.emit("Fim da Mão! Canga tripla, nenhum ponto marcado.")
	
	hand_ended.emit(winner, points)
	
	if score[0] >= 12 or score[1] >= 12:
		var match_winner = 0 if score[0] >= 12 else 1
		_set_state(State.GAME_OVER)
		match_ended.emit(match_winner)
		log_message.emit("=== FIM DE PARTIDA! VENCEDOR: Jogador %d ===" % match_winner)

func call_truco(caller_id: int) -> bool:
	if current_state == State.WAITING_TRUCO_RESPONSE:
		return false
	if last_truco_raiser == caller_id:
		return false
	
	var next_bet = _get_next_bet_level(current_bet)
	if next_bet == -1:
		return false
	
	truco_caller = caller_id
	last_truco_raiser = caller_id
	_set_state(State.WAITING_TRUCO_RESPONSE)
	truco_called.emit(caller_id, next_bet)
	log_message.emit("BATIDA NA MESA! Jogador %d pediu %s (%d pontos)!" % [caller_id, _get_bet_name(next_bet), next_bet])
	return true

func answer_truco(responder_id: int, accept: bool, raise_bet: bool = false) -> void:
	if current_state != State.WAITING_TRUCO_RESPONSE:
		return
	
	if not accept:
		var winner = truco_caller
		truco_answered.emit(responder_id, false, false, current_bet)
		log_message.emit("Jogador %d CORREU do Truco! Jogador %d leva %d ponto(s)." % [responder_id, winner, current_bet])
		_end_hand(winner)
		return
	
	var next_bet = _get_next_bet_level(current_bet)
	if raise_bet:
		var higher_bet = _get_next_bet_level(next_bet)
		if higher_bet != -1:
			current_bet = next_bet
			truco_caller = responder_id
			last_truco_raiser = responder_id
			truco_answered.emit(responder_id, true, true, higher_bet)
			truco_called.emit(responder_id, higher_bet)
			log_message.emit("Jogador %d AUMENTOU para %s (%d pontos)!" % [responder_id, _get_bet_name(higher_bet), higher_bet])
			return
	
	current_bet = next_bet
	bet_updated.emit(current_bet)
	truco_answered.emit(responder_id, true, false, current_bet)
	log_message.emit("Jogador %d ACEITOU! A mão agora vale %d pontos!" % [responder_id, current_bet])
	_set_state(State.PRE_PLAY)

func use_treco(player_id: int, treco: TrecoEffect) -> bool:
	if trecos_used_this_round[player_id] >= 1:
		log_message.emit("Jogador %d tentou usar Treco, mas já atingiu o limite de 1 por rodada!" % player_id)
		return false
	if energy[player_id] < treco.energy_cost:
		log_message.emit("Jogador %d não tem energia suficiente para %s (%d⚡)!" % [player_id, treco.item_name, treco.energy_cost])
		return false
	
	if treco.apply_effect(self, player_id):
		energy[player_id] -= treco.energy_cost
		trecos_used_this_round[player_id] += 1
		energy_updated.emit(energy[0], energy[1])
		treco_activated.emit(player_id, treco.item_name)
		log_message.emit("ALQUIMIA! Jogador %d ativou Treco: %s!" % [player_id, treco.item_name])
		return true
	return false

func _get_next_bet_level(bet: int) -> int:
	match bet:
		1: return 3
		3: return 6
		6: return 9
		9: return 12
		_: return -1

func _get_bet_name(bet: int) -> String:
	match bet:
		3: return "TRUCO"
		6: return "SEIS"
		9: return "NOVE"
		12: return "DOZE"
		_: return "%d PONTOS" % bet

func _set_state(new_state: State) -> void:
	current_state = new_state
	state_changed.emit(new_state)

func is_player_protected_from_spying(player_id: int) -> bool:
	return spying_protected[player_id]

func set_player_spying_protection(player_id: int, protected: bool) -> void:
	spying_protected[player_id] = protected

func get_player_hand(player_id: int) -> Array:
	return player_hands[player_id]
