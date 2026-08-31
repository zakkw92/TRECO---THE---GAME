# GDD — Truco da Taverna V2

TRECO — Truco da Taverna V2

Gênero: Card Game / Deckbuilder / Roguelike de Taverna

Estilo Visual: Pixel Art Retrô 16-bit (Estilo Balatro/CRT Shader)

Ambientação: Taverna Fantástica / Boteco Underground

Plataformas-Alvo: PC (Steam, Itch.io) e Mobile

Versão do Documento: 2.0 (Atualizado — Temática de Taverna & Alquimia)

1. Visão Geral do Projeto

O Truco da Taverna combina a mecânica clássica e blefadora do Truco tradicional (Paulista/Mineiro) com o dinamismo de itens, trambiques e poções de uma taverna medieval/fantasiosa. O jogador enfrenta frequentadores caricatos — de bardos trapaceiros a anões bêbados — utilizando blefe, estratégia e manipulação de cartas com poções alquímicas em tempo real.

2. Core Loop (Ciclo Principal de Jogo)

Início da Rodada: Distribuição de 3 cartas de baralho + revelação do Vira/Tombo + compra de Consumíveis de Taverna.

Fase de Ação: Jogadores jogam cartas na mesa de madeira e/ou ativam Power-ups Alquímicos (poções, trambiques e distração).

Pedido de Truco: Aumento do valor da queda (3, 6, 9, 12 pontos) acompanhado pelo som pesado da batida de caneca/mão na mesa.

Conclusão da Mão: Pontuação atribuída ao vencedor. Compra de novas poções e relíquias no Balcão do Taverneiro entre as partidas.

3. Sistema de Power-ups & Itens da Taverna

Os Power-ups foram integrados à temática da taverna como poções, trapaças e distrações de bar.

Nome do Item / Power-up

Conceito de Taverna

Efeito em Jogo

Custo / Limite

O Alquimista

Poção de Transmutação

Derrama um líquido néon sobre uma carta para mudar seu naipe para o da manilha máxima ou alterar seu valor em +1/-1.

Consumível (1x por partida)

Mão Leve

Batedor de Carteira

Uma mão surge por baixo da mesa de madeira para roubar a carta mais fraca da mão do oponente.

Consumível

Olho de Lince

Espião do Bar

O taverneiro ou um comparsa faz um sinal discreto revelando uma carta aleatória do adversário.

1 uso por rodada

Cana de Hidromel

Distração de Taverna

Entorna a bebida na mesa para "sujar" ou anular a manilha jogada pelo adversário naquela rodada.

Requer 2 pontos de energia

Confusão no Bar

Troca do Vira

Inicia uma briga de bar para virar a mesa e redefinir instantaneamente o Vira e todas as manilhas do jogo.

Consumível (Risco/Recompensa)

4. Direção de Arte e Game Feel de Taverna

Pixel Art 16-bit: Cartas detalhadas com animações em pixel art, mesa de madeira gasta com marcas de copos e velas tremeluzindo.

Shader CRT / Iluminação Quente: Filtro retrô que simula luz de tochas e fumaça flutuando sobre a mesa.

Game Feel (Juice): Som pesado de caneca/mão batendo na mesa ao pedir Truco, animações de poções borbulhando (verde/roxo néon) e brilho vibrante nas manilhas.

Audio Design: Som de fundo com burburinho de taverna, canecas se chocando e trilha sonora medieval/folk em chiptune 8-bit/16-bit.

5. Roadmap de Desenvolvimento (Estratégia de Escopo)

Fase 1: Protótipo Funcional (Single-Player / IA Local)

- Implementação das regras básicas do Truco (Manilhas, Vira, Pontuação de 0 a 12).- Sistema de IA simples para testar a lógica de vitórias e rodadas.- Interface básica da mesa de madeira sem artes finais.

Fase 2: Sistema de Poções & Game Feel de Taverna

- Integração da Poção do Alquimista e demais itens de taverna.- Aplicação dos efeitos visuais (fumaça, brilho alquímico) e efeitos sonoros de bar/canecas.- Balanceamento das cartas de habilidades.

Fase 3: Modo Roguelike ("Jornada pela Taverna")

- Enfrentar chefões com mecânicas próprias (O Bardo Trapaceiro, O Anão Bêbado, A Taverneira Ladrã).- Compra de poções e relíquias no "Balcão do Taverneiro" entre os confrontos.

Fase 4: Multiplayer Online

- Arquitetura de rede para partidas rápidas entre jogadores.- Modo Casual e Liga dos Trapaceiros (Ranqueado).

6. Arquitetura e Ferramentas Recomendadas

Engine de Desenvolvimento: Godot Engine 4 (excelente suporte a 2D, UI e shaders CRT/iluminação).

Software de Arte: Aseprite (padrão para Pixel Art e animações de cartas/efeitos de poção).

Áudio e Efeitos: BFXR / ChipTone (para efeitos sonoros retrô de poções e pancadas na mesa).