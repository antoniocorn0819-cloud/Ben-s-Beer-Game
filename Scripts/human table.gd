class_name HumanTable extends Table

@export var human_timer: Timer

@export var sprite: AnimatedSprite2D

const drink_timer: float = 1.0
var current_drink_timer: float

func _ready():
	has_beer = false
	replenished.connect(start_human_timer)

func start_human_timer(table: Table):
	human_timer.start()
	print("did something")


func human_drink_beer():
	if has_beer:
		has_beer = false
		effect_human_drink()

func _process(delta):
	current_drink_timer -= delta
	if current_drink_timer <= 0 and !has_beer:
		sprite.frame = 0

func _on_human_timer_timeout():
	human_drink_beer()

func effect_human_drink():
	sprite.frame = 1
	current_drink_timer = drink_timer

func effect_player_drink():
	sprite.frame = 0

func effect_beer_replenished():
	sprite.frame = 2
