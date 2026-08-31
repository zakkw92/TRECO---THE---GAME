class_name TavernTable
extends Control

@onready var match_manager: MatchManager = $MatchManager
@onready var camera: ScreenShakeCamera = $Camera2D
@onready var crt_layer: CanvasLayer = $CRTLayer
@onready var p0_hand_container: HBoxContainer = $TableArea/P0HandContainer
@onready var p1_hand_container: HBoxContainer = $TableArea/P1HandContainer
@onready var vira_container: CenterContainer = $TableArea/CenterArea/ViraContainer
@onready var played_p0_container: CenterContainer = $TableArea/CenterArea/PlayedP0
@onready var played_p1_container: CenterContainer = $TableArea/CenterArea/PlayedP1
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var bet_label: Label = $HUD/BetPanel/BetLabel
@onready var energy_label: Label = $HUD/EnergyPanel/EnergyLabel
@onready var truco_button: Button = $HUD/ActionButtons/TrucoButton
@onready var log_box: RichTextLabel = $HUD/LogPanel/LogText
@onready var treco_container: HBoxContainer = $HUD/TrecoPanel/TrecoList
@onready var truco_dialog: Panel = $TrucoDialog
@onready var truco_dialog_text: Label = $TrucoDialog/DialogText
@onready var banner_label: Label = $HUD/BannerLabel

var opponent_ai: OpponentAI
var card_ui_scene: PackedScene = preload("res://scenes/CardUI.tscn")
var player_trecos: Array[TrecoEffect] = []

func _ready() -> void:
	opponent_ai = OpponentAI.new(OpponentAI.Personality.BALANCED)
	_setup_player_trecos()
	_connect_signals()
	truco_dialog.visible = false
	banner_label.visible = false
	match_manager.start_new_match()

func _setup_player_trecos() -> void:
	player_trecos = [
		OlhoDeLinceEffect.new(),
		FumacaDeTavernaEffect.new(),
		AlquimistaEffect.new(),
		CaraDePauEffect.new(),
		CanaDeHidromelEffect.new(),
		ApostaDobradaEffect.new()
	]
	_build_treco_buttons()

func _connect_signals() -> void:
	match_manager.hand_started.connect(_on_hand_started)
	match_manager.card_played.connect(_on_card_played)
	match_manager.trick_resolved.connect(_on_trick_resolved)
	match_manager.hand_ended.connect(_on_hand_ended)
	match_manager.score_updated.connect(_on_score_updated)
	match_manager.bet_updated.connect(_on_bet_updated)
	match_manager.energy_updated.connect(_on_energy_updated)
	match_manager.truco_called.connect(_on_truco_called)
	match_manager.treco_activated.connect(_on_treco_activated)
	match_manager.turn_changed.connect(_on_turn_changed)
	match_manager.log_message.connect(_on_log_message)
	truco_button.pressed.connect(_on_truco_button_pressed)
	$TrucoDialog/AcceptButton.pressed.connect(func(): match_manager.answer_truco(0, true))
	$TrucoDialog/RefuseButton.pressed.connect(func(): match_manager.answer_truco(0, false))
	$TrucoDialog/RaiseButton.pressed.connect(func(): match_manager.answer_truco(0, true, true))

func _build_treco_buttons() -> void:
	for child in treco_container.get_children():
		child.queue_free()
	for treco in player_trecos:
		var btn = Button.new()
		btn.text = "%s (%d⚡)" % [treco.item_name, treco.energy_cost]
		btn.tooltip_text = treco.description
		btn.pressed.connect(func(): _use_player_treco(treco))
		treco_container.add_child(btn)

func _use_player_treco(treco: TrecoEffect) -> void:
	if match_manager.use_treco(0, treco):
		_refresh_hands_ui()

func _on_hand_started(vira: CardData) -> void:
	_refresh_hands_ui()
	_display_vira(vira)
	_clear_played_cards()
	_show_banner("NOVA MÃO! Vira: %s" % vira.to_string_short(), Color("ffaa44"), 1.8)

func _display_vira(vira: CardData) -> void:
	for c in vira_container.get_children():
		c.queue_free()
	var card_node: CardUI = card_ui_scene.instantiate()
	vira_container.add_child(card_node)
	card_node.setup(vira, false)
	card_node.animate_slam(0.25)

func _refresh_hands_ui() -> void:
	for c in p0_hand_container.get_children():
		c.queue_free()
	for card in match_manager.player_hands[0]:
		var card_node: CardUI = card_ui_scene.instantiate()
		p0_hand_container.add_child(card_node)
		card_node.setup(card, true)
		card_node.card_clicked.connect(func(c_data): _on_player_card_clicked(c_data))

	for c in p1_hand_container.get_children():
		c.queue_free()
	for card in match_manager.player_hands[1]:
		var card_node: CardUI = card_ui_scene.instantiate()
		p1_hand_container.add_child(card_node)
		card_node.setup(card, false)

func _on_player_card_clicked(card: CardData) -> void:
	if match_manager.current_turn != 0:
		return
	match_manager.play_card(0, card)
	_refresh_hands_ui()

