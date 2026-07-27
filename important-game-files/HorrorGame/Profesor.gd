extends CharacterBody3D

var speed = 2.0
var modo_persecucion = false
var destino_persecucion = Vector3.ZERO

@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../../Player"

func _ready():
	# Esperar un frame a que cargue el NavigationRegion3D
	await get_tree().process_frame
	hacer_patrulla_aleatoria()

func _physics_process(delta):
	if modo_persecucion:
		# Actualiza constantemente la posición del jugador si está persiguiendo
		nav_agent.target_position = player.global_position
	elif nav_agent.is_navigation_finished():
		hacer_patrulla_aleatoria()
		
	if not nav_agent.is_navigation_finished():
		var next_path_position: Vector3 = nav_agent.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * speed
		velocity = new_velocity
		move_and_slide()

func hacer_patrulla_aleatoria():
	speed = 2.0
	# Elige un punto al azar cerca (puedes cambiar el rango)
	var random_dir = Vector3(randf_range(-15, 15), 0, randf_range(-15, 15))
	nav_agent.target_position = global_position + random_dir

func activar_persecucion(posicion_jugador: Vector3):
	modo_persecucion = true
	speed = 5.5 # Se vuelve mucho más rápido que el jugador
	nav_agent.target_position = posicion_jugador

# Conecta esta señal desde el Area3D del Profesor para matar al jugador
func _on_area_3d_profesor_body_entered(body):
	if body.name == "Player":
		print("JUMPSCARE! GAME OVER")
		get_tree().reload_current_scene()