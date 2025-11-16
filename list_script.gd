extends Panel

func add_list_names(list: Array, state: String):
	if list.size() < 5:
		return
	else:
		$Names/Name1.text = str(list[0]) + "\n" + state
		$Names/Name2.text = str(list[1]) + "\n" + state
		$Names/Name3.text = str(list[2]) + "\n" + state
		$Names/Name4.text = str(list[3]) + "\n" + state
		$Names/Name5.text = str(list[4]) + "\n" + state
