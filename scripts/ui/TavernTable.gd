class_name TavernTable
extends Control

@onready var match_manager: MatchManager = $MatchManager
@onready var camera: ScreenShakeCamera = $Camera2D
@onready var crt_layer: CanvasLayer = $CRTLayer
@onready var audio_manager: AudioManager = $AudioManager
@onready var bardo_portrait: BardoPortrait = $TableArea/BardoArea/BardoPortrait
@onready var p0_hand_container: HBoxContainer = $TableArea/P0HandContainer
@onready var p1_hand_container: HBoxContainer = $TableArea/P1HandContainer
@onready var vira_container: CenterContainer = $TableArea/CenterArea/ViraPedestal/ViraContainer
@onready var vira_label: Label = $TableArea/CenterArea/ViraPedestal/ViraHeaderLabel
@onready var manilha_info_label: Label = $TableArea/CenterArea/ViraPedestal/ManilhaInfoLabel
@onready var played_p0_container: CenterContainer = $TableArea/CenterArea/PlayedP0
@onready var played_p1_container: CenterContainer = $TableArea/CenterArea/PlayedP1
@onready var score_label: Label = $HUD/TopLeftHUD/ScorePanel/ScoreLabel
@onready var bet_label: Label = $HUD/TopLeftHUD/StatsRow/BetPanel/BetLabel
@onready var energy_label: Label = $HUD/TopLeftHUD/StatsRow/EnergyPanel/EnergyLabel
@onready var truco_button: Button = $HUD/BottomActionButtons/TrucoButton
@onready var treco_modal_button: Button = $HUD/BottomActionButtons/TrecoModalButton
@onready var menu_button: Button = $HUD/BottomActionButtons/MenuButton
@onready var log_box: RichTextLabel = $HUD/LogPanel/LogText
@onready var treco_modal: Panel = $TrecoModal
@onready var treco_grid: HBoxContainer = $TrecoModal/TrecoGridContainer
@onready var close_treco_button: Button = $TrecoModal/CloseTrecoModalButton
@onready var truco_dialog: Panel = $TrucoDialog
@onready var truco_dialog_text: Label = $TrucoDialog/DialogText
@onready var banner_label: Label = $HUD/BannerLabel
@onready var game_over_dialog: Panel = $GameOverDialog
@onready var game_over_title: Label = $GameOverDialog/GameOverTitle
@onready var game_over_desc: Label = $GameOverDialog/GameOverDesc

var opponent_ai: OpponentAI
var card_ui_scene: PackedScene = preload("res://scenes/CardUI.tscn")

# Catálogo completo e 3 Trecos sorteados da rodada
var all_trecos_catalogue: Array[TrecoEffect] = []
var round_trecos: Array[TrecoEffect] = []

func _ready() -> void:
	opponent_ai = OpponentAI.new(OpponentAI.Personality.AGGRESSIVE_BLUFFER)
	_init_catalogue()
	_connect_signals()
	treco_modal.visible = false
	truco_dialog.visible = false
	game_over_dialog.visible = false
	banner_label.visible = false
	match_manager.start_new_match()

func _init_catalogue() -> void:
	all_trecos_catalogue = [
		OlhoDeLinceEffect.new(),
		FumacaDeTavernaEffect.new(),
		AlquimistaEffect.new(),
		CaraDePauEffect.new(),
		CanaDeHidromelEffect.new(),
		ConfusaoNoBarEffect.new(),
		MaoLeveEffect.new(),
		ApostaDobradaEffect.new()
	]

func _roll_random_trecos_for_round() -> void:
	var pool = all_trecos_catalogue.duplicate()
	pool.shuffle()
	round_trecos = [pool[0], pool[1], pool[2]]
	_build_treco_modal_tiles()

