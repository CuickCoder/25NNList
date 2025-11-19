extends Control

func add_list_names(list: Array, state: String):
	if list.size() < 5:
		return
	else:
		$Names/Name1.text = str(list[0]) + ": " + state
		$Names/Name2.text = str(list[1]) + ": " + state
		$Names/Name3.text = str(list[2]) + ": " + state
		$Names/Name4.text = str(list[3]) + ": " + state
		$Names/Name5.text = str(list[4]) + ": " + state
