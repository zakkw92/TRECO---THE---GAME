class_name ConfusaoNoBarEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Confusão no Bar"
	description = "Troca do Vira: Redefine instantaneamente o Vira e recalcula todas as manilhas."
	energy_cost = 3
	activation_window = ActivationWindow.BLIND_BET

func apply_effect(match_manager, activator_id: int) -> bool:
	var new_vira = match_manager.deck.draw_card()
	if new_vira == null:
		match_manager.deck.reset_and_shuffle()
		new_vira = match_manager.deck.draw_card()
	match_manager.vira_card = new_vira
	match_manager._update_manilhas()
	return true
