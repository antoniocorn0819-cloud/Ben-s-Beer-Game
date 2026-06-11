class_name Waiter extends CharacterBody2D

@export var agent: NavigationAgent2D
@export var player: Player
@export var game: Game 

@export var restock_point: Marker2D

const speed: float = 200
const acceleration: float = 2000
const range: float = 10
const max_beers: int = 2

enum States {
	waiting,
	restocking
}

var current_state: States = States.restocking

var waiting_list: Array[Table]
var waiting_list_size: int
var current_table_waiting: int

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
				
				waiting_list = game.new_table_list(max_beers)
				waiting_list_size = waiting_list.size()
				current_table_waiting = 0
				
				if waiting_list_size <= 0:
					return
				current_state = States.waiting
				agent.target_position = waiting_list[current_table_waiting].marker.global_position
		States.waiting:
			if current_range < range:
				waiting_list[current_table_waiting].has_beer = true
				waiting_list[current_table_waiting].effect_beer_replenished()
				current_table_waiting += 1
				
				
				if current_table_waiting >= waiting_list_size:
					agent.target_position = restock_point.position
					current_state = States.restocking
					return
				
				agent.target_position = waiting_list[current_table_waiting].marker.global_position
	
	
	
	


func _on_pathfinding_timer_timeout():
	pass
