extends MarginContainer

const first_scene = "res://MainMenu.tscn"

onready var selector_one = $VBoxContainer/VBoxContainer2/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 0:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		$MenuSelect.play()
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene("res://MainMenu.tscn")

func set_current_selection(_current_selection):
	selector_one.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
