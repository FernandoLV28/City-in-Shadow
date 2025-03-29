extends KinematicBody2D

export var speed = 100  # Velocidad del enemigo
var direction = Vector2.RIGHT
var is_colliding = false

# Define los límites izquierdo y derecho para el enemigo
var left_limit = 675
var right_limit = 1480

func _ready():
	pass

func _process(delta):
	var velocity = direction * speed
	var collision_info = move_and_slide(velocity)

	# Cambiar la dirección cuando el enemigo llega a ciertos límites
	if position.x > right_limit:
		$Sprite.flip_h = true  # Voltear sprite si se mueve hacia la izquierda
		direction = Vector2.LEFT  # Cambiar la dirección a la izquierda
	elif position.x < left_limit:
		$Sprite.flip_h = false  # No voltear sprite si se mueve hacia la derecha
		direction = Vector2.RIGHT  # Cambiar la dirección a la derecha

	# Verificar si hubo una colisión y ajustar la dirección en consecuencia
	if collision_info != null:
		if !is_colliding:
			direction = -direction  # Invertir la dirección solo cuando inicia la colisión
			is_colliding = true
		$AnimationPlayer.play("right")
	else:
		is_colliding = false
		$AnimationPlayer.stop()
