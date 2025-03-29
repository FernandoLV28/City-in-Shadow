extends KinematicBody2D

export var speed = 12000  # Velocidad del jugador
export var level : int = 1 # Variable para rastrear el nivel actual del juego

#Variable del puntuaje
var score = 0

var initial_lives : int = Resources.lives #Variable de vidas para el jugador
var current_lives : int = initial_lives  # Número actual de vidas
#var score : int = 0  # Variable para la puntuación del jugador
onready var LivesLabel = get_node("../CanvasLayer/Lives")  # Etiqueta de Vidas
var is_attacking : bool = false  # Variable para rastrear el estado del ataque
var is_damage : bool = false #Variable para el daño

func _ready():
	pass

func start():
	show()

func _process(delta):
	var velocity = Vector2()  # Vector de movimiento del jugador.
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$Sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$Sprite.flip_h = true
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if Input.is_action_just_pressed("ui_attack") and !is_attacking:
		attack()  # Llamar a la función de ataque solo si no está atacando

	if is_attacking:
		var attack_position = get_node("Sprite/ArmHit")
		if $Sprite.flip_h:
			attack_position.position.x = -50 #Izquierda
		else:
			attack_position.position.x = 25 #Derecha
		return  # Evitar reproducir otras animaciones mientras se ataca
		
		
	velocity = velocity.normalized() * speed * delta  # Ajustar la velocidad según el tiempo delta
	move_and_slide(velocity)  # Mover con la nueva velocidad

	if velocity.length() > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("idle")  # Reproducir la animación "idle" cuando no hay movimiento.

	# Limitar la posición del jugador
	limit_player_position()

func attack():
	$AnimationPlayer.play("attack")  # Activar la animación de ataque
	is_attacking = true  # Marcar que el personaje está atacando
	$AnimationPlayer.connect("animation_finished", self, "_on_attack_animation_finished")

func _on_attack_animation_finished(animation_name):
	is_attacking = false  # Reiniciar la marca de ataque cuando la animación ha terminado
#Función de daño
func damage():
	$AnimationPlayer.play("damage")
	is_damage = true
	$AnimationPlayer.connect("animation_finished", self, "_on_damage_animation_finished")
# Función de manejo
func _on_damage_animation_finished(animation_name):
	is_damage = false
	pass

func _on_ArmHit_body_entered(body):
	print(body.get_name())
	if "enemy" in body.get_name():
		var enemy_node = get_node("../" + body.get_name())
		enemy_node.queue_free()  # Libera los recursos asociados al enemigo
		$HitSound.volume_db = -10 #Establecer volumen del sonido
		$HitSound.play()#Reproducir sonido cada vez que se golpea a un enemigo
		score += 1  # Incrementar la puntuación al matar a un enemigo
		update_score_label()  # Actualizar la etiqueta de puntuación
		if score == 20:
			#print("Ganaste")
			# Detener la música de fondo
			var backgroundMusic = get_node("../BackgroundMusic")
			backgroundMusic.stop() 
			# Ocultar las etiquetas
			var etiqueta1 = get_node("../CanvasLayer/Points")
			var etiqueta2 = get_node("../CanvasLayer/Lives")
			etiqueta1.hide()     
			etiqueta2.hide()     
			#Cambiar a la escena Win
			get_tree().change_scene("res://WinMenu.tscn")
			queue_free()

#Función para detectar si nos toca un enemigo
func _on_Player_body_entered(body):
	#print(body.get_name())
	if "enemy" in body.get_name() || "car" in body.get_name():
		damage()
		$Hit.volume_db = -10     #Establecer volumen
		$Hit.play()    #Reproducir sonido cada vez que se golpea al jugador
		current_lives -= 1    #Quitar vida por cada golpe
		update_lives_label()   #Actualizar la etiqueta
		if current_lives == 0:
			$AnimationPlayer.play("death")
			get_tree().change_scene("res://DeadMenu.tscn") #Cargar el GameOver
			queue_free()
			var backgroundMusic = get_node("../BackgroundMusic")
			backgroundMusic.stop() #Quitar la música de fondo
			var etiqueta1 = get_node("../CanvasLayer/Points")
			var etiqueta2 = get_node("../CanvasLayer/Lives")
			etiqueta1.hide()
			etiqueta2.hide()
	pass

# Función para actualizar la etiqueta de vidas
func update_lives_label():
	LivesLabel.text = "Lives: " + str(current_lives)

# Función para actualizar la etiqueta de puntuación
func update_score_label():
	var Points = get_node("../CanvasLayer/Points")
	Points.text = "Points: " + str(score)

# Función para limitar la posición del jugador
func limit_player_position():
	var screen_size = get_viewport_rect().size
	var min_x = 10
	var max_x = 4100
	var min_y = 20
	var max_y = 2150
	
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
	
