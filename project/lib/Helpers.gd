extends Node

func pick_randomly_from_array(choice_array):
	var array_size = choice_array.size()
	var selection = randi()%array_size
	return choice_array[selection]