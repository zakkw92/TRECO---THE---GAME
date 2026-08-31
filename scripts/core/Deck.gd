class_name Deck
extends RefCounted

var cards: Array[CardData] = []

func _init() -> void:
	reset_and_shuffle()

func reset_and_shuffle() -> void:
	cards.clear()
	var suits = [CardData.Suit.OUROS, CardData.Suit.ESPADAS, CardData.Suit.COPAS, CardData.Suit.PAUS]
	var ranks = TrucoRules.BASE_RANKS
	
	for s in suits:
		for r in ranks:
			cards.append(CardData.new(s, r))
			
	cards.shuffle()

func draw_card() -> CardData:
	if cards.is_empty():
		push_warning("Tentativa de puxar carta de um baralho vazio!")
		return null
	return cards.pop_back()

func deal_hand(count: int = 3) -> Array[CardData]:
	var hand: Array[CardData] = []
	for i in range(count):
		var c = draw_card()
		if c:
			hand.append(c)
	return hand
