extends Control

var player_name: String = "PLAYER_NAME"
var default_naughty_list: Array = ["Shasta Hong", "Victor Faulk", "Jareth Bustamante", "Joseph Nordman"]
var default_nice_list: Array = ["Tafan Hong", "Percie Carrillo", "Teana Campbell", "Violet Devine"]
var naughty_list: Array = ["Shasta Hong", "Victor Faulk", "Jareth Bustamante", "Joseph Nordman"]
var nice_list: Array = ["Tafan Hong", "Percie Carrillo", "Teana Campbell", "Violet Devine"]
var state: String = "NONE"

var scroll_open: bool = false

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
			if w.get_child(0).get_node("NaughtyList") == null:
				return
			w.get_child(0).find_child("NaughtyList", true, false).add_list_names(naughty_list, state)
		if state == "NICE":
			if w.get_child(0).get_node("NiceList") == null:
				return
			w.get_child(0).find_child("NiceList", true, false).add_list_names(nice_list, state)
	
func change_state(new_state):
	state = new_state
	update_status()
	update_list_window()
	
func update_status():
	$StateViewer/CurrentStateLabel.text = state
	if state == "NAUGHTY":
		$StateViewer/CurrentStateLabel.add_theme_color_override("font_color", Color8(173, 00, 00, 255))
	elif state == "NICE":
		$StateViewer/CurrentStateLabel.add_theme_color_override("font_color", Color8(00, 173, 55, 255)) 
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
	else:
		if state == "NAUGHTY" or state == "NICE":
			open_list()
	
func open_list():
	update_lists()
	var nw = get_tree().get_root().find_child("list_window", true, false)
	if nw == null:
		return
	var l
	var scroll_sprite
	if nw.get_child_count() > 0:
		l = nw.get_node("ScrollWrapper")
		for child_name in ["NaughtyList", "NiceList"]:
			if l.has_node(child_name):
				var child = l.get_node(child_name)
				await unload_list(child)
		if scroll_open:
			scroll_sprite = l.get_node("ScrollContainer").get_node("ScrollSprite")
			scroll_sprite.play_backwards("unroll")
			await scroll_sprite.animation_finished
			scroll_open = false
	else:
		var list_scene = preload("res://test_list.tscn")
		l = list_scene.instantiate()
		nw.add_child(l)
	if !scroll_open:
		scroll_sprite = l.get_node("ScrollContainer").get_node("ScrollSprite")
		scroll_sprite.play("unroll")
		await scroll_sprite.animation_finished
		scroll_open = true
	if state == "NAUGHTY" or state == "NICE":
		if state == "NICE":
			var n = nice_list_scene.instantiate()
			load_list(n, l)
		if state == "NAUGHTY":
			var n = naughty_list_scene.instantiate()
			load_list(n, l)
		
func load_list(n, l):
	n.modulate = Color("ffffff00")
	var marker = l.get_node("CenterMarker")
	n.position = marker.position
	l.add_child(n)
	update_lists()
	var ap = n.find_child("AnimationPlayer", true, false)
	ap.play("fade_in")
	await ap.animation_finished
	ap.play("fade_in_player_name")
	await ap.animation_finished
	
func unload_list(n):
	var ap = n.find_child("AnimationPlayer", true, false)
	ap.play("fade_out_player_name")
	await ap.animation_finished
	ap.play("fade_out")
	await ap.animation_finished
	n.queue_free()
	
func update_list_window():
	var w = get_tree().get_root().find_child("list_window", true, false)
	if w == null:
		return
	open_list()

func reset_list():
	var w = get_tree().get_root().find_child("list_window", true, false)
	if w == null:
		return
	if w.get_child_count() > 0:
		var l = w.get_node("ScrollWrapper")
		for child_name in ["NaughtyList", "NiceList"]:
			if l.has_node(child_name):
				var child = l.get_node(child_name)
				await unload_list(child)
		if scroll_open:
			var scroll_sprite = l.get_node("ScrollContainer").get_node("ScrollSprite")
			scroll_sprite.play_backwards("unroll")
			await scroll_sprite.animation_finished
			scroll_open = false
			
func close_list_window() -> void:
	var w = get_tree().get_root().find_child("list_window", true, false)
	if w == null:
		return
	w.queue_free()
	state = "NONE"
	update_status()

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
		