func _on_turn_changed(player_id: int) -> void:
	if player_id == 1:
		_trigger_ai_turn()

func _trigger_ai_turn() -> void:
	await get_tree().create_timer(0.7).timeout
	if match_manager.current_state == MatchManager.State.GAME_OVER:
		return
	
	var treco_to_use = opponent_ai.think_treco_pre_play(match_manager)
	if treco_to_use != null:
		match_manager.use_treco(1, treco_to_use)
		_refresh_hands_ui()
		await get_tree().create_timer(0.6).timeout

	if opponent_ai.should_call_truco(match_manager):
		match_manager.call_truco(1)
		return
	
	var card_to_play = opponent_ai.choose_card_to_play(match_manager)
	if card_to_play != null:
		match_manager.play_card(1, card_to_play)
		_refresh_hands_ui()

func _on_card_played(player_id: int, card: CardData) -> void:
	var target_container = played_p0_container if player_id == 0 else played_p1_container
	for c in target_container.get_children():
		c.queue_free()
	var card_node: CardUI = card_ui_scene.instantiate()
	target_container.add_child(card_node)
	card_node.setup(card, false)
	card_node.animate_slam(0.2)
	
	# Leve tremor de mesa ao jogar carta forte
	if card.is_manilha:
		camera.add_trauma(0.35)

func _on_trick_resolved(winner: int, is_draw: bool, _idx: int) -> void:
	if is_draw:
		_show_banner("CANGA! (EMPATE)", Color("ffffff"), 1.2)
		camera.add_trauma(0.3)
	elif winner == 0:
		_show_banner("VOCÊ FEZ A VAZA!", Color("48cae4"), 1.2)
	else:
		_show_banner("OPONENTE FEZ A VAZA!", Color("f77f00"), 1.2)
	
	await get_tree().create_timer(1.2).timeout
	_clear_played_cards()

func _clear_played_cards() -> void:
	for c in played_p0_container.get_children(): c.queue_free()
	for c in played_p1_container.get_children(): c.queue_free()

func _on_hand_ended(winner: int, points: int) -> void:
	if winner == 0:
		_show_banner("MÃO GANHA! +%d PONTO(S)" % points, Color("06d6a0"), 1.8)
		camera.add_trauma(0.4)
	elif winner == 1:
		_show_banner("OPONENTE LEVOU A MÃO! (%d PONTOS)" % points, Color("ef476f"), 1.8)
		camera.add_trauma(0.4)
	
	await get_tree().create_timer(1.8).timeout
	match_manager.start_new_hand()

func _on_score_updated(p0_s: int, p1_s: int) -> void:
	score_label.text = "Taverneiro (P0): %d  |  Oponente (P1): %d" % [p0_s, p1_s]

func _on_bet_updated(bet: int) -> void:
	bet_label.text = "Aposta: %d Tento(s)" % bet

func _on_energy_updated(e0: int, _e1: int) -> void:
	energy_label.text = "Energia: %d ⚡" % e0

func _on_truco_called(caller_id: int, bet_level: int) -> void:
	var call_title = "TRUCO!" if bet_level == 3 else ("SEIS!" if bet_level == 6 else ("NOVE!" if bet_level == 9 else "DOZE!"))
	_show_banner("BATIDA NA MESA: " + call_title, Color("e63946"), 1.5)
	
	# Forte Screen Shake (batida de caneca na mesa de madeira!)
	camera.add_trauma(0.7)
	
	if caller_id == 1:
		truco_dialog_text.text = "Oponente bateu na mesa: %s (%d pontos)!" % [call_title, bet_level]
		truco_dialog.visible = true
	else:
		await get_tree().create_timer(1.0).timeout
		var ai_resp = opponent_ai.answer_truco_call(match_manager)
		match_manager.answer_truco(1, ai_resp["accept"], ai_resp.get("raise_bet", false))

func _on_treco_activated(player_id: int, treco_name: String) -> void:
	var msg = ("Você ativou " if player_id == 0 else "Oponente ativou ") + treco_name
	_show_banner(msg, Color("52b788"), 1.3)
	camera.add_trauma(0.25)

func _on_truco_button_pressed() -> void:
	match_manager.call_truco(0)

func _show_banner(text: String, color: Color, duration: float = 1.5) -> void:
	banner_label.text = text
	banner_label.modulate = color
	banner_label.visible = true
	banner_label.scale = Vector2(0.7, 0.7)
	banner_label.pivot_offset = banner_label.size / 2.0
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(banner_label, "scale", Vector2(1.1, 1.1), 0.2)
	tween.chain().tween_property(banner_label, "scale", Vector2(1.0, 1.0), 0.1)
	tween.chain().tween_interval(duration)
	tween.chain().tween_property(banner_label, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func():
		banner_label.visible = false
		banner_label.modulate.a = 1.0
	)

func _on_log_message(msg: String) -> void:
	if log_box != null:
		log_box.append_text("\n" + msg)
