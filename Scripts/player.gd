class_name Player extends CharacterBody2D

@export var pivot: Node2D

@export var drinkbox: Area2D
@export var pushbox: Area2D

@export var sprite: AnimatedSprite2D

const pivot_range: float = 30

const speed: float = 395
const push_speed: float = 700
const acceleration: float = 5000
const drink_cooldown: float = 0.5
const push_cooldown: float = 0.2
const step_time: float = 0.1

var current_cooldown: float
var look_vector: Vector2

signal drank
signal coin


enum States {
	moving,
	drinking
}

var current_state: States = States.moving

enum AnimStates {
	moving,
	pushing,
	drinking,
	
}

var current_anim_state: AnimStates

func _physics_process(delta):
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		look_vector = direction
	var attempt_drink: bool = Input.is_action_just_pressed("drink")
	var attempt_push: bool = Input.is_action_just_pressed("push")
	
	current_cooldown -= delta
	
	match current_state:
		States.moving:
			pivot.position = look_vector * pivot_range
			
			velocity = velocity.move_toward(direction * speed, acceleration*delta)
			
			move_and_slide()
			
			if attempt_drink:
				if drink_handler():
					current_state = States.drinking
					current_anim_state = AnimStates.drinking
					sprite.frame = 4
					current_cooldown = drink_cooldown
				
			if attempt_push:
				if push_handler(look_vector):
					current_anim_state = AnimStates.pushing
					current_cooldown = push_cooldown
					sprite.frame = 3
				
		States.drinking:
			velocity = velocity.move_toward(Vector2.ZERO, acceleration*delta)
			
			if current_cooldown <= 0:
				current_state = States.moving
				current_anim_state = AnimStates.moving
				sprite.frame = 2
		
	match current_anim_state:
			AnimStates.moving:
				if velocity.length() <= 10:
					sprite.frame = 2
				else:
					if current_cooldown <= 0:
						if sprite.frame == 2 or sprite.frame == 1:
							sprite.frame = 0
							current_cooldown = step_time
						else:
							sprite.frame = 1
							current_cooldown = step_time
					
			AnimStates.pushing:
				if current_cooldown <= 0:
					current_anim_state = AnimStates.moving
					sprite.frame = 2
			AnimStates.drinking:
				pass

func drink_handler() -> bool:
	
	if drinkbox.get_overlapping_areas().size() <= 0:
		return false
	
	var table: Table = drinkbox.get_overlapping_areas()[0].get_parent()
	
	var drink_succesful = table.player_drink_beer()
	
	if !drink_succesful:
		effect_failed_drink()
		return false
	
	drank.emit()
	return true

func push_handler(dir: Vector2) -> bool:
	if pushbox.get_overlapping_areas().size() <= 0:
		return true
	var thing = pushbox.get_overlapping_areas()[0].get_parent()
	
	if thing is not Waiter:
		var bartender: Bartender = thing
		bartender.attempt_beer()
		return false
	
	
	var waiter: Waiter = pushbox.get_overlapping_areas()[0].get_parent()
	
	waiter.velocity += dir * push_speed
	
	waiter.coin_handler(dir)
	return true


func effect_failed_drink():
	pass


func _on_coin_collector_area_entered(area):
	var thing = area.get_parent()
	
	if thing is not Coin:
		return
	
	var c: Coin = thing
	c.collect_coin()
	coin.emit()
