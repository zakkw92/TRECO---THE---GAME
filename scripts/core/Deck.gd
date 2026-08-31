class_name Deck
extends RefCounted

var cards: Array[CardData] = []

const RANKS: Array[int] = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
const SUITS: Array[CardData.Suit] = [
	CardData.Suit.OUROS,
	CardData.Suit.ESPADAS,
	CardData.Suit.COPAS,
	CardData.Suit.PAUS
]

func _init() -> void:
	reset_and_shuffle()

func reset_and_shuffle() -> void:
	cards.clear()
	for s in SUITS:
		for r in RANKS:
			cards.append(CardData.new(s, r))
	cards.shuffle()

func draw_card() -> CardData:
	if cards.is_empty():
		return null
	return cards.pop_back()

func deal_hand(hand_size: int = 3) -> Array[CardData]:
	var hand: Array[CardData] = []
	for i in range(hand_size):
		var c = draw_card()
		if c != null:
			hand.append(c)
	return hand