func _connect_signals() -> void:
	match_manager.hand_started.connect(_on_hand_started)
	match_manager.card_played.connect(_on_card_played)
	match_manager.trick_resolved.connect(_on_trick_resolved)
	match_manager.hand_ended.connect(_on_hand_ended)
	match_manager.match_ended.connect(_on_match_ended)
	match_manager.score_updated.connect(_on_score_updated)
	match_manager.bet_updated.connect(_on_bet_updated)
	match_manager.energy_updated.connect(_on_energy_updated)
	match_manager.truco_called.connect(_on_truco_called)
	match_manager.truco_answered.connect(_on_truco_answered)
	match_manager.treco_activated.connect(_on_treco_activated)
	match_manager.turn_changed.connect(_on_turn_changed)
	match_manager.log_message.connect(_on_log_message)
	
	truco_button.pressed.connect(_on_truco_button_pressed)
	treco_modal_button.pressed.connect(func(): 
		audio_manager.play_click()
		_build_treco_modal_tiles()
		treco_modal.visible = true
	)
	close_treco_button.pressed.connect(func():
		audio_manager.play_click()
		treco_modal.visible = false
	)
	menu_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	
	$TrucoDialog/AcceptButton.pressed.connect(func(): 
		truco_dialog.visible = false
		match_manager.answer_truco(0, true)
	)
	$TrucoDialog/RefuseButton.pressed.connect(func(): 
		truco_dialog.visible = false
		match_manager.answer_truco(0, false)
	)
	$TrucoDialog/RaiseButton.pressed.connect(func(): 
		truco_dialog.visible = false
		match_manager.answer_truco(0, true, true)
	)
	$GameOverDialog/RestartButton.pressed.connect(func():
		game_over_dialog.visible = false
		match_manager.start_new_match()
	)
	$GameOverDialog/MenuReturnButton.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)

func _build_treco_modal_tiles() -> void:
	for child in treco_grid.get_children():
		child.queue_free()
	
	var already_used = match_manager.treco_used_this_round[0]
	var cur_energy = match_manager.player_energy[0]
	
	for treco in round_trecos:
		var card_panel = Panel.new()
		card_panel.custom_minimum_size = Vector2(200, 230)
		
		var vbox = VBoxContainer.new()
		vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		vbox.offset_left = 12
		vbox.offset_top = 12
		vbox.offset_right = -12
		vbox.offset_bottom = -12
		vbox.theme_override_constants.separation = 8
		
		var title_lbl = Label.new()
		title_lbl.text = "🧪 " + treco.item_name
		title_lbl.set("theme_override_colors/font_color", Color("ffd166"))
		title_lbl.set("theme_override_font_sizes/font_size", 16)
		title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(title_lbl)
		
		var cost_lbl = Label.new()
		cost_lbl.text = "Custo: %d ⚡" % treco.energy_cost
		cost_lbl.set("theme_override_colors/font_color", Color("06d6a0"))
		cost_lbl.set("theme_override_font_sizes/font_size", 13)
		cost_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(cost_lbl)
		
		var desc_lbl = Label.new()
		desc_lbl.text = treco.description
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.size_flags_vertical = Control.SIZE_EXPAND_FILL
		desc_lbl.set("theme_override_font_sizes/font_size", 12)
		vbox.add_child(desc_lbl)
		
		var use_btn = Button.new()
		use_btn.custom_minimum_size = Vector2(0, 36)
		
		if already_used:
			use_btn.text = "Limite de 1/Rodada Usado"
			use_btn.disabled = true
		elif cur_energy < treco.energy_cost:
			use_btn.text = "Sem Energia (%d⚡)" % treco.energy_cost
			use_btn.disabled = true
		else:
			use_btn.text = "✨ Ativar Efeito"
			use_btn.pressed.connect(func():
				treco_modal.visible = false
				_use_player_treco(treco)
			)
		
		vbox.add_child(use_btn)
		card_panel.add_child(vbox)
		treco_grid.add_child(card_panel)

func _use_player_treco(treco: TrecoEffect) -> void:
	if match_manager.use_treco(0, treco):
		audio_manager.play_potion()
		_refresh_hands_ui()
		_build_treco_modal_tiles()

func _on_hand_started(vira: CardData) -> void:
	_roll_random_trecos_for_round()
	_refresh_hands_ui()
	_display_vira(vira)
	_clear_played_cards()
	audio_manager.play_card_slide()
	_show_banner("NOVA MÃO! Vira: %s" % vira.to_string_short(), Color("ffaa44"), 1.8)

func _display_vira(vira: CardData) -> void:
	for c in vira_container.get_children():
		c.queue_free()
	vira.is_revealed = true
	var card_node: CardUI = card_ui_scene.instantiate()
	vira_container.add_child(card_node)
	card_node.setup(vira, false, false)
	card_node.animate_slam(0.25)
	
	var manilha_val = TrucoRules.get_manilha_rank_for_vira(vira.rank_value)
	var dummy_card = CardData.new(CardData.Suit.PAUS, manilha_val)
	manilha_info_label.text = "Manilha: %s" % dummy_card.get_rank_name()

func _refresh_hands_ui() -> void:
	for c in p0_hand_container.get_children():
		c.queue_free()
	for card in match_manager.player_hands[0]:
		var card_node: CardUI = card_ui_scene.instantiate()
		p0_hand_container.add_child(card_node)
		card_node.setup(card, true, false)
		card_node.card_clicked.connect(func(c_data): _on_player_card_clicked(c_data))

	for c in p1_hand_container.get_children():
		c.queue_free()
	for card in match_manager.player_hands[1]:
		var card_node: CardUI = card_ui_scene.instantiate()
		p1_hand_container.add_child(card_node)
		card_node.setup(card, false, not card.is_revealed)

