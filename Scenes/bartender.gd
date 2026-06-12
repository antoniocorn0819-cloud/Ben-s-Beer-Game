class_name Bartender extends StaticBody2D

@export var table_list: Array[BarTable]

@export var game: Main

var available_list: Array[BarTable]


func _ready():
	available_list = table_list
	
	for t in table_list:
		t.replenished.connect(table_replenished)

func attempt_beer():
	print(available_list.size())
	if available_list.size() > 0 and game.data.coins > 0:
		game.on_coin_lost()
		var rand_index = randi_range(0, available_list.size()-1)
		available_list[rand_index].initiate_beer()
		available_list.pop_at(rand_index)
		effect_successful_purchase()
	else:
		effect_reject()

		

func table_replenished(table: Table):
	available_list.append(table)

func effect_successful_purchase():
	pass

func effect_reject():
	pass
