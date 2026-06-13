class_name Bartender extends StaticBody2D

@export var table_list: Array[BarTable]

@export var game: Main

@export var sprite: AnimatedSprite2D

var available_list: Array[BarTable]

const cooldown: float = 0.8
const thumb_reset_time: float = 0.2

var current_cooldown: float
var thumb_put_down: bool

enum States {
	available,
	cooldown
}

var current_state: States = States.available

func _ready():
	available_list = table_list
	
	for t in table_list:
		t.replenished.connect(table_replenished)

func attempt_beer():
	match current_state:
		States.available:
			print(available_list.size())
			if available_list.size() > 0 and game.data.coins > 0:
				game.on_coin_lost()
				var rand_index = randi_range(0, available_list.size()-1)
				available_list[rand_index].initiate_beer()
				available_list.pop_at(rand_index)
				
				current_cooldown = cooldown
				current_state = States.cooldown
				thumb_put_down = false
				
				
				effect_successful_purchase()
			else:
				effect_reject()

func _process(delta):
	match current_state:
		States.available:
			pass
		States.cooldown:
			
			# print("on cooldown")
			
			current_cooldown -= delta
			if !thumb_put_down and current_cooldown <= thumb_reset_time:
				thumb_put_down = true
				effect_thumb_down()
			if current_cooldown <= 0:
				current_state = States.available

func table_replenished(table: Table):
	available_list.append(table)

func effect_successful_purchase():
	sprite.frame = 1
	

func effect_thumb_down():
	sprite.frame = 0

func effect_reject():
	pass
