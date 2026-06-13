class_name BarTable extends Table


@export var wait_timer: Timer

@export var sprite: AnimatedSprite2D
@export var animator: AnimationPlayer

func _ready():
	has_beer = false
	sprite.frame = 0
	

func initiate_beer():
	wait_timer.start()

func _on_timer_timeout():
	print("timer timeout")
	effect_beer_replenished()

func effect_beer_replenished():
	animator.play("Replenish Beer")

func logic_beer_replenished():
	print("animation completed")
	has_beer = true

func effect_player_drink():
	sprite.frame = 0
	replenished.emit(self)
