# TRECO_GDD_v2.1

TRECO — Truco da Taverna

Game Design Document — Versão Consolidada e Definitiva

Versão do Documento: 2.1 (Consolidação — Blefe, Balanceamento & Arquitetura)

Gênero: Card Game / Deckbuilder / Roguelike de Taverna

Estilo Visual: Pixel Art Retrô 16-bit (Estilo Balatro / CRT Shader)

Ambientação: Taverna Fantástica / Boteco Underground

Plataformas-Alvo: PC (Steam, Itch.io) e Mobile

Engine: Godot Engine 4  ·  Arte: Aseprite  ·  Áudio: BFXR / ChipTone

Nota sobre esta Versão (2.1)

Este documento consolida o GDD original (v2.0) com as decisões de design fechadas na revisão de balanceamento e arquitetura. Ele substitui as versões anteriores e deve ser tratado como referência definitiva para o desenvolvimento.

O que mudou desde a v2.0

Regras de timing (janelas de ativação) para cada Treco; um novo grupo de Trecos de contra-blefe para equilibrar os itens de informação; um limite único de energia por rodada; reordenação do roadmap para validar o core loop já na Fase 1; e uma separação entre lógica de efeito e camada visual na arquitetura de cartas.

1. Visão Geral do Projeto

O TRECO combina a mecânica clássica e blefadora do Truco tradicional (Paulista/Mineiro) com o dinamismo de itens, trapaças e poções de uma taverna medieval/fantasiosa. O jogador enfrenta frequentadores caricatos — de bardos trapaceiros a anões bêbados — utilizando blefe, estratégia e manipulação de cartas com poções alquímicas em tempo real.

O jogo é desenvolvido solo na engine Godot 4. A direção de arte prioriza o Minimalismo Estilizado, maximizando a eficiência de desenvolvimento solo sem comprometer a qualidade estética.

Princípio de design central

O blefe é a alma do Truco. Toda nova mecânica, item ou "Treco" precisa ser avaliado quanto ao impacto que gera sobre a leitura e o blefe entre jogadores — isso é tratado como critério de aceite de design, não como detalhe estético.

2. Core Loop (Ciclo Principal de Jogo)

Início da Rodada: Distribuição de 3 cartas de baralho + revelação do Vira/Tombo + compra de Consumíveis de Taverna.

Fase de Ação: Jogadores jogam cartas na mesa de madeira e/ou ativam Trecos Alquímicos (poções, trapaças e distrações), respeitando as janelas de ativação definidas na Seção 3.

Pedido de Truco: Aumento do valor da queda (3, 6, 9, 12 pontos) acompanhado pelo som pesado da batida de caneca/mão na mesa.

Conclusão da Mão: Pontuação atribuída ao vencedor. Compra de novas poções e relíquias no Balcão do Taverneiro entre as partidas.

3. Sistema de Trecos & Itens da Taverna

Esta seção define não apenas o efeito de cada Treco, mas quando ele pode ser ativado (janela de ativação) e o custo de energia dentro do novo sistema unificado. Essas regras existem para proteger o blefe como mecânica central e evitar que a rodada vire uma disputa de "quem usou mais itens".

3.1 Sistema de Energia Unificado

Os antigos formatos de custo (consumível, energia, uso por rodada) foram unificados em um único recurso: Energia de Taverna. Cada jogador recebe uma quantidade fixa de energia por rodada (sugestão inicial: 3 pontos), e cada Treco tem um custo de energia associado.

Regra de limite (novo)

Cada jogador pode ativar no máximo 1 Treco por rodada, independente da energia disponível. Isso preserva o ritmo do truco tradicional e força escolhas estratégicas sobre qual item usar e quando, em vez de empilhar múltiplos efeitos na mesma mão.

3.2 Janelas de Ativação

Cada Treco pertence a uma das quatro janelas abaixo. Isso simplifica a máquina de estados da rodada e deixa claro, tanto para o jogador quanto para a IA, quando cada efeito é legal:

Preparação (antes da distribuição/início da rodada): itens que alteram a mão antes do jogo começar.

Pré-Jogada (durante a fase de ação, antes de jogar uma carta): itens de informação ou distração.

Reação (janela curta de 2–3 segundos após o oponente jogar uma carta): itens de manipulação direta.

Aposta às Cegas (somente antes de qualquer carta ser jogada na rodada): efeitos de altíssimo impacto, como resetar o Vira.

