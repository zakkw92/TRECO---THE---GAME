# 🎨 DOCUMENTO DE BRIEFING DE ARTE & DIREÇÃO VISUAL
**Projeto:** TRECO — Truco da Taverna  
**Plataforma Alvo:** Steam (PC & Steam Deck)  
**Gênero:** Roguelike / Deckbuilder de Truco Tático Medieval  
**Estilo Visual:** Pixel Art 16-bit / 32-bit (Iluminação quente, rústica e atmosférica)  
**Referências Visuais:** *Inscryption*, *Balatro*, *Loop Hero*, *Sea of Stars*, *Potion Craft*.

---

## 1. VISÃO GERAL & ATMOSFERA DO JOGO

**TRECO** é um jogo de cartas tenso e malandro ambientado em uma taverna medieval clandestina. O jogo combina as regras do clássico **Truco Paulista** com **itens alquímicos e poderes trapaceiros (os "Trecos")**. 

A atmosfera visual deve transmitir:
- O clima imersivo de uma taverna escura e aconchegante iluminada por lamparinas a óleo e velas.
- Madeira velha, canecas de hidromel derramadas e fumaça no ar.
- Tensão de apostas, blefes e trapaças alquímicas na mesa.

---

## 2. CENÁRIO & PERSPECTIVA DE CÂMERA (A TAVERNA)

A perspectiva do jogo é em **Primeira Pessoa (Visão do Jogador sentado à mesa)**.

```
+-------------------------------------------------------------+
|               VIGAS DE MADEIRA & LAMPARINAS A ÓLEO          |
|                                                             |
|       [ BARTENDER AO FUNDO ]        [ OPONENTE SENTADO ]    |
|       (Limpando caneca / olhando)   (Bardo Sylas na mesa)   |
|                                                             |
|   ~~~~~~~~~~~~~~~~~~~~ MESA DE TAVERNA ~~~~~~~~~~~~~~~~~~~  |
|   (Caneca de Hidromel)     [ CARTA TOMBO ]     (Moedas)     |
|                             [ CARTAS VAZA ]                 |
|                                                             |
|                     [ MÃO DO JOGADOR ]                      |
|                  (Segurando as 3 cartas)                    |
|   [ BOLSA DE TRECOS ]                             [ TRUCO! ]|
+-------------------------------------------------------------+
```

### Elementos do Cenário:
1. **A Mesa Velha de Taverna**:
   - Madeira rústica de carvalho escuro, com textura de tábuas envelhecidas, nós na madeira, arranhões de faca e marcas redondas de copos molhados.
   - Objetos decorativos sobre a mesa: caneca pesada de cerâmica/estanho com hidromel transbordando espuma, algumas moedas antigas de cobre/ouro jogadas e dados de osso.
2. **Iluminação & Teto**:
   - Vigas de madeira escura no topo com **lamparinas a óleo e lanternas de ferro suspensas** que projetam uma luz amarelada/alaranjada quente e sombras marcantes sobre a madeira.
3. **O Bartender (Taverneiro Observador)**:
   - Posicionado ao fundo da cena (meio de lado, apoiado no balcão).
   - Postura atenta observando as trapaças do jogo, secando uma caneca com um pano de linho ou com os braços cruzados e olhar desconfiado.
4. **A Mão do Jogador (1ª Pessoa)**:
   - Apenas o braço e a mão do nosso personagem aparecem na parte inferior da tela, usando uma luva de couro de taverneiro ou manga arregaçada rústica, segurando e jogando as cartas com firmeza.

---

## 3. AS CARTAS (O BARALHO DE TRUCO DE TAVERNA)

As cartas devem parecer artefatos físicos de taverna: cartões de pergaminho grosso e chanfrado com ilustrações marcantes e alto contraste.

- **Frente da Carta:**
  - Papel pergaminho amarelado envelhecido com textura e bordas gastas.
  - Índices duplos (valor e naipe nos cantos superior esquerdo e inferior direito).
  - Ícone central do naipe bem ilustrado e detalhado.
  - Naipes: **Ouros ♦**, **Espadas ♠**, **Copas ♥**, **Paus ♣**.
  - Cartas de figuras (Valete/Dama/Rei) com retratos medievais expressivos de plebeus, mercenários e reis decrépitos.
- **Verso da Carta:**
  - Estampa ornamentada em vermelho vinho e dourado, com o selo alquímico da taverna no centro.
