class_name Coin extends CharacterBody2D
const friction: float = 1000

func collect_coin():
	queue_free()


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta * friction)
	move_and_slide()
