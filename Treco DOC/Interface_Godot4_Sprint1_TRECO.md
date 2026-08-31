# Interface_Godot4_Sprint1_TRECO

TRECO — Truco da Taverna

Especificação de Interface (UI) e Integração — Sprint 1

Módulo: Interface de Usuário (UI)

Engine: Godot Engine 4 (GDScript)

Cena Principal: TestMain.tscn

Objetivo: Validação Visual e Teste de Loop

1. Estrutura de Nós na Cena (TestMain.tscn)

Esta é a hierarquia de nós que deve ser montada no Godot para a cena principal de testes. Ela conecta os gerenciadores (DeckManager e GameState) com os elementos visuais (CanvasLayer).

📄 Hierarquia da Cena

TestMain (Node2D)  -> Anexar o script Main.gd aqui├── DeckManager (Node) -> Anexar DeckManager.gd├── GameState (Node)   -> Anexar GameState.gd└── UI (CanvasLayer)    ├── Background (ColorRect - Cor: #2A2024 para clima de taverna)    ├── ViraLabel (Label - Centralizado na tela)    ├── PlacarLabel (Label - No topo da tela)    ├── LogRichText (RichTextLabel - Histórico de jogadas)    ├── TrucoButton (Button - No canto inferior direito)    └── PlayerHand (HBoxContainer - Centralizado na parte inferior)        ├── CardButton1 (Button)        ├── CardButton2 (Button)        └── CardButton3 (Button)

2. Script Principal (Main.gd)

Este script atua como o controlador da interface. Ele inicializa a rodada buscando dados do DeckManager, atualiza a tela e envia as ações do jogador (jogar carta, pedir truco) para o GameState.

📄 Script: res://scripts/main/Main.gd

extends Node2D@onready var deck_manager: DeckManager = $DeckManager@onready var game_state: GameState = $GameState# Referências da UI@onready var vira_label: Label = $UI/ViraLabel@onready var placar_label: Label = $UI/PlacarLabel@onready var log_text: RichTextLabel = $UI/LogRichText@onready var player_hand_container: HBoxContainer = $UI/PlayerHand@onready var truco_button: Button = $UI/TrucoButtonvar player_cards: Array[CardData] = []var ai_cards: Array[CardData] = []func _ready() -> void:# Conecta os sinais do GameStategame_state.score_changed.connect(_on_score_changed)game_state.truco_called.connect(_on_truco_called)# Conecta os botões de cartasfor i in range(player_hand_container.get_child_count()):var btn = player_hand_container.get_child(i) as Buttonbtn.pressed.connect(_on_card_played.bind(i))truco_button.pressed.connect(_on_truco_button_pressed)start_new_hand()func start_new_hand() -> void:log_text.text = "Nova mão iniciada!\n"game_state.reset_hand_state()update_placar_ui()# Pega os dados da nova rodada (Cartas + Vira)var round_data = deck_manager.setup_round()player_cards = round_data["player_hand"]ai_cards = round_data["ai_hand"]var vira: CardData = round_data["vira"]# Atualiza o Vira na UIvira_label.text = "VIRA: " + get_card_name(vira) + "\n(Manilha: " + get_rank_name(deck_manager.manilha_rank) + ")"update_hand_ui()# Atualiza os textos dos botões com as cartas do jogadorfunc update_hand_ui() -> void:for i in range(3):var btn = player_hand_container.get_child(i) as Buttonif i < player_cards.size():btn.text = get_card_name(player_cards[i])btn.disabled = falsebtn.visible = trueelse:btn.visible = false# Quando o jogador clica em uma cartafunc _on_card_played(card_index: int) -> void:var p_card = player_cards[card_index]player_cards.remove_at(card_index)# IA joga uma carta aleatória (Nível 0)var ai_index = randi() % ai_cards.size()var ai_card = ai_cards[ai_index]ai_cards.remove_at(ai_index)log_text.text += "\nVocê jogou: " + get_card_name(p_card)log_text.text += "\nIA jogou: " + get_card_name(ai_card)# Resolve o turnovar winner = game_state.resolve_turn(p_card, ai_card, deck_manager)log_text.text += "\nVencedor do turno: " + winner + "\n"update_hand_ui()check_hand_end()# Verifica se alguém ganhou 2 rodadasfunc check_hand_end() -> void:if game_state.rounds_won_player == 2:log_text.text += "\nVOCÊ VENCEU A MÃO!"game_state.end_hand("PLAYER")await get_tree().create_timer(2.0).timeoutstart_new_hand()elif game_state.rounds_won_ai == 2:log_text.text += "\nIA VENCEU A MÃO!"game_state.end_hand("AI")await get_tree().create_timer(2.0).timeoutstart_new_hand()elif player_cards.size() == 0:# Empate triplolog_text.text += "\nEMPATE NA MÃO!"game_state.end_hand("EMPATE")await get_tree().create_timer(2.0).timeoutstart_new_hand()func _on_truco_button_pressed() -> void:game_state.raise_truco(true)func _on_truco_called(by_player: bool, new_value: int) -> void:var caller = "Você" if by_player else "IA"log_text.text += "\n" + caller + " pediu TRUCO! Queda valendo " + str(new_value)truco_button.text = "Pedir " + get_next_truco_name(new_value)func _on_score_changed(p_score: int, a_score: int) -> void:update_placar_ui()truco_button.text = "Pedir Truco"if p_score >= 12:log_text.text += "\n\n🎉 VOCÊ VENCEU O JOGO! 🎉"elif a_score >= 12:log_text.text += "\n\n💀 IA VENCEU O JOGO! 💀"func update_placar_ui() -> void:placar_label.text = "Você: " + str(game_state.player_score) + " | IA: " + str(game_state.ai_score)# --- Funções Auxiliares de Formatação ---func get_card_name(card: CardData) -> String:var suits = ["♦ Ouros", "♠ Espadas", "♥ Copas", "♣ Paus"]return get_rank_name(card.rank) + " de " + suits[card.suit]func get_rank_name(rank: int) -> String:match rank:1: return "Ás"10: return "Dama"11: return "Valete"12: return "Rei"_: return str(rank)func get_next_truco_name(current: int) -> String:match current:3: return "Seis"6: return "Nove"9: return "Doze"_: return "Truco"