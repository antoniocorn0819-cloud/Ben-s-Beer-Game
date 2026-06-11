class_name Game extends Node2D


var data: GameData = GameData.new()

@export var plyr: Player
@export var numb: Numbers
@export var tables: Array[Table]


func _ready() -> void:
	plyr.drank.connect(on_drink)


func on_drink() -> void:
	data.total_beers += 1
	numb.gui_update(data)
	

func new_table_list(max: int) -> Array[Table]:
	var temp_array_1: Array[Table] = []
	var temp_array_2: Array[Table] = []
	var i: int = 0
	
	while i < tables.size():
		# change to function
		
		if tables[i].has_beer == false:
			temp_array_1.append(tables[i])
		
		i += 1
	
	i = 0
	
	while i < max and temp_array_1.size() > 0:
		print(temp_array_1.size())
		
		var random_index = randi_range(0, temp_array_1.size() - 1)
		temp_array_2.append(temp_array_1[random_index])
		temp_array_1.pop_at(random_index)
		i += 1
	
	return temp_array_2
