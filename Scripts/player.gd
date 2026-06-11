class_name Player extends CharacterBody2D

@export var pivot: Node2D

@export var drinkbox: Area2D
@export var pushbox: Area2D

const pivot_range: float = 70

const speed: float = 500
const push_speed: float = 700
const acceleration: float = 5000

signal drank

func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var attempt_drink: bool = Input.is_action_just_pressed("drink")
	var attempt_push: bool = Input.is_action_just_pressed("push")
	pivot.position = direction * pivot_range
	
	velocity = velocity.move_toward(direction * speed, acceleration*delta)
	
	move_and_slide()
	
	if attempt_drink:
		drink_handler()
	if attempt_push:
		push_handler(direction)

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
	print(pushbox.get_overlapping_areas().size())
	if pushbox.get_overlapping_areas().size() <= 0:
		print("push failed")
		return
	var waiter: Waiter = pushbox.get_overlapping_areas()[0].get_parent()
	print(waiter.velocity)
	waiter.velocity += dir * push_speed
	print(waiter.velocity)

func effect_failed_drink():
	pass
