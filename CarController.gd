extends Node2D

var max_cars = 7
var car_scene = preload("res://Cars.tscn")
var spawn_interval = 7  # Intervalo en segundos para aparecer un nuevo coche
var spawn_timer

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if get_tree().get_nodes_in_group("cars").size() < max_cars:
		var new_car = car_scene.instance()
		new_car.position = Vector2.ZERO  # Coloca el coche en la posición inicial (0, 0)
		add_child(new_car)
		new_car.add_to_group("cars")  # Añade el coche al grupo "cars"
