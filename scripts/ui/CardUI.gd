class_name CardUI
extends Control

signal card_clicked(card_data: CardData)
signal card_hovered(card_data: CardData)

@export var card_data: CardData

var is_hovered: bool = false
var is_interactive: bool = true
var is_animating: bool = false
var base_position: Vector2 = Vector2.ZERO

@onready var background_panel: Panel = $BackgroundPanel
@onready var rank_label: Label = $RankLabel
@onready var suit_label: Label = $SuitLabel
@onready var manilha_glow: Panel = $ManilhaGlow
@onready var card_back: Panel = $CardBack

func _ready() -> void:
	custom_minimum_size = Vector2(90, 130)
	size = Vector2(90, 130)
	pivot_offset = size / 2.0
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
	
	var show_back = card_data.is_face_down or (not card_data.is_revealed and not is_interactive)
	if card_back != null:
		card_back.visible = show_back
	
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
			# Zap brilha em dourado néon pulsante
			manilha_glow.modulate = Color(1.0, 0.9, 0.2, 0.9)
		elif card_data.is_manilha:
			manilha_glow.modulate = Color(0.2, 1.0, 0.5, 0.7)

# Animação de virar a carta (Flip 2.5D)
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

# Animação de deslizar até uma posição alvo na mesa
func animate_slide_to(target_global_pos: Vector2, target_rotation: float = 0.0, duration: float = 0.35) -> void:
	is_animating = true
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_global_pos, duration)
	tween.tween_property(self, "rotation", target_rotation, duration)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), duration * 0.5)
	tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), duration * 0.5)
	tween.finished.connect(func(): is_animating = false)

# Animação de impacto/sucesso
func animate_slam(duration: float = 0.2) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale = Vector2(1.3, 1.3)
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
			return Color("e63946") # Vermelho vibrante
		CardData.Suit.ESPADAS, CardData.Suit.PAUS:
			return Color("1d2d44") # Azul escuro/preto de baralho
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
