class_name ApostaDobradaEffect
extends TrecoEffect

func _init() -> void:
	item_name = "Aposta Dobrada"
	description = "Risco Calculado: Aumenta a aposta do próximo Truco e dobra o risco se quebrado."
	energy_cost = 2
	activation_window = Window.PRE_PLAY

func apply_effect(match_manager, activator_id: int) -> bool:
	match_manager.double_bet_active[activator_id] = true
	print("[TRECO] Aposta Dobrada ativada pelo Jogador %d!" % activator_id)
	return true
