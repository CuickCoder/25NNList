extends TextureRect
var sway_speed := 1.0
var max_angle := 1.0
var sway_timer := 0.0 

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	handleScrollSwaying(delta)
	pass

func handleScrollSwaying(delta):
	if !is_any_animation_playing():
		#if no animation is playing, we can sway the scroll with a sine wave
		sway_timer += delta * sway_speed
		rotation_degrees = sin(sway_timer) * max_angle
	else: 
		#quickly rotate the scroll back to 0 if animation is playing
		rotation = lerp_angle(rotation, 0.0, delta * 10.0)
		#Reset this! Otherwise scroll sway resumes at previous rotation
		sway_timer = 0.0 
	pass

func is_any_animation_playing() -> bool:
	var allAnimPlayers = get_tree().get_root().find_children(
		"AnimationPlayer","AnimationPlayer",true,false)
	for n in allAnimPlayers:
		if n.is_playing():
			return true
	return false
