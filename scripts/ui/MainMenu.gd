class_name MainMenu
extends Control

@onready var rules_dialog: Panel = $RulesDialog
@onready var crt_rect: ColorRect = $CRTLayer/CRTRect
@onready var crt_toggle_btn: CheckButton = $MenuContainer/CRTToggle

func _ready() -> void:
	rules_dialog.visible = false
	$MenuContainer/PlayButton.pressed.connect(_on_play_pressed)
	$MenuContainer/RulesButton.pressed.connect(_on_rules_pressed)
	$MenuContainer/QuitButton.pressed.connect(_on_quit_pressed)
	$RulesDialog/CloseRulesButton.pressed.connect(func(): rules_dialog.visible = false)
	crt_toggle_btn.toggled.connect(_on_crt_toggled)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TavernTable.tscn")

func _on_rules_pressed() -> void:
	rules_dialog.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_crt_toggled(button_pressed: bool) -> void:
	crt_rect.visible = button_pressed
