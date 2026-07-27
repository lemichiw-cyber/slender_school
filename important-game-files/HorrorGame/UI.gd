extends CanvasLayer

@onready var panel = $PanelPreguntas
@onready var label_pregunta = $PanelPreguntas/LabelPregunta
@onready var player = $"../Player"
@onready var profesor = $"../NavigationRegion3D/Profesor"

var respuesta_esperada = true
var cuaderno_actual = null
var cuadernos_recolectados = 0

func _ready():
	panel.visible = false

func abrir_pregunta(texto: String, es_yes: bool, cuaderno):
	cuaderno_actual = cuaderno
	respuesta_esperada = es_yes
	label_pregunta.text = texto
	panel.visible = true
	player.set_congelar(true)

func responder(player_dijo_yes: bool):
	panel.visible = false
	player.set_congelar(false)
	
	if player_dijo_yes == respuesta_esperada:
		# CORRECTO
		cuadernos_recolectados += 1
		if cuaderno_actual: cuaderno_actual.queue_free()
		print("Correct! Notebooks: ", cuadernos_recolectados)
	else:
		# INCORRECTO: Alerta al profesor
		print("WRONG ANSWER!")
		profesor.activar_persecucion(player.global_position)

# Conectores de botones (Asegúrate de enlazar las señales en Godot)
func _on_button_yes_pressed():
	responder(true)

func _on_button_no_pressed():
	responder(false)