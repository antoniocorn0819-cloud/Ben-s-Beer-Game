class_name bar_seg extends StaticBody2D

var has_beer: bool = true

@export var debug_beer_indicator: Sprite2D

func player_drink_beer() -> bool:
	if not has_beer:
		return false
	
	has_beer = false
	effect_player_drink()
	return true
	

func effect_player_drink():
	debug_beer_indicator.visible = false

func effect_beer_replenished():
	debug_beer_indicator.visible = true

func _physics_process(delta):
	if Input.is_action_just_pressed("debug reset beers"):
		has_beer = true
		effect_beer_replenished()
