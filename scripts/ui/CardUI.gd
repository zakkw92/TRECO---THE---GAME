class_name CardUI
extends Control

signal card_clicked(card_data: CardData)
signal card_hovered(card_data: CardData)

@export var card_data: CardData

var is_hovered: bool = false
var is_interactive: bool = true
var is_animating: bool = false

@onready var front_texture: TextureRect = get_node_or_null("CardFrontTexture")
@onready var back_texture: TextureRect = get_node_or_null("CardBackTexture")
@onready var rank_label: Label = get_node_or_null("RankLabel")
@onready var suit_label: Label = get_node_or_null("SuitLabel")
@onready var manilha_glow: TextureRect = get_node_or_null("ManilhaGlow")

func _ready() -> void:
	custom_minimum_size = Vector2(90, 130)
	size = Vector2(90, 130)
	pivot_offset = size / 2.0
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	if not gui_input.is_connected(_on_gui_input):
		gui_input.connect(_on_gui_input)
	update_visuals()

func setup(p_card_data: CardData, p_interactive: bool = true) -> void:
	card_data = p_card_data
	is_interactive = p_interactive
	update_visuals()

func update_visuals() -> void:
	if card_data == null:
		visible = false
		return
	visible = true
	
	if not is_node_ready():
		return
	
	var show_back = card_data.is_face_down or (not card_data.is_revealed and not is_interactive)
	if back_texture != null:
		back_texture.visible = show_back
	if front_texture != null:
		front_texture.visible = not show_back
	
	if rank_label != null:
		rank_label.text = card_data.get_rank_name()
		rank_label.visible = not show_back
		
	if suit_label != null:
		suit_label.text = _get_suit_symbol(card_data.suit)
		suit_label.modulate = _get_suit_color(card_data.suit)
		suit_label.visible = not show_back
	
	if manilha_glow != null:
		manilha_glow.visible = card_data.is_manilha and not show_back
		if card_data.is_manilha and card_data.suit == CardData.Suit.PAUS:
			manilha_glow.modulate = Color(1.0, 0.9, 0.2, 1.0)
		elif card_data.is_manilha:
			manilha_glow.modulate = Color(0.2, 1.0, 0.6, 0.9)

func animate_flip(reveal: bool, duration: float = 0.3) -> void:
	is_animating = true
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale:x", 0.0, duration / 2.0)
	tween.tween_callback(func():
		if card_data != null:
			card_data.is_revealed = reveal
			card_data.is_face_down = not reveal
		update_visuals()
	)
	var tween_back = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween_back.tween_property(self, "scale:x", 1.0, duration / 2.0).set_delay(duration / 2.0)
	tween_back.finished.connect(func(): is_animating = false)

func animate_slam(duration: float = 0.2) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale = Vector2(1.25, 1.25)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), duration)

func _get_suit_symbol(suit: CardData.Suit) -> String:
	match suit:
		CardData.Suit.OUROS: return "♦"
		CardData.Suit.ESPADAS: return "♠"
		CardData.Suit.COPAS: return "♥"
		CardData.Suit.PAUS: return "♣"
		_: return "?"

func _get_suit_color(suit: CardData.Suit) -> Color:
	match suit:
		CardData.Suit.OUROS, CardData.Suit.COPAS:
			return Color("c1121f")
		CardData.Suit.ESPADAS, CardData.Suit.PAUS:
			return Color("101010")
		_:
			return Color.WHITE

func _on_mouse_entered() -> void:
	if not is_interactive or card_data == null or is_animating:
		return
	is_hovered = true
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", -18.0, 0.12)
	tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.12)
	card_hovered.emit(card_data)

func _on_mouse_exited() -> void:
	if not is_interactive or is_animating:
		return
	is_hovered = false
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0.0, 0.12)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.12)

func _on_gui_input(event: InputEvent) -> void:
	if not is_interactive or card_data == null or is_animating:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_clicked.emit(card_data)
