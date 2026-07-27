extends OmniLight3D # Cambia a SpotLight3D si es una lámpara de techo direccional

func _ready():
	loop_parpadeo()

func loop_parpadeo():
	while true:
		await get_tree().create_timer(randf_range(0.1, 1.5)).timeout
		visible = !visible # Se apaga o se enciende
		if !visible:
			await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
			visible = true