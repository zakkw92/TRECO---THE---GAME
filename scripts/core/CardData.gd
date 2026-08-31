class_name CardData
extends Resource

enum Suit { OUROS, ESPADAS, COPAS, PAUS }

@export var suit: Suit
@export var rank_value: int
@export var is_manilha: bool = false
@export var is_revealed: bool = false
@export var is_face_down: bool = false

func _init(p_suit: Suit = Suit.OUROS, p_rank_value: int = 4) -> void:
	suit = p_suit
	rank_value = p_rank_value

func get_rank_name() -> String:
	match rank_value:
		4: return "4"
		5: return "5"
		6: return "6"
		7: return "7"
		8: return "Q"
		9: return "J"
		10: return "K"
		11: return "A"
		12: return "2"
		13: return "3"
		_: return str(rank_value)

func get_suit_name() -> String:
	match suit:
		Suit.OUROS: return "Ouros"
		Suit.ESPADAS: return "Espadas"
		Suit.COPAS: return "Copas"
		Suit.PAUS: return "Paus"
		_: return "Desconhecido"

func to_string_short() -> String:
	return "%s de %s" % [get_rank_name(), get_suit_name()]