func _on_player_card_clicked(card: CardData) -> void:
	if match_manager.current_turn != 0:
		return
	audio_manager.play_card_slide()
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
		audio_manager.play_card_slide()
		match_manager.play_card(1, card_to_play)
		_refresh_hands_ui()

func _on_card_played(player_id: int, card: CardData) -> void:
	var target_container = played_p0_container if player_id == 0 else played_p1_container
	for c in target_container.get_children():
		c.queue_free()
	var card_node: CardUI = card_ui_scene.instantiate()
	target_container.add_child(card_node)
	card_node.setup(card, false, card.is_face_down)
	card_node.animate_slam(0.2)
	
	if card.is_manilha:
		camera.add_trauma(0.35)

func _on_trick_resolved(winner: int, is_draw: bool, _idx: int) -> void:
	if is_draw:
		_show_banner("CANGA! (EMPATE)", Color("ffffff"), 1.2)
		camera.add_trauma(0.3)
	elif winner == 0:
		_show_banner("VOCÊ FEZ A VAZA!", Color("48cae4"), 1.2)
		bardo_portrait.on_trick_lost()
	else:
		_show_banner("O BARDO FEZ A VAZA!", Color("f77f00"), 1.2)
		bardo_portrait.on_trick_won()
	
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
		_show_banner("O BARDO LEVOU A MÃO! (%d PONTOS)" % points, Color("ef476f"), 1.8)
		camera.add_trauma(0.4)
	
	await get_tree().create_timer(1.8).timeout
	if match_manager.score[0] < 12 and match_manager.score[1] < 12:
		match_manager.start_new_hand()

func _on_match_ended(winner: int) -> void:
	audio_manager.play_victory()
	game_over_dialog.visible = true
	if winner == 0:
		game_over_title.text = "🏆 VITÓRIA DA TAVERNA!"
		game_over_title.modulate = Color("06d6a0")
		game_over_desc.text = "Você derrotou Sylas, o Bardo Trapaceiro, e defendeu a honra da taverna! Placar final: %d x %d" % [match_manager.score[0], match_manager.score[1]]
	else:
		game_over_title.text = "💀 O BARDO LEVOU SEU OURO!"
		game_over_title.modulate = Color("ef476f")
		game_over_desc.text = "Sylas usou seus melhores blefes e venceu a partida. Placar final: %d x %d" % [match_manager.score[0], match_manager.score[1]]

func _on_score_updated(p0_s: int, p1_s: int) -> void:
	score_label.text = "Taverneiro: %d  |  Sylas: %d" % [p0_s, p1_s]

func _on_bet_updated(bet: int) -> void:
	bet_label.text = "Aposta: %d Tento(s)" % bet

func _on_energy_updated(e0: int, _e1: int) -> void:
	energy_label.text = "Energia: %d ⚡" % e0

func _on_truco_called(caller_id: int, bet_level: int) -> void:
	var call_title = "TRUCO!" if bet_level == 3 else ("SEIS!" if bet_level == 6 else ("NOVE!" if bet_level == 9 else "DOZE!"))
	_show_banner("BATIDA NA MESA: " + call_title, Color("e63946"), 1.5)
	
	audio_manager.play_table_hit()
	camera.add_trauma(0.75)
	
	if caller_id == 1:
		bardo_portrait.on_truco_called()
		truco_dialog_text.text = "Sylas bateu a caneca na mesa: %s (%d pontos)!" % [call_title, bet_level]
		truco_dialog.visible = true
	else:
		await get_tree().create_timer(1.2).timeout
		var ai_resp = opponent_ai.answer_truco_call(match_manager)
		match_manager.answer_truco(1, ai_resp["accept"], ai_resp.get("raise_bet", false))

func _on_truco_answered(responder_id: int, accepted: bool, raised: bool, _bet: int) -> void:
	if responder_id == 1:
		bardo_portrait.on_truco_response(accepted, raised)

func _on_treco_activated(player_id: int, treco_name: String) -> void:
	audio_manager.play_potion()
	var msg = ("Você usou " if player_id == 0 else "Sylas usou ") + treco_name
	_show_banner(msg, Color("52b788"), 1.3)
	camera.add_trauma(0.25)
	if player_id == 1:
		bardo_portrait.on_treco_used()
	_build_treco_modal_tiles()

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
