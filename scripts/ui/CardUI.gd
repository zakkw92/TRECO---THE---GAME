class_name CardUI
extends Control

signal card_clicked(card_data: CardData)
signal card_hovered(card_data: CardData)

@export var card_data: CardData

# Propriedades de Estado
var is_hovered: bool = false
var is_interactive: bool = true
var is_face_down_override: bool = false

# Física de Molas no VisualRoot
var spring_pos: Vector2 = Vector2.ZERO
var spring_vel: Vector2 = Vector2.ZERO
var spring_rot: float = 0.0
var spring_rot_vel: float = 0.0
var spring_scale: Vector2 = Vector2.ONE
var spring_scale_vel: Vector2 = Vector2.ZERO

var target_pos: Vector2 = Vector2.ZERO
var target_rot: float = 0.0
var target_scale: Vector2 = Vector2.ONE

const SPRING_STIFFNESS: float = 240.0
const SPRING_DAMPING: float = 16.0

# Inclinação 3D
var current_tilt: Vector2 = Vector2.ZERO
var target_tilt: Vector2 = Vector2.ZERO

@onready var visual_root: Control = get_node_or_null("VisualRoot")
@onready var shadow_rect: ColorRect = get_node_or_null("VisualRoot/CardShadow")
@onready var front_texture: TextureRect = get_node_or_null("VisualRoot/CardFrontTexture")
@onready var back_texture: TextureRect = get_node_or_null("VisualRoot/CardBackTexture")
@onready var top_rank_label: Label = get_node_or_null("VisualRoot/TopRankLabel")
@onready var bottom_rank_label: Label = get_node_or_null("VisualRoot/BottomRankLabel")
@onready var center_suit_label: Label = get_node_or_null("VisualRoot/CenterSuitLabel")
@onready var manilha_glow: TextureRect = get_node_or_null("VisualRoot/ManilhaGlow")

var card_material: ShaderMaterial

func _ready() -> void:
	custom_minimum_size = Vector2(95, 135)
	size = Vector2(95, 135)
	if visual_root != null:
		visual_root.pivot_offset = size / 2.0
	
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	if not gui_input.is_connected(_on_gui_input):
		gui_input.connect(_on_gui_input)
	
	_setup_shader_material()
	update_visuals()

func _setup_shader_material() -> void:
	var shader = preload("res://shaders/card_tilt.gdshader")
	card_material = ShaderMaterial.new()
	card_material.shader = shader
	if front_texture != null:
		front_texture.material = card_material
	if back_texture != null:
		back_texture.material = null

func setup(p_card_data: CardData, p_interactive: bool = true, p_force_face_down: bool = false) -> void:
	card_data = p_card_data
	is_interactive = p_interactive
	is_face_down_override = p_force_face_down
	update_visuals()

func _process(delta: float) -> void:
	_update_spring_physics(delta)
	_update_card_tilt(delta)

func _update_spring_physics(delta: float) -> void:
	if visual_root == null:
		return
	
	# 1. Posição da Mola (VisualRoot relativo ao slot da carta)
	var force_pos = (target_pos - spring_pos) * SPRING_STIFFNESS - spring_vel * SPRING_DAMPING
	spring_vel += force_pos * delta
	spring_pos += spring_vel * delta
	visual_root.position = spring_pos
	
	# 2. Rotação da Mola
	var force_rot = (target_rot - spring_rot) * SPRING_STIFFNESS - spring_rot_vel * SPRING_DAMPING
	spring_rot_vel += force_rot * delta
	spring_rot += spring_rot_vel * delta
	visual_root.rotation = spring_rot
	
	# 3. Escala (Squash & Stretch)
	var force_scale = (target_scale - spring_scale) * (SPRING_STIFFNESS * 1.2) - spring_scale_vel * SPRING_DAMPING
	spring_scale_vel += force_scale * delta
	spring_scale += spring_scale_vel * delta
	visual_root.scale = spring_scale

