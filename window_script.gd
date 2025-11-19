extends Window

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if mode != Window.MODE_FULLSCREEN:
			mode = Window.MODE_FULLSCREEN

	if event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		if mode != Window.MODE_FULLSCREEN:
			mode = Window.MODE_FULLSCREEN
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if mode == Window.MODE_FULLSCREEN:
			mode = Window.MODE_WINDOWED
		else:
			queue_free()
