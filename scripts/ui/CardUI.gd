class_name CardUI
extends Control

signal card_clicked(card_data: CardData)
signal card_hovered(card_data: CardData)

@export var card_data: CardData

var is_hovered: bool = false
var is_interactive: bool = true
var original_pos: Vector2 = Vector2.ZERO

@onready var background_panel: Panel = $BackgroundPanel
@onready var rank_label: Label = $RankLabel
@onready var suit_label: Label = $SuitLabel
@onready var manilha_glow: Panel = $ManilhaGlow
@onready var card_back: Panel = $CardBack

func _ready() -> void:
	custom_minimum_size = Vector2(90, 130)
	size = Vector2(90, 130)
	original_pos = position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
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
	
	if card_back != null:
		card_back.visible = card_data.is_face_down or (not card_data.is_revealed and not is_interactive)
	
	if rank_label != null:
		rank_label.text = card_data.get_rank_name()
		
	if suit_label != null:
		suit_label.text = _get_suit_symbol(card_data.suit)
		suit_label.modulate = _get_suit_color(card_data.suit)
	
	if manilha_glow != null:
		manilha_glow.visible = card_data.is_manilha

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
			return Color("e03e3e") # Vermelho de baralho
		CardData.Suit.ESPADAS, CardData.Suit.PAUS:
			return Color("2a2a2a") # Preto escuro
		_:
			return Color.WHITE

func _on_mouse_entered() -> void:
	if not is_interactive or card_data == null:
		return
	is_hovered = true
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", original_pos.y - 16.0, 0.15)
	card_hovered.emit(card_data)

func _on_mouse_exited() -> void:
	if not is_interactive:
		return
	is_hovered = false
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", original_pos.y, 0.15)

func _on_gui_input(event: InputEvent) -> void:
	if not is_interactive or card_data == null:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_clicked.emit(card_data)
