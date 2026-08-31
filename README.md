# 🍻 TRECO — Truco da Taverna (THE GAME)

> **Card Game / Deckbuilder Roguelike de Taverna em Pixel Art Retrô 16-bit**  
> Desenvolvido na **Godot Engine 4.3 (GDScript)**.

---

## 🃏 Sobre o Jogo

O **TRECO** combina a essência e o blefe do **Truco Paulista Tradicional** com mecânicas de itens alquímicos, trapaças e distrações de taverna (os *Trecos*). Enfrente personagens caricatos de taverna medieval utilizando astúcia, blefe e manipulação de cartas em tempo real!

---

## ⚡ Principais Mecânicas

- **Regras do Truco Paulista:** Vira dinâmico, Manilhas (Zap ♣, Copas ♥, Espadilha ♠, Pica-fumo ♦) e disputa em melhor de 3 vazas com resolução de empates (*Canga*).
- **Sistema de Apostas Escalonadas:** 1 tento $\rightarrow$ **TRUCO (3)** $\rightarrow$ **SEIS (6)** $\rightarrow$ **NOVE (9)** $\rightarrow$ **DOZE (12)**.
- **Energia de Taverna & Trecos Alquímicos:** Cada jogador recebe 3⚡ por rodada para utilizar até 1 Treco por rodada em janelas estratégicas de ativação:
  - 👁️ **Olho de Lince** (1⚡ | Pré-Jogada): Revela uma carta oculta da mão do oponente.
  - 🌫️ **Fumaça de Taverna** (1⚡ | Pré-Jogada): Contra-espionagem, oculta manilhas contra itens inimigos.
  - 🧪 **O Alquimista** (2⚡ | Reação): Transmuta uma carta na Manilha Suprema (Zap de Paus).
  - 🧤 **Mão Leve** (2⚡ | Reação): Rouba a carta mais fraca da mão do oponente.
  - 🍺 **Cana de Hidromel** (2⚡ | Reação): Anula a manilha jogada pelo adversário.
  - 🎭 **Cara de Pau** (2⚡ | Pré-Jogada): Joga carta virada para baixo (blefe visual).
  - 🎲 **Aposta Dobrada** (2⚡ | Pré-Jogada): Risco calculado para dobrar os tentos da rodada.
  - 💥 **Confusão no Bar** (3⚡ | Aposta às Cegas): Redefine instantaneamente o Vira e todas as manilhas.
- **Inteligência Artificial (Taverna Bot):** IA contextual com avaliação de força de mão, capacidade de blefe e respostas calculadas a pedidos de Truco.

---

## 🚀 Como Executar o Projeto

1. Baixe e instale o [Godot Engine 4.3 (Standard)](https://godotengine.org/download).
2. Abra o Godot e selecione **Importar (Import)**.
3. Aponte para o diretório raiz deste repositório e selecione `project.godot`.
4. Pressione **F5** (ou o botão Play) para rodar o jogo diretamente na mesa da taverna (`scenes/TavernTable.tscn`).

---

## 📁 Estrutura de Arquivos

```
TrecoGame/
├── project.godot
├── scenes/
│   ├── TavernTable.tscn     # Cena principal da mesa e iluminação
│   └── CardUI.tscn          # Componente visual interativo de carta
└── scripts/
    ├── core/
    │   ├── CardData.gd       # Modelo de dados da carta
    │   ├── Deck.gd           # Baralho e embaralhamento
    │   ├── TrucoRules.gd     # Regras de manilhas, empates e apostas
    │   └── MatchManager.gd   # Gerenciador de estado e fluxo da partida
    ├── ai/
    │   └── OpponentAI.gd     # IA do oponente e lógica de blefe
    ├── effects/              # Catálogo de efeitos e itens alquímicos (Trecos)
    └── ui/
        ├── TavernTable.gd    # Controlador da interface gráfica da mesa
        ├── CardUI.gd         # Controlador visual e animações de carta
        └── CandleLight.gd    # Efeito de iluminação dinâmica da vela
```

---

Desenvolvido com ☕ e paixão por Truco!

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
