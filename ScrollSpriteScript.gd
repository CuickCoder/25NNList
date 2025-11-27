extends TextureRect
var sway_speed := 1.0
var max_angle := 1.0
var sway_timer := 0.0 

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if !is_any_animation_playing():
		scrollSway(delta)
	else: 
		sway_timer = 0.0 #Gotta reset this! Otherwise scroll snaps to previous pos
		resetScrollRotation(delta)
	pass
	
func scrollSway(delta):
	sway_timer += delta * sway_speed
	rotation_degrees = sin(sway_timer) * max_angle
		
func resetScrollRotation(delta): 
	rotation = lerp_angle(rotation, 0.0, delta * 10.0)
	
func is_any_animation_playing() -> bool:
	#grab all the nodes of type "AnimationPlayer"
	var allAnimPlayers = get_tree().get_root().find_children(
		"AnimationPlayer","AnimationPlayer",true,false)
	#return TRUE if any of the animation players we found are playing anything
	for n in allAnimPlayers:
		if n.is_playing():
			#print(n.name + " playing " + n.current_animation)
			return true
	#no animationplayers are playing, return false
	return false
