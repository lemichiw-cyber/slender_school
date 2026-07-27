extends Area3D

@export var pregunta = "Is 2 + 2 equal to 4?"
@export var respuesta_correcta_es_yes = true

@onready var ui = $"../UI"

func interactuar():
	# Abre la UI y le pasa los datos de este cuaderno
	ui.abrir_pregunta(pregunta, respuesta_correcta_es_yes, self)