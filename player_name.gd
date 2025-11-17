extends Label

func adjust_font_to_fit():
	var font: Font = get_theme_font("font")
	if font == null:
		return
		
	var max_width = size.x
	var text_str = text
	var font_size = get_theme_font_size("font_size")
	var min_size = 8
	var width = font.get_string_size(text_str, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x
	while width > max_width and font_size > min_size:
		font_size -= 1
		width = font.get_string_size(text_str, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x
		var override = get_theme_font_size("font_size")
		add_theme_font_size_override("font_size", font_size)
	
