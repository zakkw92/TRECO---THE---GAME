class_name TrecoEffect
extends Resource

enum Window { PREPARATION, PRE_PLAY, REACTION, BLIND_BET }

@export var item_name: String = "Treco"
@export var description: String = "Efeito de item alquímico."
@export var energy_cost: int = 1
@export var activation_window: Window = Window.PRE_PLAY

# Método virtual a ser sobrescrito por cada Treco específico
func apply_effect(match_manager, activator_id: int) -> bool:
	push_error("apply_effect() não foi implementado para este Treco!")
	return false
