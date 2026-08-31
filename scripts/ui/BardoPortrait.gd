class_name BardoPortrait
extends Control

@onready var speech_bubble: Panel = $SpeechBubble
@onready var speech_text: Label = $SpeechBubble/SpeechText
@onready var avatar_rect: ColorRect = $AvatarFrame/AvatarRect
@onready var mood_label: Label = $AvatarFrame/MoodLabel

var current_tween: Tween

const QUOTES_TRUCO_CALL = [
	""Batam as canecas! O show vai começar! TRUCO!"",
	""Você não viu nem metade do meu repertório... TRUCO!"",
	""Uma canção de vitória já soa no meu peito! TRUCO!"",
	""Dizem que o blefe é uma arte, e eu sou o mestre!""
]

const QUOTES_TRUCO_ACCEPT = [
	""Caiu no meu jogo! Vamos ver quem tem mais peito!"",
	""Aceito sem pestanejar, taverneiro! Mostre o que tem!"",
	""Nem o hidromel mais forte me faz tremer! Aceito!""
]

const QUOTES_TRUCO_REFUSE = [
	""Um bom bardo sabe a hora de sair do palco... Fui!"",
	""Essa mão cheira a armadilha. Leve essa, mas não a partida!"",
	""Vou guardar meu ouro para a próxima estrofe!""
]

const QUOTES_TRUCO_RAISE = [
	""Truco? Pouco pra mim! SEIS na sua cara!"",
	""Aumentou a aposta? Então dobra essa mesa! SEIS!"",
	""O taverneiro quer emoção? Então segura essa batida!""
]

const QUOTES_TRECO_USE = [
	""Um toque de alquimia para temperar essa partida..."",
	""Fumaça nos olhos dos marrecos!"",
	""Quem precisa de sorte quando se tem bons truques?""
]

const QUOTES_WIN_TRICK = [
	""Mais fácil do que afinar um alaúde!"",
	""Essa vaza já tem dono e rima com vitória!"",
	""Primeira estrofe concluída com perfeição!""
]

const QUOTES_LOSE_TRICK = [
	""Ora... Uma nota desafinada acontece aos melhores!"",
	""Sorte de principiante, caro taverneiro!"",
	""Ainda tenho duas cartas na manga!""
]

func _ready() -> void:
	speech_bubble.visible = false

func speak(text: String, duration: float = 2.5) -> void:
	if current_tween != null and current_tween.is_valid():
		current_tween.kill()
		
	speech_text.text = text
	speech_bubble.visible = true
	speech_bubble.modulate.a = 0.0
	speech_bubble.scale = Vector2(0.8, 0.8)
	speech_bubble.pivot_offset = speech_bubble.size / 2.0
	
	current_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	current_tween.tween_property(speech_bubble, "modulate:a", 1.0, 0.2)
	current_tween.tween_property(speech_bubble, "scale", Vector2(1.0, 1.0), 0.2)
	
	current_tween.chain().tween_interval(duration)
	current_tween.chain().tween_property(speech_bubble, "modulate:a", 0.0, 0.3)
	current_tween.finished.connect(func(): speech_bubble.visible = false)

func on_truco_called() -> void:
	speak(QUOTES_TRUCO_CALL.pick_random(), 3.0)
	mood_label.text = "😏 Confiante"

func on_truco_response(accepted: bool, raised: bool) -> void:
	if raised:
		speak(QUOTES_TRUCO_RAISE.pick_random(), 3.0)
		mood_label.text = "😈 Agressivo"
	elif accepted:
		speak(QUOTES_TRUCO_ACCEPT.pick_random(), 2.8)
		mood_label.text = "😎 Desafiador"
	else:
		speak(QUOTES_TRUCO_REFUSE.pick_random(), 2.5)
		mood_label.text = "😅 Cauteloso"

func on_treco_used() -> void:
	speak(QUOTES_TRECO_USE.pick_random(), 2.5)
	mood_label.text = "🧪 Alquimista"

func on_trick_won() -> void:
	speak(QUOTES_WIN_TRICK.pick_random(), 2.2)
	mood_label.text = "😄 Risonho"

func on_trick_lost() -> void:
	speak(QUOTES_LOSE_TRICK.pick_random(), 2.2)
	mood_label.text = "🤨 Analítico"
