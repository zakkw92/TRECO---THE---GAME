# Plano_Desenvolvimento_Demo_TRECO

TRECO — Truco da Taverna

Plano Operacional e Roadmap de Desenvolvimento da Demo (2 Meses / 8 Semanas)

Engine & Ferramentas: Godot Engine 4 | Aseprite | BFXR

Duração do Plano: 8 Semanas (2 Meses)

Escopo da Demo: Single-Player (IA Local / Oponente Bardo)

Meta de Lançamento: Build PC & Web (Itch.io)

1. Análise Executiva do GDD (v2.1)

Visão Geral: O GDD v2.1 consolidou perfeitamente as regras de negócio e arquitetura técnica. A decisão de travar o uso de Trecos em no máximo 1 por rodada e unificar o recurso em Energia de Taverna protege a alma do jogo: a leitura de jogadas e o blefe clássico do Truco.

Princípio Diretor da Demo

A demo não tentará implementar o modo Roguelike completo ou Multiplayer, mas sim validar com perfeição o Core Loop: se a combinação de Truco + Trecos Alquímicos entrega um gameplay divertido, tenso e fluido contra uma IA reativa de taverna.

2. Cronograma Detalhado por Sprints (8 Semanas)

Mês 1: Core Engine, Regras & Lógica de Blefe

Sprint 1 (Semanas 1 e 2) — O Truco Funcional: Implementação do ciclo fundamental do Truco Paulista/Mineiro em interface limpa e prototípica. Criação das estruturas de baralho (40 cartas), regras de Vira e Manilhas, cálculo de tentos (0 a 12) e fluxo de aumento de aposta (3, 6, 9, 12). Implementação de IA Nível 0 para validação de partidas completas.

Sprint 2 (Semanas 3 e 4) — Sistema de Trecos & IA de Blefe: Integração do sistema de Energia de Taverna (3 pontos por rodada, limite rígido de 1 Treco por rodada). Criação da classe base desacoplada TrecoEffect e integração dos 4 Trecos principais: Olho de Lince (Revelação), Fumaça de Taverna (Contra-espionagem), O Alquimista (Transmutação) e Cara de Pau (Carta virada). Atualização da IA para considerar janelas de ativação.

Mês 2: Atmosfera, Game Feel & Polimento

Sprint 3 (Semanas 5 e 6) — Visual, Iluminação e Game Feel: Montagem da cena principal TavernTable.tscn com iluminação 2D (CanvasModulate, luz quente central de vela com script de ruído Perlin). Animações de cartas via Tweens, efeitos visuais de poção em tom esmeralda (#00FF66) e sound design (pancada de caneca na mesa no pedido de Truco, barulho de cartas e borbulhar de poções).

Sprint 4 (Semanas 7 e 8) — Oponente Temático, Build & Lançamento: Criação do oponente temático 'O Bardo Trapaceiro' com retrato em Pixel Art 16-bit e falas reativas em balões de diálogo. Aplicação de Shader CRT sutil de pós-processamento, telas de Menu Inicial e Resultado. Testes intensivos de bugs, balanceamento e exportação de builds para Windows e HTML5 (Itch.io).

3. Matriz de Acompanhamento e Metas Semanais

Semana

Foco Principal

Entregável Chave

Critério de Aceite

Semana 1

Lógica de Cartas

Baralho, Vira, Manilhas e Distribuição

Partida roda distribuições sem erros de naipe/manilha

Semana 2

Fluxo da Mão

Sistema de Truco/Seis/Nove/Doze e Placar

Pontuação acumula corretamente até 12 tentos

Semana 3

Energia e Trecos

Energia (3 pts) e Trava de 1 Treco/rodada

Sistema bloqueia 2º Treco na mesma rodada

Semana 4

Loop de Blefe

4 Trecos Iniciais + IA Reativa às Janelas

Fumaça de Taverna anula Olho de Lince com sucesso

Semana 5

Cena & Luz 2D

TavernTable.tscn + Script de Vela (Perlin)

Vela oscila dinamicamente sem impactar performance

Semana 6

Game Feel & Áudio

Efeitos visuais néon (#00FF66) + Sons de Mesa

Som da caneca perfeitamente sincronizado ao Truco

Semana 7

Oponente Bardo

Pixel Art 16-bit + Balões de Diálogo Reativos

Bardo reage visualmente ao tomar um blefe

Semana 8

Build & Publicação

Exportação Windows & Web (HTML5) no Itch.io

Demo rodando em navegador a 60 FPS estáveis

4. Arquitetura Técnica & Boas Práticas Godot 4

Diretrizes de Implementação:Para garantir agilidade de desenvolvimento solo e evitar refatorações complexas, a seguinte estrutura deve ser respeitada:

Desacoplamento de Lógica e Arte: A classe base TrecoEffect gerencia puramente dados e estado de jogo, enquanto Card.gd escuta sinais para acionar a camada de luzes néon e animações.

Reutilização de Cenas Base: Todas as cartas do baralho e consumíveis de Treco herdam da cena base CardBase.tscn, alterando apenas texturas e parâmetros.

Otimização para Web/Mobile: Manter no máximo 3 a 4 PointLight2D ativas simultaneamente na mesa para garantir 60 FPS cravados na exportação WebGL/HTML5.