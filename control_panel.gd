extends Control

var player_name: String = "PLAYER_NAME"
var default_naughty_list: Array = []
var default_nice_list: Array = []
var naughty_list: Array = []
var nice_list: Array = []
var state: String = "NONE"

var naughty_list_scene = preload("res://naughty_list.tscn")
var nice_list_scene = preload("res://nice_list.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_lists():
	naughty_list = default_naughty_list.duplicate()
	naughty_list.insert(2, player_name)
	nice_list = default_nice_list.duplicate()
	nice_list.insert(2, player_name)
	
func change_state(new_state):
	state = new_state
	update_status()
	
func update_status():
	$StateViewer/CurrentStateLabel.text = state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _open_list_window() -> void:
	var w = Window.new()
	w.visible = true
	get_tree().add_child(w)
	if state == "NAUGHTY":
		var n = naughty_list_scene.instantiate()
		w.add_child(n)
	elif state == "NICE":
		var n = nice_list_scene.instantiate()
		w.add_child(n)
	
	
