# Codigo_Godot4_Sprint1_TRECO

TRECO — Truco da Taverna

Especificação Técnica e Código GDScript — Sprint 1 (Godot Engine 4)

Sprint de Origem: Sprint 1 (Semanas 1 e 2)

Engine: Godot Engine 4 (GDScript)

Módulos Inclusos: CardData, DeckManager, GameState

Arquitetura: Desacoplada (Data / Lógica)

1. Visão Geral da Arquitetura de Código (Sprint 1)

Objetivo:Este documento apresenta a implementação dos scripts fundamentais do jogo em GDScript para Godot 4, cobrindo todo o escopo definido para a Sprint 1. Os scripts seguem o padrão de desacoplamento, separando estritamente as estruturas de dados, a lógica de baralho e a máquina de estados da partida.

2. Código Fonte GDScript para Godot 4

Módulo 1 — CardData.gd: Recurso customizado (Resource) responsável por armazenar a estrutura de cada carta individual e sua hierarquia de força base no Truco.

📄 Script: res://scripts/resources/CardData.gd

class_name CardDataextends Resourceenum Suit { OUROS, ESPADAS, COPAS, PAUS }@export var suit: Suit@export var rank: int # 1 (Ás), 2, 3, 4, 5, 6, 7, 10 (Dama), 11 (Valete), 12 (Rei)@export var is_face_down: bool = false# Retorna a hierarquia base do Truco (sem contar a Manilha)func get_base_power() -> int:match rank:3: return 102: return 91: return 8 # Ás12: return 7 # Rei11: return 6 # Valete10: return 5 # Dama7: return 46: return 35: return 24: return 1_: return 0

Módulo 2 — DeckManager.gd: Gerenciador responsável por criar o baralho de 40 cartas, realizar o embaralhamento, definir o Vira e calcular dinamicamente a força das Manilhas com base nos naipes.

📄 Script: res://scripts/managers/DeckManager.gd

class_name DeckManagerextends Nodevar deck: Array[CardData] = []var vira: CardDatavar manilha_rank: intfunc _ready() -> void:reset_deck()# Cria o baralho tradicional de Truco (40 cartas)func create_standard_deck() -> void:deck.clear()var valid_ranks = [1, 2, 3, 4, 5, 6, 7, 10, 11, 12]for suit in [CardData.Suit.OUROS, CardData.Suit.ESPADAS, CardData.Suit.COPAS, CardData.Suit.PAUS]:for rank in valid_ranks:var card = CardData.new()card.suit = suitcard.rank = rankdeck.append(card)func reset_deck() -> void:create_standard_deck()deck.shuffle()# Distribui e define o Vira da rodadafunc setup_round() -> Dictionary:reset_deck()# Puxa o Viravira = deck.pop_back()manilha_rank = calculate_manilha_rank(vira.rank)# Distribui 3 cartas para o Jogador e 3 para a IAvar player_hand: Array[CardData] = []var ai_hand: Array[CardData] = []for i in range(3):player_hand.append(deck.pop_back())ai_hand.append(deck.pop_back())return {"vira": vira,"player_hand": player_hand,"ai_hand": ai_hand}# Define qual rank vira manilha baseado no Vira (ex: Vira 4 -> Manilha 5)func calculate_manilha_rank(vira_r: int) -> int:var sequence = [1, 2, 3, 4, 5, 6, 7, 10, 11, 12]var idx = sequence.find(vira_r)var next_idx = (idx + 1) % sequence.size()return sequence[next_idx]# Calcula a força real de uma carta na rodada atualfunc get_card_power(card: CardData) -> int:if card.rank == manilha_rank:# Se for Manilha, o desempate é pelo Naipe (Paus > Copas > Espadas > Ouros)match card.suit:CardData.Suit.PAUS: return 20CardData.Suit.COPAS: return 19CardData.Suit.ESPADAS: return 18CardData.Suit.OUROS: return 17return card.get_base_power()

Módulo 3 — GameState.gd: Gerenciador do estado global da partida, controlando tentos acumulados (0 a 12), solicitações de aumento de aposta (Truco/Seis/Nove/Doze) e resolução de rodadas.

📄 Script: res://scripts/managers/GameState.gd

class_name GameStateextends Nodesignal score_changed(player_score: int, ai_score: int)signal truco_called(by_player: bool, current_value: int)var player_score: int = 0var ai_score: int = 0# Estado da Mão Atualvar current_hand_value: int = 1 # Começa valendo 1var rounds_won_player: int = 0var rounds_won_ai: int = 0var current_round_index: int = 0 # 0, 1, 2# Solicita aumento de aposta (Truco -> Seis -> Nove -> Doze)func raise_truco(by_player: bool) -> void:match current_hand_value:1: current_hand_value = 33: current_hand_value = 66: current_hand_value = 99: current_hand_value = 12_: returntruco_called.emit(by_player, current_hand_value)# Resolve o vencedor de uma jogada individualfunc resolve_turn(player_card: CardData, ai_card: CardData, deck_mgr: DeckManager) -> String:var p_power = deck_mgr.get_card_power(player_card)var ai_power = deck_mgr.get_card_power(ai_card)if p_power > ai_power:rounds_won_player += 1return "PLAYER"elif ai_power > p_power:rounds_won_ai += 1return "AI"else:return "EMPATE"# Finaliza a mão e atribui a pontuaçãofunc end_hand(winner: String) -> void:if winner == "PLAYER":player_score += current_hand_valueelif winner == "AI":ai_score += current_hand_valuescore_changed.emit(player_score, ai_score)reset_hand_state()func reset_hand_state() -> void:current_hand_value = 1rounds_won_player = 0rounds_won_ai = 0current_round_index = 0

3. Instruções de Integração no Godot 4

Passo a Passo: 1. Crie a estrutura de pastas no projeto: `res://scripts/resources/` e `res://scripts/managers/`.

2. Adicione os três arquivos acima respeitando os nomes das classes (`class_name`).

3. Em uma cena de teste (`TestMain.tscn`), adicione dois nós e anexe os scripts `DeckManager.gd` e `GameState.gd`.

4. Execute `deck_mgr.setup_round()` no método `_ready()` para validar a distribuição e as manilhas no console Godot.