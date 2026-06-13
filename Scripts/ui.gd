class_name Numbers extends Control

@export var beer_label: Label
@export var coin_label: Label

func gui_update(data: GameData):
	beer_label.text = "BEERS : " + str(data.total_beers)
	coin_label.text = "COINS : " + str(data.coins)
	
