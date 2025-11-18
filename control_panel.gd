extends Control

var player_name: String = "PLAYER_NAME"
var default_naughty_list: Array = ["Shasta Hong", "Victor Faulk", "Jareth Bustamante", "Joseph Nordman"]
var default_nice_list: Array = ["Tafan Hong", "Percie Carrillo", "Teana Campbell", "Violet Devine"]
var naughty_list: Array = ["Shasta Hong", "Victor Faulk", "Jareth Bustamante", "Joseph Nordman"]
var nice_list: Array = ["Tafan Hong", "Percie Carrillo", "Teana Campbell", "Violet Devine"]
var state: String = "NONE"

var naughty_list_scene = preload("res://naughty_list.tscn")
var nice_list_scene = preload("res://nice_list.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_lists():
	naughty_list = default_naughty_list.duplicate(true)
	nice_list = default_nice_list.duplicate(true)
	naughty_list.insert(2, player_name)
	nice_list.insert(2, player_name)
	var w = get_tree().get_root().find_child("list_window", true, false)
	if w == null:
		return
	if w.get_child_count() == 0 or w.get_child(0).get_child_count() == 0:
		return
	else:
		if state == "NAUGHTY":
			w.get_child(0).find_child("NaughtyList", true, false).add_list_names(naughty_list, state)
		if state == "NICE":
			w.get_child(0).find_child("NiceList", true, false).add_list_names(nice_list, state)
	
func change_state(new_state):
	state = new_state
	update_status()
	update_list_window()
	
func update_status():
	$StateViewer/CurrentStateLabel.text = state
	if state == "NAUGHTY":
		$StateViewer/CurrentStateLabel.add_theme_color_override("font_color", Color8(173, 00, 00, 255))
		open_list()
	elif state == "NICE":
		$StateViewer/CurrentStateLabel.add_theme_color_override("font_color", Color8(00, 173, 55, 255)) 
		open_list()
	else:
		$StateViewer/CurrentStateLabel.add_theme_color_override("font_color", Color8(255, 255, 255, 255))

func _open_list_window() -> void:
	var nw = get_tree().get_root().find_child("list_window", true, false)
	if nw == null:
		var w = Window.new()
		w.size = get_viewport_rect().size
		w.visible = true
		w.name = "list_window"
		get_tree().root.add_child(w)
		#if state == "NAUGHTY":
			#var n = naughty_list_scene.instantiate()
			#w.add_child(n)
			#update_lists()
		#elif state == "NICE":
			#var n = nice_list_scene.instantiate()
			#w.add_child(n)
			#update_lists()
	else:
		if state == "NAUGHTY" or state == "NICE":
			open_list()
	
func open_list():
	update_lists()
	var nw = get_tree().get_root().find_child("list_window", true, false)
	if nw == null:
		return
	var l
	if nw.get_child_count() > 0:
		l = nw.find_child("AnimatedSprite2D", true, false)
		l.play("unroll", -1)
		await l.animation_finished
	else:
		var list_scene = preload("res://test_scroll.tscn")
		l = list_scene.instantiate()
		nw.add_child(l)
		l.global_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	l.play("unroll")
	await l.animation_finished
	if state == "NAUGHTY":
		var n = naughty_list_scene.instantiate()
		n.modulate = Color("ffffff00")
		l.add_child(n)
		var ap = n.find_child("AnimationPlayer", true, false)
		ap.play("fade_in")
		await ap.animation_finished
		ap.play("fade_in_player_name")
	elif state == "NICE":
		var n = nice_list_scene.instantiate()
		n.modulate = Color("ffffff00")
		l.add_child(n)
		var ap = n.find_child("AnimationPlayer", true, false)
		ap.play("fade_in")
		await ap.animation_finished
		ap.play("fade_in_player_name")
	
func update_list_window():
	var w = get_tree().get_root().find_child("list_window", true, false)
	if w == null:
		return
	for i in w.get_children():
		i.queue_free()
	open_list()
	#if state == "NAUGHTY":
		#var n = naughty_list_scene.instantiate()
		#w.add_child(n)
		#update_lists()
	#elif state == "NICE":
		#var n = nice_list_scene.instantiate()
		#w.add_child(n)
		#update_lists()


func update_player() -> void:
	player_name = $PlayerList/TextEdit.text
	$PlayerList/TextEdit.text = ""
	$PlayerList/PlayerName.text = player_name
	$PlayerList/PlayerName.adjust_font_to_fit()
	naughty_list.insert(2, player_name)
	nice_list.insert(2, player_name)
	update_lists()

func _on_text_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_ENTER:
			get_viewport().set_input_as_handled()
			update_player()
		
