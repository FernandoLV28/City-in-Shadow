extends MarginContainer

const first_scene = preload("res://level1.tscn")
const second_scene = preload("res://ControlsMenu.tscn")


onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector
onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 1:
		current_selection += 1
		set_current_selection(current_selection)
		$MenuMove.play()
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
		$MenuMove.play()
	elif Input.is_action_just_pressed("ui_accept"):
		$MenuSelect.play()
		handle_selection(current_selection)
		

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene("res://level1.tscn")
		queue_free()
	elif _current_selection == 1:
		get_parent().add_child(second_scene.instance())

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
