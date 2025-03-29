extends KinematicBody2D

# Velocidad de movimiento del personaje
var Velocidad = 150

# Vector para almacenar la dirección de movimiento
var Movimiento = Vector2(0, 0)

# Variable para alternar la dirección del movimiento
var Forgod = true

# Función llamada en cada paso del proceso de física
func _physics_process(delta) -> void:
	
	# Verificar si el personaje está en una pared
	if is_on_wall():
		# Alternar la dirección del movimiento al chocar con una pared
		Forgod = not Forgod
		
	# Configurar la dirección de movimiento y la animación basándose en 'Forgod'
	if Forgod == true:
		Movimiento.x = 50
		$AnimationPlayer.play("right")
		$Sprite.flip_h = false
		
	else:
		Movimiento.x = -50
		$AnimationPlayer.play("right")
		$Sprite.flip_h = true
	
	# Utilizar la función 'move_and_slide' para mover el personaje y aplicar la gravedad
	Movimiento = move_and_slide(Movimiento, Vector2.UP)
	
	# Aplicar un suavizado al valor de la velocidad en el eje X
	#Movimiento.x = lerp(Movimiento.x, 0, 0.2)