func _update_card_tilt(delta: float) -> void:
	if is_hovered and is_interactive:
		var local_mouse = get_local_mouse_position()
		var norm_x = clamp((local_mouse.x / size.x) * 2.0 - 1.0, -1.0, 1.0)
		var norm_y = clamp((local_mouse.y / size.y) * 2.0 - 1.0, -1.0, 1.0)
		target_tilt = Vector2(norm_x, norm_y)
	else:
		target_tilt = Vector2.ZERO
	
	current_tilt = current_tilt.lerp(target_tilt, delta * 14.0)
	
	if card_material != null:
		card_material.set_shader_parameter("mouse_offset", current_tilt)
	
	if shadow_rect != null:
		var shadow_dist = 14.0 if is_hovered else 5.0
		shadow_rect.position = Vector2(4.0, 4.0) - current_tilt * shadow_dist
		shadow_rect.modulate.a = 0.45 if is_hovered else 0.25

func update_visuals() -> void:
	if card_data == null:
		visible = false
		return
	visible = true
	
	if not is_node_ready():
		return
	
	var show_back = is_face_down_override or card_data.is_face_down
	if card_data.is_revealed:
		show_back = false
	if back_texture != null:
		back_texture.visible = show_back
	
	var has_custom_sprite = false
	if front_texture != null:
		front_texture.visible = not show_back
		if not show_back:
			var sprite_path = "res://assets/sprites/cards/card_%d_%d.png" % [card_data.suit, card_data.rank_value]
			if ResourceLoader.exists(sprite_path):
				front_texture.texture = load(sprite_path)
				has_custom_sprite = true
	
	var r_text = card_data.get_rank_name()
	if top_rank_label != null:
		top_rank_label.text = r_text
		top_rank_label.visible = not show_back and not has_custom_sprite
	if bottom_rank_label != null:
		bottom_rank_label.text = r_text
		bottom_rank_label.visible = not show_back and not has_custom_sprite
		
	if center_suit_label != null:
		center_suit_label.text = _get_suit_symbol(card_data.suit)
		center_suit_label.modulate = _get_suit_color(card_data.suit)
		center_suit_label.visible = not show_back and not has_custom_sprite
	
	if manilha_glow != null:
		manilha_glow.visible = card_data.is_manilha and not show_back
	
	if card_material != null:
		var show_foil = card_data.is_manilha and not show_back
		var is_zap = card_data.is_manilha and card_data.suit == CardData.Suit.PAUS and not show_back
		card_material.set_shader_parameter("is_manilha", show_foil)
		card_material.set_shader_parameter("is_zap", is_zap)
		card_material.set_shader_parameter("foil_intensity", 0.6 if show_foil else 0.0)

func animate_flip(reveal: bool, duration: float = 0.3) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "target_scale:x", 0.0, duration / 2.0)
	tween.tween_callback(func():
		if card_data != null:
			card_data.is_revealed = reveal
			card_data.is_face_down = not reveal
		is_face_down_override = not reveal
		update_visuals()
	)
	var tween_back = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween_back.tween_property(self, "target_scale:x", 1.0, duration / 2.0).set_delay(duration / 2.0)

func animate_slam(duration: float = 0.22) -> void:
	spring_scale = Vector2(1.35, 1.35)
	spring_scale_vel = Vector2(-2.0, -2.0)
	target_scale = Vector2.ONE

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
			return Color("151515")
		_:
			return Color.WHITE

func _on_mouse_entered() -> void:
	if not is_interactive or card_data == null:
		return
	is_hovered = true
	target_pos = Vector2(0.0, -26.0)
	target_scale = Vector2(1.12, 1.12)
	target_rot = randf_range(-0.04, 0.04)
	z_index = 10
	card_hovered.emit(card_data)

func _on_mouse_exited() -> void:
	if not is_interactive:
		return
	is_hovered = false
	target_pos = Vector2.ZERO
	target_scale = Vector2.ONE
	target_rot = 0.0
	z_index = 0

func _on_gui_input(event: InputEvent) -> void:
	if not is_interactive or card_data == null:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spring_scale = Vector2(0.92, 0.92)
		card_clicked.emit(card_data)