- **Versão Especial (Manilhas & Zap):**
  - Moldura dourada reforçada com pedras brutas e filigranas de ouro para as cartas de maior poder (com visual supremo exclusivo para o **Zap de Paus**).

---

## 4. PERSONAGENS & OPONENTES (VISÃO FRONTAL)

Oponentes sentados do outro lado da mesa, com visual caricato, expressivo e único:

1. **Sylas, o Bardo Trapaceiro (Oponente Inicial)**:
   - Elfo ladino e carismático, com chapéu de pluma verde esmeralda, alaúde encostado na cadeira, sorriso malandro de blefe e anéis brilhantes nos dedos.
   - **Animações necessárias (Spritesheet):**
     - `idle` (Loop de 4 a 6 frames): Respiração, piscando os olhos e ajeitando a gola.
     - `truco_slam` (6 frames): Ergue a caneca e bate na mesa com violência ao pedir Truco.
     - `bluff` (4 frames): Piscadela de olho ou sorriso de canto convencido.
     - `defeat` (4 frames): Expressão de choque e indignação ao perder o ouro.

---

## 5. INTERFACE (UI) & A "BOLSA DE TRECOS" (MODAL)

Em vez de menus genéricos cinzas, a interface é totalmente integrada ao mundo do jogo:

1. **A Bolsa de Alquimia / Algibeira de Couro (Modal de Trecos)**:
   - Ao clicar no botão da bolsa, abre-se uma **mochila/bolsa de couro rústico aberta sobre a mesa**, com fivelas de bronze e costuras grossas.
   - Dentro da bolsa, ficam organizados os frascos de poções e itens sorteados para a rodada.
2. **Ícones dos Trecos (Poderes Alquímicos - 32x32 px)**:
   - *Olho de Lince:* Frasco de vidro com um olho brilhante flutuando em líquido azul.
   - *Fumaça de Taverna:* Cachimbo rústico ou frasco exalando fumaça roxa densa.
   - *O Alquimista:* Frasco triangular com poção verde borbulhante e faíscas.
   - *Mão Leve:* Luva de veludo com moedas caindo.
   - *Cana de Hidromel:* Caneca de madeira espumando e derramando bebida dourada.
   - *Confusão no Bar:* Dados de osso tortos e cartas caindo.
   - *Cara de Pau:* Máscara de teatro de madeira entalhada.
   - *Aposta Dobrada:* Duas moedas de ouro pesadas batendo uma na outra.

---

## 6. TABELA DE ENTREGÁVEIS & ESPECIFICAÇÕES TÉCNICAS

| Item | Quantidade | Dimensão Recomendada | Formato de Entrega |
| :--- | :---: | :---: | :---: |
| **Cenário de Fundo (Taverna + Teto + Bartender)** | 1 | `1280 x 720 px` (Pixel Art 16:9) | PNG em camadas separadas (Fundo, Mesa, Bartender, Luzes) + `.ase` |
| **Mão do Jogador (1ª Pessoa)** | 1 | `200 x 200 px` | PNG em camadas / Spritesheet de segurar e jogar |
| **Frente e Verso das Cartas** | 40 cartas + 1 Verso | `95 x 135 px` | PNG com transparência + `.ase` |
| **Molduras Especiais (Manilhas / Zap)** | 2 | `95 x 135 px` | PNG com transparência |
| **Personagem Bardo (Sylas)** | 1 (4 animações) | `96 x 96 px` ou `128 x 128 px` | Spritesheet horizontal PNG + `.ase` |
| **Bolsa de Alquimia (Modal Aberto)** | 1 | `720 x 420 px` | PNG com transparência |
| **Ícones de Trecos (Itens Alquímicos)** | 8 a 12 ícones | `32 x 32 px` | PNG individuais com transparência |

---

## 7. DIRETRIZES DE ESTILO & PALETA DE CORES

- **Paleta de Cores Recomendada:** Tons quentes e terrosos (Madeira escura, âmbar da cerveja, ouro velho, linho cru, couro desgastado), com cores vibrantes reservadas para as poções e manilhas (Esmeralda, Carmesim, Ouro Vivo e Roxo Alquímico).
- **Consistência:** Pixels nítidos (sem pixels mixados/redimensionados desproporcionalmente).
- **Arquivos Fonte:** Envio obrigatório dos arquivos originais em **Aseprite (`.ase` / `.aseprite`)** com camadas nomeadas e organizadas.

---
**Contato para Proposta & Envio de Portfólio:**  
*Guilherme — Diretor & Desenvolvedor de TRECO*
