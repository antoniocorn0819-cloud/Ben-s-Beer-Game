class_name Waiter extends CharacterBody2D

@export var agent: NavigationAgent2D
@export var player: Player
@export var game: Main

@export var restock_point: Marker2D

var coin_scene: PackedScene = load("res://Scenes/coin.tscn")
const speed: float = 200
const acceleration: float = 2000
const range: float = 10
const max_beers: int = 2
const coin_chance: float = 1.0
const coin_throw_speed: = 600

enum States {
	waiting,
	restocking
}

var current_state: States = States.restocking

var waiting_list: Array[Table]
var waiting_list_size: int
var current_table_waiting: int

var coins_held: int = 10

func _ready():
	agent.target_position = restock_point.position

#func update_navigation():
	#agent.target_position = player.global_position




func _physics_process(delta):
	var current_range: float = (agent.target_position - global_position).length()
	
	var direction = global_position.direction_to(agent.get_next_path_position())
	velocity = velocity.move_toward(direction * speed, delta*acceleration)
	move_and_slide()
	
	
	match current_state:
		States.restocking:
			if current_range < range:
				
				# happens on reaching restock point
				
				coins_held = 0
				
				waiting_list = game.new_table_list(max_beers)
				waiting_list_size = waiting_list.size()
				current_table_waiting = 0
				
				if waiting_list_size <= 0:
					return
				current_state = States.waiting
				agent.target_position = waiting_list[current_table_waiting].marker.global_position
		States.waiting:
			if current_range < range:
				# Happens once each table is waited
				
				waiting_list[current_table_waiting].replenish_beer()
				current_table_waiting += 1
				
				if randf() <= coin_chance:
					coins_held += 1
					effect_tip_recieved()
				
				if current_table_waiting >= waiting_list_size:
					
					# Happens on last table waited
					agent.target_position = restock_point.position
					current_state = States.restocking
					return
				
				agent.target_position = waiting_list[current_table_waiting].marker.global_position

func coin_handler(base_vel: Vector2):
	while coins_held > 0:
		var coin: Coin = coin_scene.instantiate()
		coin.velocity = base_vel.rotated(randf_range(-PI/2, PI/2)) * coin_throw_speed * randf_range(0.7, 1)
		coin.global_position = global_position
		game.add_child(coin)
		coins_held -= 1



func effect_tip_recieved():
	pass

func _on_pathfinding_timer_timeout():
	pass
