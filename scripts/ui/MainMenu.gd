class_name MainMenu
extends Control

@onready var play_button: Button = $MenuContainer/PlayButton
@onready var rules_button: Button = $MenuContainer/RulesButton
@onready var quit_button: Button = $MenuContainer/QuitButton
@onready var rules_dialog: Panel = $RulesDialog
@onready var crt_rect: ColorRect = $CRTLayer/CRTRect
@onready var crt_toggle_btn: CheckButton = $MenuContainer/CRTToggle

func _ready() -> void:
	rules_dialog.visible = false
	play_button.pressed.connect(_on_play_pressed)
	rules_button.pressed.connect(_on_rules_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	$RulesDialog/CloseRulesButton.pressed.connect(func(): rules_dialog.visible = false)
	crt_toggle_btn.toggled.connect(_on_crt_toggled)

func _on_play_pressed() -> void:
	print("[TRECO] Carregando a Taverna...")
	var table_scene = load("res://scenes/TavernTable.tscn")
	if table_scene != null:
		get_tree().change_scene_to_packed(table_scene)
	else:
		get_tree().change_scene_to_file("res://scenes/TavernTable.tscn")

func _on_rules_pressed() -> void:
	rules_dialog.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_crt_toggled(button_pressed: bool) -> void:
	if crt_rect != null:
		crt_rect.visible = button_pressed
