extends Control

var design_size := Vector2(3840, 2160)

func on_resized():
	var new_size := get_viewport_rect().size
	var scale_x = new_size.x / design_size.x
	var scale_y = new_size.y / design_size.y
	
	var uniform_scale = min(scale_x, scale_y)
	scale = Vector2(uniform_scale, uniform_scale)
