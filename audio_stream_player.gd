extends AudioStreamPlayer

@export var streams : Array[AudioStream]

func _ready() -> void:
	pass

func play_track(id : int) -> void:
	if id >= streams.size() || id < 0: return
	if is_playing: stop()
	stream = streams[id]
	play()
