class_name Player extends CharacterBody2D

@export var pivot: Node2D

@export var drinkbox: Area2D
@export var pushbox: Area2D

const pivot_range: float = 70

const speed: float = 500
const push_speed: float = 700
const acceleration: float = 5000

var look_vector: Vector2

signal drank
signal coin

func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		look_vector = direction
	var attempt_drink: bool = Input.is_action_just_pressed("drink")
	var attempt_push: bool = Input.is_action_just_pressed("push")
	pivot.position = look_vector * pivot_range
	
	velocity = velocity.move_toward(direction * speed, acceleration*delta)
	
	move_and_slide()
	
	if attempt_drink:
		drink_handler()
	if attempt_push:
		push_handler(look_vector)

func drink_handler():
	
	if drinkbox.get_overlapping_areas().size() <= 0:
		return
	
	var table: Table = drinkbox.get_overlapping_areas()[0].get_parent()
	
	var drink_succesful = table.player_drink_beer()
	
	if !drink_succesful:
		effect_failed_drink()
		return
	
	drank.emit()

func push_handler(dir: Vector2):
	if pushbox.get_overlapping_areas().size() <= 0:
		return
	var thing = pushbox.get_overlapping_areas()[0].get_parent()
	
	if thing is not Waiter:
		var bartender: Bartender = thing
		bartender.attempt_beer()
		return
	
	
	var waiter: Waiter = pushbox.get_overlapping_areas()[0].get_parent()
	
	waiter.velocity += dir * push_speed
	
	waiter.coin_handler(dir)
	


func effect_failed_drink():
	pass


func _on_coin_collector_area_entered(area):
	var thing = area.get_parent()
	
	if thing is not Coin:
		return
	
	var c: Coin = thing
	c.collect_coin()
	coin.emit()