3.3 Tabela de Trecos — Itens Originais (Revisados)

Nome

Conceito

Efeito em Jogo

Janela

Custo

O Alquimista

Poção de Transmutação

Muda o naipe de uma carta para o da manilha máxima, ou altera seu valor em +1/-1.

Reação

2 energia

Mão Leve

Batedor de Carteira

Rouba a carta mais fraca da mão do oponente.

Reação

2 energia

Olho de Lince

Espião do Bar

Revela uma carta aleatória do adversário.

Pré-Jogada

1 energia

Cana de Hidromel

Distração de Taverna

Anula a manilha jogada pelo adversário naquela rodada.

Reação

2 energia

Confusão no Bar

Troca do Vira

Redefine instantaneamente o Vira e todas as manilhas do jogo.

Aposta às Cegas

3 energia (todo o turno)

3.4 Trecos Novos — Grupo de Contra-Blefe

Para equilibrar os itens de informação e manipulação acima, este grupo fortalece o blefe em vez de reduzi-lo. A ideia é criar uma relação de tensão entre itens de informação e itens de contra-informação, ao invés de informação fluir em uma única direção.

Nome

Conceito

Efeito em Jogo

Janela

Custo

Cara de Pau

Blefe Visual

Permite jogar uma carta virada para baixo; o oponente só descobre o valor real na resolução da rodada.

Pré-Jogada

2 energia

Fumaça de Taverna

Contra-Espionagem

Esconde sua manilha mais forte de qualquer efeito de revelação do oponente até o fim da rodada.

Pré-Jogada

1 energia

Aposta Dobrada

Risco Calculado

Aumenta o valor do próximo Truco pedido, mas dobra a pontuação cedida caso o blefe seja quebrado.

Pré-Jogada

2 energia

Por que isso importa

Fumaça de Taverna é a resposta direta ao Olho de Lince; Cara de Pau reintroduz incerteza visual num jogo onde cartas geralmente são conhecidas ao ser jogadas; Aposta Dobrada dá uma ferramenta de blefe agressivo compatível com o pedido de Truco tradicional. Nenhum item novo deve ser adicionado ao jogo sem antes se perguntar se ele reforça ou corrói o blefe.

4. Direção de Arte e Game Feel de Taverna

Pixel Art Eficiente: sprites em resolução baixa/média (16x16 e 32x32), pouca variação de quadros manuais e molduras reutilizáveis para cartas (Minimalismo Estilizado).

