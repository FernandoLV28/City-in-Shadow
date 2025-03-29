extends KinematicBody2D

export var speed = 10000 #Velocidad del coche
var destination_position : Vector2  # Posición de destino del coche

func _ready():
	# Configurar la posición inicial del coche
	position = initial_position()
	
	# Configurar la posición de destino del coche
	destination_position = Vector2(4200, position.y)  # Ajusta la posición de destino según tus necesidades

func _process(delta):
	# Mover el coche hacia la posición de destino
	var velocity = (destination_position - position).normalized() * speed * delta
	move_and_slide(velocity)

	# Verificar si el coche ha alcanzado la posición de destino
	if position.distance_to(destination_position) < 10:
		reset_position()

	# Verificar si el coche está fuera de los límites del mapa
	if is_out_of_bounds():
		reset_position()

func initial_position() -> Vector2:
	# Puedes personalizar esta función para obtener la posición inicial según tus necesidades
	return Vector2(10, 180)  # Establece la posición inicial en el eje Y según tus necesidades

func reset_position():
	# Reiniciar la posición del coche al punto A
	position = initial_position()

func is_out_of_bounds() -> bool:
	# Verificar si el coche está fuera de los límites del mapa
	var screen_size = get_viewport_rect().size
	var min_x = 10
	var max_x = 4200
	var min_y = 20
	var max_y = 2150
	
	return position.x < min_x or position.x > max_x or position.y < min_y or position.y > max_y
