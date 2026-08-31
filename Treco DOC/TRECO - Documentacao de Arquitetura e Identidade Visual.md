# TRECO - Documentacao de Arquitetura e Identidade Visual

TRECO — Documentação de Arquitetura e Identidade Visual

1. Visão Geral do Projeto

TRECO é um jogo roguelike de cartas desenvolvido solo na engine Godot 4. O jogo reimagina as mecânicas do Truco tradicional dentro de um ambiente de taverna sombria, onde o jogador utiliza itens mágicos, poções e trapaças (denominados "Trecos") para manipular as regras da partida.

2. Diretrizes de Identidade Visual

A direção de arte prioriza o Minimalismo Estilizado para maximizar a eficiência de desenvolvimento solo sem comprometer a qualidade estética.

Pixel Art Eficiente: Sprites com resolução baixa/média (16x16 e 32x32), pouca variação de quadros manuais e uso de molduras reutilizáveis para cartas.

Iluminação Dinâmica 2D: Contraste marcante entre a luz quente e alaranjada da vela central (#FFAA44) e o iluminação néon verde-esmeralda (#00FF66) acionada ao ativar os "Trecos".

Pós-Processamento e Juice: Uso de filtros CRT sutis, vibração de tela (screen shake), interpolações via código (Tweens) e partículas leves.

3. Especificação da Cena Principal (TavernTable.tscn)

3.1 Árvore de Nós (Scene Tree)

TavernTable (Node2D)├── CanvasModulate (Aplica iluminação ambiente escura)├── Background (Sprite2D - Parede de tijolos e tijolos/barris)├── TableBoard (Sprite2D / TileMapLayer - Superfície de madeira)│├── Lighting (Node2D)│   └── CandleLight (PointLight2D - Luz quente central)│       └── CandleSprite (AnimatedSprite2D - Chama de 3 frames)│├── PlayedCardsArea (Node2D - Área de descarte e resolução)│   └── PlayedCard (Node2D - Instância da carta jogada)│       └── TrecoNeonLight (PointLight2D - Efeito mágico ativado)│├── PlayerHand (Node2D / Control - Mão do jogador)│└── UI_Canvas (CanvasLayer - Interface fixa)    ├── TitleLabel (Label - Logo TRECO)    └── ScoreBoard (Control - Placar de tentos)

3.2 Matriz de Componentes e Configurações de Luz

Componente

Nó Godot

Configuração / Cor

Função Principal

Luz Ambiente

CanvasModulate

#2A2024 (Roxo/Azul Escuro)

Escurecer o cenário base para destacar as luzes 2D.

Vela Central

PointLight2D

#FFAA44 (Laranja Quente), Energy: 1.2

Simular iluminação orgânica de taverna no centro da mesa.

Brilho de Treco

PointLight2D

#00FF66 (Verde Néon), Energy: 2.0

Proporcionar feedback visual (Juice) na ativação de itens.

Moldura de Carta

Sprite2D

Textura base + Ícone Dinâmico

Padronizar a criação de novas cartas mantendo baixo custo de arte.

4. Implementação de GDScript

4.1 Script da Vela (Oscilação de Luz Dinâmica)

Anexe este script ao nó CandleLight para gerar uma oscilação orgânica usando ruído Perlin:

extends PointLight2D@export var min_energy: float = 0.9@export var max_energy: float = 1.3@export var flicker_speed: float = 8.0var noise := FastNoiseLite.new()var time: float = 0.0func _ready() -> void:noise.seed = randi()noise.frequency = 0.5func _process(delta: float) -> void:time += delta * flicker_speedvar noise_val = (noise.get_noise_1d(time) + 1.0) / 2.0energy = lerp(min_energy, max_energy, noise_val)

4.2 Script de Ativação do Treco (Efeito Néon e Animação)

Anexe este script no nó da carta (Card.gd) para gerenciar o efeito de ativação:

extends Node2D@onready var neon_light: PointLight2D = $TrecoNeonLightfunc activate_treco_effect(color: Color = Color("00ff66")) -> void:neon_light.color = colorneon_light.energy = 0.0neon_light.visible = truevar tween = create_tween().set_parallel(true)tween.tween_property(neon_light, "energy", 2.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)

5. Considerações de Pipeline Solo

Reutilização de Código/Assets: Todas as cartas e itens devem derivar da mesma cena base (CardBase.tscn), alterando apenas o ícone central e o script do efeito.

Performance: Manter poucas luzes 2D ativas simultaneamente (máximo de 3 a 4 no Canvas) para garantir execução fluida em dispositivos diversos.