Iluminação Dinâmica 2D: contraste entre a luz quente da vela central (#FFAA44) e a iluminação néon verde-esmeralda (#00FF66) ao ativar um Treco.

Shader CRT / Pós-Processamento: filtros CRT sutis, screen shake, tweens via código e partículas leves.

Game Feel (Juice): som pesado de caneca/mão batendo na mesa ao pedir Truco; poções borbulhando (verde/roxo néon); brilho vibrante nas manilhas.

Audio Design: burburinho de taverna, canecas se chocando, trilha medieval/folk em chiptune 8-bit/16-bit.

5. Roadmap de Desenvolvimento (Estratégia de Escopo)

O roadmap foi reordenado para validar o ponto de maior risco do projeto — se Truco + Trecos ainda "parece Truco" — o quanto antes, em vez de deixar essa validação para depois de meses de investimento em conteúdo.

Fase 1: Protótipo Funcional + Validação de Blefe (Single-Player / IA Local)

Implementação das regras básicas do Truco (Manilhas, Vira, Pontuação de 0 a 12).

Inclusão de 1 a 2 Trecos básicos já nesta fase (recomendado: Olho de Lince + Fumaça de Taverna), para testar cedo se o núcleo de blefe se mantém.

Sistema de IA simples para testar a lógica de vitórias, rodadas e reação a Trecos.

Interface básica da mesa de madeira sem artes finais.

Fase 2: Sistema Completo de Trecos & Game Feel de Taverna

Integração de todos os Trecos (originais + grupo de contra-blefe) com o sistema de energia unificado.

Aplicação dos efeitos visuais (fumaça, brilho alquímico) e efeitos sonoros de bar/canecas.

Balanceamento das cartas de habilidade, com foco em manter o blefe como fator decisivo.

Fase 3: Modo Roguelike ("Jornada pela Taverna")

Enfrentar chefões com mecânicas próprias (O Bardo Trapaceiro, O Anão Bêbado, A Taverneira Ladrã).

Compra de poções e relíquias no "Balcão do Taverneiro" entre os confrontos.

Fase 4: Multiplayer Online

Arquitetura de rede para partidas rápidas entre jogadores.

Modo Casual e Liga dos Trapaceiros (Ranqueado).

6. Arquitetura e Ferramentas Recomendadas

Engine de Desenvolvimento: Godot Engine 4 (excelente suporte a 2D, UI e shaders CRT/iluminação).

Software de Arte: Aseprite (padrão para Pixel Art e animações de cartas/efeitos de poção).

Áudio e Efeitos: BFXR / ChipTone (para efeitos sonoros retrô de poções e pancadas na mesa).

6.1 Especificação da Cena Principal (TavernTable.tscn)

Árvore de nós (Scene Tree):

TavernTable (Node2D)

├── CanvasModulate (Aplica iluminação ambiente escura)

├── Background (Sprite2D - Parede de tijolos e barris)

├── TableBoard (Sprite2D / TileMapLayer - Superfície de madeira)

│

├── Lighting (Node2D)

│   └── CandleLight (PointLight2D - Luz quente central)

│       └── CandleSprite (AnimatedSprite2D - Chama de 3 frames)

│

├── PlayedCardsArea (Node2D - Área de descarte e resolução)

│   └── PlayedCard (Node2D - Instância da carta jogada)

│       └── TrecoNeonLight (PointLight2D - Efeito mágico ativado)

│

├── PlayerHand (Node2D / Control - Mão do jogador)

│

└── UI_Canvas (CanvasLayer - Interface fixa)

├── TitleLabel (Label - Logo TRECO)

└── ScoreBoard (Control - Placar de tentos)

6.2 Matriz de Componentes e Configurações de Luz

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

6.3 Separação de Lógica e Efeito Visual (Nova Diretriz de Arquitetura)

Para reduzir código repetido conforme a lista de Trecos cresce, a lógica de efeito (mudar naipe, roubar carta, esconder informação, etc.) deve ser separada da camada visual (neon, tween, partícula). Sugestão de estrutura:

TrecoEffect (classe base): define a interface aplicar_efeito(jogo_state) para a lógica de jogo pura, sem nenhuma referência visual.

Cada Treco (ex: AlquimistaEffect, MaoLeveEffect) herda de TrecoEffect e implementa apenas sua lógica específica.

A camada visual (neon, tween, scale) permanece genérica em Card.gd e é acionada após o efeito lógico ser resolvido, reutilizando a mesma animação para todos os Trecos.

Isso mantém o script de ativação abaixo como camada puramente visual, independente da lógica de qual Treco foi ativado.

Script da Vela (Oscilação de Luz Dinâmica)

Anexar ao nó CandleLight para gerar oscilação orgânica com ruído Perlin:

extends PointLight2D

@export var min_energy: float = 0.9

@export var max_energy: float = 1.3

@export var flicker_speed: float = 8.0

var noise := FastNoiseLite.new()

var time: float = 0.0

func _ready() -> void:

noise.seed = randi()

noise.frequency = 0.5

func _process(delta: float) -> void:

time += delta * flicker_speed

var noise_val = (noise.get_noise_1d(time) + 1.0) / 2.0

energy = lerp(min_energy, max_energy, noise_val)

Script de Ativação do Treco (Camada Visual)

Anexar ao nó da carta (Card.gd) para gerenciar apenas o efeito visual de ativação, desacoplado da lógica do Treco:

extends Node2D

@onready var neon_light: PointLight2D = $TrecoNeonLight

func activate_treco_effect(color: Color = Color("00ff66")) -> void:

neon_light.color = color

neon_light.energy = 0.0

neon_light.visible = true

var tween = create_tween().set_parallel(true)

tween.tween_property(neon_light, "energy", 2.0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)

tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)

6.4 Considerações de Pipeline Solo

Reutilização de Código/Assets: todas as cartas e itens devem derivar da mesma cena base (CardBase.tscn), alterando apenas o ícone central e o script de efeito lógico (TrecoEffect).

Performance: manter poucas luzes 2D ativas simultaneamente (máximo de 3 a 4 no Canvas) para garantir execução fluida em dispositivos diversos.

Validação Contínua: a cada novo Treco adicionado, revalidar contra o princípio de design central (Seção 1) antes de seguir para produção de arte final.