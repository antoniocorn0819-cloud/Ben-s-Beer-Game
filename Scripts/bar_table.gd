class_name BarTable extends Table


@export var wait_timer: Timer


func _ready():
	has_beer = false
	debug_beer_indicator.visible = false

func initiate_beer():
	wait_timer.start()

func _on_timer_timeout():
	has_beer = true
	effect_beer_replenished()
	replenished.emit(self)
