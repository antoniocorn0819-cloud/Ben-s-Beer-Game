class_name HumanTable extends Table

@export var human_timer: Timer

func _ready():
	has_beer = false
	debug_beer_indicator.visible = false
	replenished.connect(start_human_timer)

func start_human_timer(table: Table):
	human_timer.start()
	print("did something")


func human_drink_beer():
	has_beer = false
	effect_human_drink()


func _on_human_timer_timeout():
	human_drink_beer()

func effect_human_drink():
	debug_beer_indicator.visible = false
