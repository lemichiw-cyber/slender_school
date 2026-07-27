extends CharacterBody3D

const SPEED = 4.0
const MOUSE_SENSITIVITY = 0.003

@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@onready var ui = $"../UI"

var congelado = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if congelado: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):
	if congelado: return
	
	# Gravedad básica
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Interactuar con el cuaderno pulsando Click Izquierdo o tecla 'E'
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if raycast.is_colliding():
			var objeto = raycast.get_collider()
			if objeto.is_in_group("cuadernos"):
				objeto.interactuar()

func set_congelar(estado: bool):
	congelado = estado
	if estado:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED