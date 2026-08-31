class_name CardData
extends Resource

enum Suit { OUROS = 0, ESPADAS = 1, COPAS = 2, PAUS = 3 }

@export var suit: Suit
@export var rank_value: int # 4, 5, 6, 7, 11 (Q), 12 (J), 13 (K), 1 (A), 2, 3
@export var is_manilha: bool = false
@export var is_revealed: bool = false # Para efeitos de espionagem (Olho de Lince)
@export var is_face_down: bool = false # Para blefe de carta virada (Cara de Pau)

func _init(p_suit: Suit = Suit.OUROS, p_rank: int = 4) -> void:
	suit = p_suit
	rank_value = p_rank

func get_suit_name() -> String:
	match suit:
		Suit.OUROS: return "Ouros"
		Suit.ESPADAS: return "Espadas"
		Suit.COPAS: return "Copas"
		Suit.PAUS: return "Paus"
		_: return "Desconhecido"

func get_rank_name() -> String:
	match rank_value:
		1: return "Ás"
		11: return "Dama (Q)"
		12: return "Valete (J)"
		13: return "Rei (K)"
		_: return str(rank_value)

func to_string_short() -> String:
	var label = get_rank_name() + " de " + get_suit_name()
	if is_manilha:
		label += " [MANILHA]"
	return label
