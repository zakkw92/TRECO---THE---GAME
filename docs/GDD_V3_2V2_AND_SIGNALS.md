# 📜 GDD v3.0 — EXPANSÃO MODO 2v2 & SISTEMA DE SINAIS SECRETOS
**Projeto:** TRECO — Truco da Taverna  
**Plataforma Alvo:** Steam (PC & Steam Deck)  
**Autor:** Guilherme  

---

## 1. VISÃO DO MODO 2v2 (DUPLAS NA TAVERNA)

O modo principal do jogo expande a disputa para duplas tradicionais de Truco Paulista (4 jogadores na mesa):
- **Jogador 1 (Você / Sul):** Visão em 1ª pessoa.
- **Jogador 2 (Seu Companheiro / Norte):** Sentado à sua frente na mesa.
- **Oponente 1 (Esquerda / Oeste):** Adversário da taverna.
- **Oponente 2 (Direita / Leste):** Adversário da taverna.

A ordem de jogada segue o sentido anti-horário tradicional:
`Jogador -> Oponente 1 -> Companheiro -> Oponente 2`.

---

## 2. SISTEMA DE SINAIS SECRETOS & BLEFES (MANHAS)

Durante qualquer momento da sua vez ou antes de jogar uma carta, o jogador pode emitir **Sinais Secretos** rápidos para o seu parceiro através de uma roda de reações (*Radial Wheel*) ou atalhos:

| Sinal / Expressão | Significado Tático | Ícone / Animação |
| :--- | :--- | :---: |
| **Piscadela de Olho** | *"Tenho o Zap (Paus) — A Manilha Suprema"* | 😉 |
| **Levantar Sobrancelha** | *"Tenho a Manilha de Copas"* | 🤨 |
| **Morder o Lábio / Bico** | *"Tenho a Espadilha (Espadas)"* | 👄 |
| **Coçar o Queixo** | *"Tenho o Pica-fumo (Ouros)"* | 🤔 |
| **Bater a Caneca na Mesa** | *"Estou com mão forte / Peça TRUCO!"* | 🍻 |
| **Sorrisinho Disfarçado** | *"Estou blefando / Minha mão é fraca, salve a vaza!"* | 😈 |

---

## 3. MECÂNICA DE RISCO: INTERCEPTAÇÃO DE SINAIS (*SPYING*)

Dar sinais não é 100% seguro — há um elemento de tensão tática:
- **Percepção dos Adversários:** Cada oponente possui um atributo de *Percepção / Malícia*.
- **Interceptação:** Se o jogador emitir sinais com muita frequência ou em momentos de silêncio na taverna, o oponente tem uma chance de **interceptar o sinal**.
- **Alerta de Perigo:** Um ícone de exclamação `!` surge sobre a cabeça do oponente que pegou o sinal, e a IA passa a contra-atacar sabendo qual carta o jogador possui.

### Sinergia com os Trecos (Alquimia):
- **Fumaça de Taverna:** Cria névoa ao redor da mesa garantindo **100% de sigilo** nos próximos sinais trocados pela sua dupla.
- **Olho de Lince:** Permite que você e seu parceiro tentem **interceptar os sinais e olhares trocados pela dupla adversária**!

---

## 4. COMPANHEIROS RECRUTÁVEIS (PARCEIROS DE TAVERNA)

No modo Roguelike/Campanha, o jogador pode contratar diferentes companheiros para formar sua dupla:

1. **Valéria, a Ladina de Olhos Rápidos**:
   - *Habilidade Passiva:* 100% de precisão ao ler sinais; avisa com um sussurro se o oponente está blefando.
2. **Thorin, o Guarda-Costas Anão**:
   - *Habilidade Passiva:* Bate na mesa aumentando o terror psicológico dos oponentes ao pedir Truco; joga sempre com foco em Cangadas seguras.
3. **Morgana, a Bruxa Mercadora**:
   - *Habilidade Passiva:* Compartilha a reserva de Energia (⚡) e permite combinar dois Trecos na mesma rodada.

---

## 5. REGRAS DA DISPUTA 2v2

- Baralho tradicional de 40 cartas (3 cartas distribuídas para cada um dos 4 jogadores).
- Resolução de vazas em melhor de 3: A vaza pertence à dupla que jogou a carta mais alta.
- Pontuação até 12 tentos, com escalonamento de apostas (1 $\rightarrow$ 3 $\rightarrow$ 6 $\rightarrow$ 9 $\rightarrow$ 12).
- Ambos os jogadores da dupla podem pedir Truco ou responder ao desafio.
